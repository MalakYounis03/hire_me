<<<<<<< HEAD
const functions = require('firebase-functions');
=======
const { onDocumentCreated, onDocumentUpdated } = require('firebase-functions/v2/firestore');
const { onValueCreated } = require('firebase-functions/v2/database');
const { logger } = require('firebase-functions/logger');
>>>>>>> d876662e8fae7e65815765a3ea2ee263dc3aa461
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();

<<<<<<< HEAD
exports.onApplicationStatusChange = functions.firestore
  .document('applications/{applicationId}')
  .onWrite(async (change, context) => {
    const { applicationId } = context.params;
    const before = change.before.data();
    const after = change.after.data();

    if (!before && !after) return null;
    if (!after) return null;

    const newStatus = after.status;
    const oldStatus = before ? before.status : null;

    if (!newStatus || newStatus === oldStatus) return null;
    if (newStatus !== 'Accepted' && newStatus !== 'Rejected') return null;

    const applicantId = after.applicantId || after.jobSeekerId || after.seekerId;
    const jobTitle = after.jobTitle || 'a position';
    const companyName = after.companyName || 'a company';

    if (!applicantId) return null;

    const title = newStatus === 'Accepted'
      ? 'Application Accepted!'
      : 'Application Rejected';

    const body = newStatus === 'Accepted'
      ? `Your application for ${jobTitle} at ${companyName} has been accepted.`
      : `Your application for ${jobTitle} at ${companyName} has been rejected.`;

    const icon = newStatus === 'Accepted' ? 'check_circle' : 'visibility';

    try {
      await db.collection('notifications').doc(applicantId).collection('items').add({
        title,
        body,
        icon,
        isRead: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        type: 'application_update',
        applicationId,
        jobTitle,
        companyName,
        status: newStatus,
      });
    } catch (err) {
      functions.logger.error('Failed to write notification document', err);
    }

    let fcmToken = after.applicantFcmToken;
    if (!fcmToken) {
      try {
        const seekerDoc = await db.collection('jobSeekers').doc(applicantId).get();
        fcmToken = seekerDoc.data()?.fcmToken;
      } catch (err) {
        functions.logger.error('Failed to fetch FCM token', err);
        return null;
      }
    }

    if (!fcmToken) {
      functions.logger.warn(`No FCM token for applicant ${applicantId}`);
      return null;
    }

    const message = {
      notification: { title, body },
      data: {
        type: 'application_update',
        applicationId,
        status: newStatus,
        jobTitle: jobTitle || '',
        companyName: companyName || '',
=======
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

    // Write notification to Firestore unconditionally (in-app badge/list)
    try {
      await db
        .collection('notifications').doc(companyId).collection('items')
        .add({
          type: 'new_application',
          title: 'New Application Received 📋',
          body: `${applicantName} applied for ${jobTitle}`,
          applicationId,
          isRead: false,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      logger.info(`Notification document written for company ${companyId}`);
    } catch (err) {
      logger.error('Failed to write notification document', err);
    }

    // FCM push is best-effort — do not gate anything on it
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
    logger.info(`FCM token found for company ${companyId} (len=${fcmToken.length})`);

    const message = {
      notification: {
        title: 'New Application Received 📋',
        body: `${applicantName} applied for ${jobTitle}`,
      },
      data: {
        type: 'new_application',
        applicationId,
>>>>>>> d876662e8fae7e65815765a3ea2ee263dc3aa461
      },
      token: fcmToken,
    };

    try {
      await admin.messaging().send(message);
<<<<<<< HEAD
    } catch (err) {
      functions.logger.error('Failed to send FCM push', err);
    }

    return null;
  });
=======
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

    // Write notification to Firestore unconditionally
    try {
      await db
        .collection('notifications').doc(jobSeekerId).collection('items')
        .add({
          type: 'application_update',
          title: 'Application Accepted! 🎉',
          body: `Your application for ${jobTitle} has been accepted`,
          applicationId,
          isRead: false,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      logger.info(`Notification document written for job seeker ${jobSeekerId}`);
    } catch (err) {
      logger.error('Failed to write notification document', err);
    }

    // FCM push is best-effort
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
// Function 3: Application rejected → notify seeker
// ─────────────────────────────────────────────
exports.onApplicationRejected = onDocumentUpdated(
  'applications/{applicationId}',
  async (event) => {
    const { applicationId } = event.params;
    const before = event.data.before.data();
    const after = event.data.after.data();

    if (!after) return;
    if (after.status !== 'Rejected') return;
    if (before && before.status === 'Rejected') return;

    const jobSeekerId = after.seekerId || after.jobSeekerId;
    const jobTitle = after.jobTitle || 'a position';

    if (!jobSeekerId) {
      logger.warn(`No jobSeekerId on application ${applicationId}`);
      return;
    }

    // Write notification to Firestore unconditionally
    try {
      await db
        .collection('notifications').doc(jobSeekerId).collection('items')
        .add({
          type: 'application_update',
          title: 'Application Update',
          body: `Unfortunately, your application for ${jobTitle} was not accepted`,
          applicationId,
          isRead: false,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      logger.info(`Notification document written for job seeker ${jobSeekerId}`);
    } catch (err) {
      logger.error('Failed to write notification document', err);
    }

    // FCM push is best-effort
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
        title: 'Application Update',
        body: `Unfortunately, your application for ${jobTitle} was not accepted`,
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
        `Notification sent to job seeker ${jobSeekerId} for rejected application`,
      );
    } catch (err) {
      logger.error('Failed to send FCM push', err);
    }
  },
);

// ─────────────────────────────────────────────
// Function 4: New chat message → notify recipient
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
      }
    } else if (senderId === seekerId) {
      receiverId = companyId;
      senderDisplayName = seekerName || 'Job Seeker';
      try {
        const companyDoc = await db.collection('companies').doc(companyId).get();
        fcmToken = companyDoc.data()?.fcmToken;
      } catch (err) {
        logger.error(`Failed to read company doc for ${companyId}`, err);
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

    const messageText = data.text || '';
    if (!messageText) {
      logger.warn('Empty message text, skipping notification');
      return;
    }

    // Write notification to Firestore unconditionally
    if (receiverId) {
      try {
        await db
          .collection('notifications').doc(receiverId).collection('items')
          .add({
            type: 'chat_message',
            title: senderDisplayName,
            body: messageText,
            chatId,
            isRead: false,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        logger.info(`Notification document written for receiver ${receiverId}`);
      } catch (err) {
        logger.error('Failed to write notification document', err);
      }
    }

    // FCM push is best-effort
    if (!fcmToken) {
      logger.warn(`No FCM token for receiver ${receiverId}`);
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
>>>>>>> d876662e8fae7e65815765a3ea2ee263dc3aa461
