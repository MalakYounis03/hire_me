const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();

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
      },
      token: fcmToken,
    };

    try {
      await admin.messaging().send(message);
    } catch (err) {
      functions.logger.error('Failed to send FCM push', err);
    }

    return null;
  });
