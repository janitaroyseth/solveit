import '../models/comment.dart';
import '../models/project.dart';
import '../models/tag.dart';
import '../models/task.dart';

/// Temp list for testing.
class ExampleData {
  static List<Project> projects = [
    Project(
      title: "Household",
      tags: tags,
      isPublic: true,
      imageUrl: "assets/images/project_1.png",
      description:
          "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
      lastUpdated: "22/10/2022",
      tasks: [
        Task(
            title: "Vacuum the house",
            description: "Vacuum the living room, hallway and kitchen.",
            deadline: "23/10/2022",
            comments: [
              Comment(
                  author: "Espen",
                  date: "18/10/2022",
                  text: "Only had time to vacuum the living room and hallway."),
              Comment(
                  author: "Sakarias",
                  date: "19/10/2022",
                  text:
                      "That's okay, your mother and I still love you. \nYou can do the rest tomorrow."),
            ],
            tags: [
              Tag(
                text: "urgent",
                color: "#FFFF0000",
              ),
            ]),
        Task(
          title: "Water flowers",
          deadline: "15/10/2022",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
          tags: <Tag>[
            Tag(
              text: "green",
              color: "#FF8BC34A",
            ),
            Tag(
              text: "fun",
              color: "#FF0400FF",
            ),
          ],
        ),
      ],
    ),
    Project(
      title: "Gardening",
      tags: tags,
      imageUrl: "assets/images/project_3.png",
      description:
          "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
      lastUpdated: "22/10/2022",
      tasks: [
        Task(
            title: "Vacuum the house",
            description: "Vacuum the living room, hallway and kitchen.",
            deadline: "23/10/2022",
            comments: [
              Comment(
                  author: "Espen",
                  date: "18/10/2022",
                  text: "Only had time to vacuum the living room and hallway."),
              Comment(
                  author: "Sakarias",
                  date: "19/10/2022",
                  text:
                      "That's okay, your mother and I still love you. \nYou can do the rest tomorrow."),
            ],
            tags: [
              Tag(
                text: "urgent",
                color: "#FF0000",
              ),
            ]),
        Task(
          title: "Water flowers",
          deadline: "15/10/2022",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
          tags: <Tag>[
            Tag(
              text: "green",
              color: "#8BC34A",
            ),
            Tag(
              text: "fun",
              color: "#0400FF",
            ),
          ],
        ),
      ],
    ),
    Project(
      title: "school",
      tags: tags,
      imageUrl: "assets/images/project_2.png",
      description:
          "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
      lastUpdated: "22/10/2022",
      tasks: [
        Task(
            title: "Vacuum the house",
            description: "Vacuum the living room, hallway and kitchen.",
            deadline: "23/10/2022",
            comments: [
              Comment(
                  author: "Espen",
                  date: "18/10/2022",
                  text: "Only had time to vacuum the living room and hallway."),
              Comment(
                  author: "Sakarias",
                  date: "19/10/2022",
                  text:
                      "That's okay, your mother and I still love you. \nYou can do the rest tomorrow."),
            ],
            tags: [
              Tag(
                text: "urgent",
                color: "#FF0000",
              ),
            ]),
        Task(
          title: "Water flowers",
          deadline: "15/10/2022",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
          tags: <Tag>[
            Tag(
              text: "green",
              color: "#8BC34A",
            ),
            Tag(
              text: "fun",
              color: "#0400FF",
            ),
          ],
        ),
      ],
    ),
    Project(
      title: "christmas",
      tags: tags,
      imageUrl: "assets/images/project_5.png",
      description:
          "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
      lastUpdated: "22/10/2022",
      tasks: [
        Task(
            title: "Vacuum the house",
            description: "Vacuum the living room, hallway and kitchen.",
            deadline: "23/10/2022",
            comments: [
              Comment(
                  author: "Espen",
                  date: "18/10/2022",
                  text: "Only had time to vacuum the living room and hallway."),
              Comment(
                  author: "Sakarias",
                  date: "19/10/2022",
                  text:
                      "That's okay, your mother and I still love you. \nYou can do the rest tomorrow."),
            ],
            tags: [
              Tag(
                text: "urgent",
                color: "#FF0000",
              ),
            ]),
        Task(
          title: "Water flowers",
          deadline: "15/10/2022",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
          tags: <Tag>[
            Tag(
              text: "green",
              color: "#8BC34A",
            ),
            Tag(
              text: "fun",
              color: "#0400FF",
            ),
          ],
        ),
      ],
    ),
  ];
  static List<Tag> tags = [
    Tag(
      text: "urgent",
      color: "#FF0000",
    ),
    Tag(
      text: "green",
      color: "#8BC34A",
    ),
    Tag(
      text: "fun",
      color: "#0400FF",
    ),
  ];
}
