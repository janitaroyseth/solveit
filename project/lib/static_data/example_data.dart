import '../models/comment.dart';
import '../models/project.dart';
import '../models/tag.dart';
import '../models/task.dart';

/// Temp list for testing.
class ExampleData {
  static List<Project> projects = [
    Project(title: "Household", tags: tags, tasks: [
      Task(
          title: "Vacuum the house",
          description: "Vacuum the living room, hallway and kitchen.",
          deadline: "23.10.2022",
          comments: [
            Comment(
                author: "Espen",
                date: "18.10.2022",
                text: "Only had time to vacuum the living room and hallway."),
            Comment(
                author: "Sakarias",
                date: "19.10.2022",
                text:
                    "That's okay, your mother and I still love you. \nYou can do the rest tomorrow."),
          ],
          tags: [
            const Tag(
              text: "urgent",
              color: 0xFFFF0000,
            ),
          ]),
      Task(
          title: "Water flowers",
          deadline: "15.10.2022",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam. ",
          tags: <Tag>[
            const Tag(
              text: "green",
              color: 0xFF8BC34A,
            ),
            const Tag(
              text: "fun",
              color: 0xFF0400FF,
            ),
          ]),
    ])
  ];
  static List<Tag> tags = [
    const Tag(
      text: "urgent",
      color: 0xFFFF0000,
    ),
    const Tag(
      text: "green",
      color: 0xFF8BC34A,
    ),
    const Tag(
      text: "fun",
      color: 0xFF0400FF,
    ),
  ];
}
