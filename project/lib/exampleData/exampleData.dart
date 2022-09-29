import 'package:flutter/material.dart';

import '../entities/comment.dart';
import '../entities/project.dart';
import '../entities/task.dart';
import '../widgets/tag.dart';

/// Temp list for testing.
class ExampleData {
  static List<Project> projects = [
    Project(title: "Household", tasks: [
      Task(
        title: "Vacuum the house",
        description: "Vacuum the living room, hallway and kitchen.",
        deadline: "23.10.2022",
        comments: [
          Comment(
            author: "Espen",
            date: "18.10.2022",
            text: "Only had time to vacuum the living room and hallway."
          ),
          Comment(
            author: "Sakarias",
            date: "19.10.2022",
            text: "That's okay, your mother and I still love you. \nYou can do the rest tomorrow."
          ),
        ],
        tags: [
              const Tag(
                size: Size.small,
                color: Color.fromRGBO(255, 0, 0, 1),
                tagText: "urgent",
              ),
            ]
      ),
      Task(
        title: "Water flowers",
        deadline: "15/10/2022",
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
        tags: <Tag>[
          const Tag(
            size: Size.small,
            color: Colors.lightGreen,
            tagText: "green",
          ),
          const Tag(
            size: Size.small,
            color: Color.fromRGBO(4, 0, 255, 1),
            tagText: "fun",
          ),
        ]
    ),
    ])
  ];
}