// import 'package:intl/intl.dart';
// import 'package:project/models/user.dart';

// import '../models/comment.dart';
// import '../models/project.dart';
// import '../models/tag.dart';
// import '../models/task.dart';

// /// Temp list for testing.
// class ExampleData {
//   static User user1 = User(
//     username: "Espen Otlo",
//     email: "eo@example.com",
//     bio: "My goal is to be a fulltime Flutter developer",
//     imageUrl: "assets/images/leslie_alexander.png",
//   );

//   static User user2 = User(
//     username: "Sakarias Sæterstøl",
//     email: "ss@example.com",
//     bio: "Pineapple on pizza is the way to go",
//     imageUrl: "assets/images/guy_hawkins.png",
//   );

//   static List<Project> projects = [
//     Project(
//       title: "Household",
//       tags: tags,
//       owner: user1.userId,
//       collaborators: [
//         user1.userId,
//         user2.userId,
//       ],
//       isPublic: true,
//       imageUrl: "assets/images/project_1.png",
//       description:
//           "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
//       lastUpdated:
//           DateFormat("dd.MM.yyyy").parse("22.11.2022").toIso8601String(),
//       tasks: [
//         Task(
//             title: "Vacuum the house",
//             description: "Vacuum the living room, hallway and kitchen.",
//             deadline: DateFormat("dd.MM.yyyy").parse("23.11.2022"),
//             assigned: [
//               user1.userId
//             ],
//             comments: [
//               TextComment(
//                   author: user1,
//                   date: DateFormat("dd.MM.yyyy").parse("18.10.2022"),
//                   text: "Only had time to vacuum the living room and hallway."),
//               TextComment(
//                   author: user2,
//                   date: DateFormat("dd.MM.yyyy").parse("19.10.2022"),
//                   text:
//                       "That's okay, your mother and I still love you. You can do the rest tomorrow."),
//             ],
//             tags: [
//               Tag(
//                 text: "urgent",
//                 color: "#FFFF0000",
//               ),
//               Tag(
//                 text: "urgent",
//                 color: "#FFFF0000",
//               ),
//               Tag(
//                 text: "urgent",
//                 color: "#FFFF0000",
//               ),
//               Tag(
//                 text: "urgent",
//                 color: "#FFFF0000",
//               ),
//               Tag(
//                 text: "urgent",
//                 color: "#FFFF0000",
//               ),
//               Tag(
//                 text: "urgent",
//                 color: "#FFFF0000",
//               ),
//               Tag(
//                 text: "urgent",
//                 color: "#FFFF0000",
//               ),
//               Tag(
//                 text: "urgent",
//                 color: "#FFFF0000",
//               ),
//               Tag(
//                 text: "urgent",
//                 color: "#FFFF0000",
//               ),
//               Tag(
//                 text: "urgent",
//                 color: "#FFFF0000",
//               ),
//               Tag(
//                 text: "urgent",
//                 color: "#FFFF0000",
//               ),
//             ]),
//         Task(
//           title: "Water flowers",
//           deadline: DateFormat("dd.MM.yyyy").parse("15.11.2022"),
//           description:
//               "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
//           assigned: [user2.userId],
//           tags: <Tag>[
//             Tag(
//               text: "green",
//               color: "#FF8BC34A",
//             ),
//             Tag(
//               text: "fun",
//               color: "#FF0400FF",
//             ),
//           ],
//         ),
//       ],
//     ),
//     Project(
//       title: "Gardening",
//       tags: tags,
//       owner: user2.userId,
//       collaborators: [
//         user1.userId,
//         user2.userId,
//       ],
//       imageUrl: "assets/images/project_3.png",
//       description:
//           "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
//       lastUpdated:
//           DateFormat("dd.MM.yyyy").parse("22.11.2022").toIso8601String(),
//       tasks: [
//         Task(
//             title: "Vacuum the house",
//             description: "Vacuum the living room, hallway and kitchen.",
//             deadline: DateFormat("dd.MM.yyyy").parse("23.11.2022"),
//             assigned: [
//               user1.userId
//             ],
//             comments: [
//               TextComment(
//                   author: user1,
//                   date: DateFormat("dd.MM.yyyy").parse("18.11.2022"),
//                   text: "Only had time to vacuum the living room and hallway."),
//               TextComment(
//                   author: user2,
//                   date: DateFormat("dd.MM.yyyy").parse("19.11.2022"),
//                   text:
//                       "That's okay, your mother and I still love you. \nYou can do the rest tomorrow."),
//             ],
//             tags: [
//               Tag(
//                 text: "urgent",
//                 color: "#FF0000",
//               ),
//             ]),
//         Task(
//           title: "Water flowers",
//           deadline: DateFormat("dd.MM.yyyy").parse("15.11.2022"),
//           description:
//               "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
//           assigned: [user2.userId],
//           tags: <Tag>[
//             Tag(
//               text: "green",
//               color: "#8BC34A",
//             ),
//             Tag(
//               text: "fun",
//               color: "#0400FF",
//             ),
//           ],
//         ),
//       ],
//     ),
//     Project(
//       title: "school",
//       tags: tags,
//       owner: user1.userId,
//       collaborators: [
//         user1.userId,
//         user2.userId,
//       ],
//       imageUrl: "assets/images/project_2.png",
//       description:
//           "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
//       lastUpdated:
//           DateFormat("dd.MM.yyyy").parse("22.11.2022").toIso8601String(),
//       tasks: [
//         Task(
//             title: "Vacuum the house",
//             description: "Vacuum the living room, hallway and kitchen.",
//             deadline: DateFormat("dd.MM.yyyy").parse("23.11.2022"),
//             assigned: [
//               user1.userId
//             ],
//             comments: [
//               TextComment(
//                   author: user1,
//                   date: DateFormat("dd.MM.yyyy").parse("18.11.2022"),
//                   text: "Only had time to vacuum the living room and hallway."),
//               TextComment(
//                   author: user2,
//                   date: DateFormat("dd.MM.yyyy").parse("19.11.2022"),
//                   text:
//                       "That's okay, your mother and I still love you. \nYou can do the rest tomorrow."),
//             ],
//             tags: [
//               Tag(
//                 text: "urgent",
//                 color: "#FF0000",
//               ),
//             ]),
//         Task(
//           title: "Water flowers",
//           deadline: DateFormat("dd.MM.yyyy").parse("15.11.2022"),
//           description:
//               "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
//           assigned: [user2.userId],
//           tags: <Tag>[
//             Tag(
//               text: "green",
//               color: "#8BC34A",
//             ),
//             Tag(
//               text: "fun",
//               color: "#0400FF",
//             ),
//           ],
//         ),
//       ],
//     ),
//     Project(
//       title: "christmas",
//       tags: tags,
//       owner: user2.userId,
//       collaborators: [
//         user1.userId,
//         user2.userId,
//       ],
//       imageUrl: "assets/images/project_5.png",
//       description:
//           "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
//       lastUpdated:
//           DateFormat("dd.MM.yyyy").parse("22.11.2022").toIso8601String(),
//       tasks: [
//         Task(
//             title: "Vacuum the house",
//             description: "Vacuum the living room, hallway and kitchen.",
//             deadline: DateFormat("dd.MM.yyyy").parse("23.11.2022"),
//             assigned: [
//               user1.userId
//             ],
//             comments: [
//               TextComment(
//                   author: user1,
//                   date: DateFormat("dd.MM.yyyy").parse("18.10.2022"),
//                   text: "Only had time to vacuum the living room and hallway."),
//               TextComment(
//                   author: user2,
//                   date: DateFormat("dd.MM.yyyy").parse("19.11.2022"),
//                   text:
//                       "That's okay, your mother and I still love you. \nYou can do the rest tomorrow."),
//             ],
//             tags: [
//               Tag(
//                 text: "urgent",
//                 color: "#FF0000",
//               ),
//             ]),
//         Task(
//           title: "Water flowers",
//           deadline: DateFormat("dd.MM.yyyy").parse("15.11.2022"),
//           description:
//               "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
//           assigned: [user2.userId],
//           tags: <Tag>[
//             Tag(
//               text: "green",
//               color: "#8BC34A",
//             ),
//             Tag(
//               text: "fun",
//               color: "#0400FF",
//             ),
//           ],
//         ),
//       ],
//     ),
//   ];
//   static List<Tag> tags = [
//     Tag(
//       text: "urgent",
//       color: "#FF0000",
//     ),
//     Tag(
//       text: "green",
//       color: "#8BC34A",
//     ),
//     Tag(
//       text: "fun",
//       color: "#0400FF",
//     ),
//   ];
// }
