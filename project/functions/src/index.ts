import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { MessagingPayload } from "firebase-admin/lib/messaging/messaging-api";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

/**
 * Sends notifications to the given list of users with the given payload.
 *
 * @param users the users to send notifications to.
 * @param payload the payload to send, the contents of the notification.
 */
function notifyToUsers(users: string[], payload: MessagingPayload) {
  users.forEach((user) => {
    db.collection("users")
      .doc(user)
      .collection("tokens")
      .get()
      .then((querySnapshot) => {
        const tokens = querySnapshot.docs.map((snap) => snap.id);
        fcm.sendToDevice(tokens, payload);
      });
  });
}

/**
 * Retrieves the document of the user with the given user id.
 *
 * @param userId the id of the user to retrieve.
 * @returns document data of the user of the given user id, returns
 * undefined if user with the id was not found.
 */
async function getUser(userId: string) {
  const document = await db.collection("users").doc(userId).get();
  return document.data();
}

/**
 * Retrieves the task with the given task id from the project of the given project id.
 *
 * @param projectId the id of project to get the task from.
 * @param taskId the id of the task to get.
 * @returns returns a task object or undefined if not found.
 */
async function getTask(projectId: string, taskId: string) {
  const document = await db
    .collection("projects")
    .doc(projectId)
    .collection("tasks")
    .doc(taskId)
    .get();
  return document.data();
}

/**
 * Retrieves the project with the given project id.
 *
 * @param projectId the id of the project to get.
 * @returns returns the project with the given project id, if not
 * found returns undefined.
 */
async function getProject(projectId: string) {
  const document = await db
    .collection("projects")
    .doc(projectId)

    .get();
  return document.data();
}

/**
 * Notifies the assignees on the task there is a new comment.
 */
export const notifyAssigneesAndOwnerAboutNewComment = functions.firestore
  .document("projects/{pid}/tasks/{tid}/comments/{cid}")
  .onCreate(async (snapshot, context) => {
    const comment = snapshot.data();
    const authorId = comment.author;
    const taskId = context.params.tid;
    const projectId = context.params.pid;

    getTask(projectId, taskId).then((task) => {
      if (task == undefined) return;

      getProject(projectId).then((project) => {
        if (project == undefined) return;

        const sendTo: string[] = [];
        task.assigned.forEach((assignee: string) => {
          if (authorId.valueOf != assignee.valueOf) {
            sendTo.push(assignee);
          }
        });

        if (!sendTo.includes(project.owner)) {
          sendTo.push(project.owner);
        }

        getUser(authorId).then((user) => {
          if (user == undefined) return;
          notifyToUsers(sendTo, {
            notification: {
              title: `${user.username} commented on a task you're assigned to`,
              body: `${user.username} commented on a task you're assigned to`,
              sound: "default",
              badge: "1",
              icon: "https://solveit.works/images/Icon.png",
              clickAction: "FLUTTER_NOTIFICATION_CLICK",
            },
          });
        });
      });
    });
  });

/**
 * Sends a notifications to users if they got added or removed as collaborators.
 */
export const notifyChangesInProjectCollaborators = functions.firestore //// TODO: DOESNT WORK
  .document("projects/{pid}")
  .onUpdate(async (snapshot) => {
    const project = snapshot.after.data();
    const oldCollaboratorsList: string[] = snapshot.before.data().collaborators;
    const newCollaboratorsList: string[] = snapshot.after.data().collaborators;

    const newUsers: string[] = [];
    const removedUsers: string[] = [];

    newUsers.push(
      ...newCollaboratorsList.filter(
        (user) => !oldCollaboratorsList.includes(user)
      )
    );

    removedUsers.push(
      ...oldCollaboratorsList.filter(
        (user) => !newCollaboratorsList.includes(user)
      )
    );

    notifyToUsers(newUsers, {
      notification: {
        title: `You got added as a collaborator to the project \"${project.title}\"!`,
        body: `You got added as a collaborator to the project \"${project.title}\"!`,
        sound: "default",
        badge: "1",
        icon: "https://solveit.works/images/Icon.png",
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    });

    notifyToUsers(removedUsers, {
      notification: {
        title: `You got removed from the project \"${project.title}\"!`,
        body: `You got removed from the project \"${project.title}\"!`,
        sound: "default",
        badge: "1",
        icon: "https://solveit.works/images/Icon.png",
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    });
  });

/**
 * Sends a notification to the user's assigned to the task that it
 * got solved and who solved it.
 */
export const notifyAssigneesAndOwnerTaskStatusToggled = functions.firestore
  .document("projects/{pid}/tasks/{tid}")
  .onUpdate(async (snapshot, context) => {
    const oldValue = snapshot.before.data();
    const newValue = snapshot.after.data();
    const userId = newValue.updatedBy;
    const projectId = context.params.pid;

    if (newValue != undefined && oldValue != undefined) {
      getUser(userId).then((user) => {
        if (user == undefined) return;
        getProject(projectId).then((project) => {
          if (project == undefined) return;

          const sendTo: string[] = [];
          sendTo.push(...newValue.assigned);
          sendTo.splice(sendTo.indexOf(userId), 1);
          if (!sendTo.includes(project.owner)) {
            sendTo.push(project.owner);
          }

          if (newValue.done == true) {
            notifyToUsers(newValue.assigned, {
              notification: {
                title: `${user.username} solved the task \"${newValue.title}\"!`,
                body: `${user.username} solved the task \"${newValue.title}\"!`,
                sound: "default",
                badge: "1",
                icon: "https://solveit.works/images/Icon.png",
                clickAction: "FLUTTER_NOTIFICATION_CLICK",
              },
            });
          } else {
            notifyToUsers(newValue.assigned, {
              notification: {
                title: `${user.username} reopened the task \"${newValue.title}\"!`,
                body: `${user.username} reopened the task \"${newValue.title}\"!`,
                sound: "default",
                badge: "1",
                icon: "https://solveit.works/images/Icon.png",
                clickAction: "FLUTTER_NOTIFICATION_CLICK",
              },
            });
          }
        });
      });
    }
  });

/**
 * Sends notifications to the users in a chat group that there was a new
 * message sent to the chat messages.
 */
export const notifyNewMessageToUsers = functions.firestore
  .document("chats/{gid}/messages/{mid}")
  .onCreate(async (snapshot, context) => {
    const message = snapshot.data();
    console.log(message);

    const sentFrom = message.author;
    const groupId = context.params.gid;
    let content = "";
    let type = "";

    if (message.text != undefined) {
      content = message.text;
      type = "message";
    } else if (message.imageUrl != undefined) {
      content = message.imageUrl;
      if (content.startsWith("https://tenor.googleapis.com/v2")) {
        type = "gif";
      } else {
        type = "image";
      }
    }

    db.collection("groups")
      .doc(groupId)
      .get()
      .then((querySnapshot) => {
        const group = querySnapshot.data();

        if (group != undefined) {
          const sendTo = new Set<string>([]);
          sendTo.add(group.members);

          if (sendTo.has(sentFrom)) sendTo.delete(sentFrom);

          getUser(sentFrom).then((user) => {
            if (user != undefined) {
              const message =
                type.valueOf == "text".valueOf
                  ? "Sent a message"
                  : type.valueOf == "gif".valueOf
                  ? "Sent a gif"
                  : "Sent an image";
              notifyToUsers(Array.from(sendTo), {
                notification: {
                  title: message,
                  body: message,
                  icon: "https://solveit.works/images/Icon.png",
                  sound: "default",
                  badge: "1",
                  clickAction: "FLUTTER_NOTIFICATION_CLICK",
                },
              });
            }
          });
        }
      });
  });
