const { onDocumentCreated, onDocumentUpdated } = require('firebase-functions/v2/firestore');
const { onValueCreated } = require('firebase-functions/v2/database');
const { logger } = require('firebase-functions/logger');
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();

// ─────────────────────────────────────────────
// Function 1: New application → notify company
// ─────────────────────────────────────────────
exports.onNewApplication = onDocumentCreated(
  'applications/{applicationId}',
  async (event) => {
    const { applicationId } = event.params;
    const data = event.data.data();

    if (!data) {
      logger.warn(`No data for application ${applicationId}`);
      return;
    }

    const companyId = data.companyId;
    const applicantName = data.seekerName || 'Someone';
    const jobTitle = data.jobTitle || 'a position';

    if (!companyId) {
      logger.warn(`No companyId on application ${applicationId}`);
      return;
    }

    let fcmToken;
    try {
      const companyDoc = await db.collection('companies').doc(companyId).get();
      fcmToken = companyDoc.data()?.fcmToken;
    } catch (err) {
      logger.error(`Failed to read company doc for ${companyId}`, err);
      return;
    }

    if (!fcmToken) {
      logger.warn(`No FCM token for company ${companyId}`);
      return;
    }

    const message = {
      notification: {
        title: 'New Application Received 📋',
        body: `${applicantName} applied for ${jobTitle}`,
      },
      data: {
        type: 'new_application',
        applicationId,
      },
      token: fcmToken,
    };

    try {
      await admin.messaging().send(message);
      logger.info(`Notification sent to company ${companyId} for new application`);
    } catch (err) {
      logger.error('Failed to send FCM push', err);
    }
  },
);

// ─────────────────────────────────────────────
// Function 2: Application accepted → notify seeker
// ─────────────────────────────────────────────
exports.onApplicationAccepted = onDocumentUpdated(
  'applications/{applicationId}',
  async (event) => {
    const { applicationId } = event.params;
    const before = event.data.before.data();
    const after = event.data.after.data();

    if (!after) return;
    if (after.status !== 'Accepted') return;
    if (before && before.status === 'Accepted') return;

    const jobSeekerId = after.seekerId || after.jobSeekerId;
    const jobTitle = after.jobTitle || 'a position';

    if (!jobSeekerId) {
      logger.warn(`No jobSeekerId on application ${applicationId}`);
      return;
    }

    let fcmToken;
    try {
      const seekerDoc = await db.collection('jobSeekers').doc(jobSeekerId).get();
      fcmToken = seekerDoc.data()?.fcmToken;
    } catch (err) {
      logger.error(`Failed to read jobSeeker doc for ${jobSeekerId}`, err);
      return;
    }

    if (!fcmToken) {
      logger.warn(`No FCM token for job seeker ${jobSeekerId}`);
      return;
    }

    const message = {
      notification: {
        title: 'Application Accepted! 🎉',
        body: `Congratulations! Your application for ${jobTitle} has been accepted`,
      },
      data: {
        type: 'application_update',
        applicationId,
      },
      token: fcmToken,
    };

    try {
      await admin.messaging().send(message);
      logger.info(
        `Notification sent to job seeker ${jobSeekerId} for accepted application`,
      );
    } catch (err) {
      logger.error('Failed to send FCM push', err);
    }
  },
);

// ─────────────────────────────────────────────
// Function 3: New chat message → notify recipient
// ─────────────────────────────────────────────
exports.onNewChatMessage = onValueCreated(
  'chats/{chatId}/messages/{pushId}',
  async (event) => {
    const { chatId } = event.params;
    const data = event.data.val();

    if (!data) return;

    const senderId = data.senderId;
    if (!senderId) return;

    let chatData;
    try {
      const chatSnapshot = await admin
        .database()
        .ref(`chats/${chatId}`)
        .once('value');
      chatData = chatSnapshot.val();
    } catch (err) {
      logger.error(`Failed to read chat ${chatId}`, err);
      return;
    }

    if (!chatData) {
      logger.warn(`Chat ${chatId} not found`);
      return;
    }

    const { companyId, seekerId, companyName, seekerName } = chatData;

    if (!companyId || !seekerId) {
      logger.warn(`Chat ${chatId} missing participant IDs`);
      return;
    }

    let receiverId;
    let senderDisplayName;
    let fcmToken;

    if (senderId === companyId) {
      receiverId = seekerId;
      senderDisplayName = companyName || 'Company';
      try {
        const seekerDoc = await db.collection('jobSeekers').doc(seekerId).get();
        fcmToken = seekerDoc.data()?.fcmToken;
      } catch (err) {
        logger.error(`Failed to read jobSeeker doc for ${seekerId}`, err);
        return;
      }
    } else if (senderId === seekerId) {
      receiverId = companyId;
      senderDisplayName = seekerName || 'Job Seeker';
      try {
        const companyDoc = await db.collection('companies').doc(companyId).get();
        fcmToken = companyDoc.data()?.fcmToken;
      } catch (err) {
        logger.error(`Failed to read company doc for ${companyId}`, err);
        return;
      }
    } else {
      logger.warn(
        `Sender ${senderId} is neither company nor seeker in chat ${chatId}`,
      );
      return;
    }

    if (senderId === receiverId) {
      logger.warn(`Sender and receiver are the same in chat ${chatId}, skipping`);
      return;
    }

    if (!fcmToken) {
      logger.warn(`No FCM token for receiver ${receiverId}`);
      return;
    }

    const messageText = data.text || '';
    if (!messageText) {
      logger.warn('Empty message text, skipping notification');
      return;
    }

    const message = {
      notification: {
        title: senderDisplayName,
        body: messageText,
      },
      data: {
        type: 'chat_message',
        chatId,
        senderId,
      },
      token: fcmToken,
    };

    try {
      await admin.messaging().send(message);
      logger.info(`Chat notification sent to ${receiverId} from ${senderId}`);
    } catch (err) {
      logger.error('Failed to send chat notification', err);
    }
  },
);
