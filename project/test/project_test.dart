import 'package:flutter_test/flutter_test.dart';
import 'package:project/data/project_avatar_options.dart';
import 'package:project/models/project.dart';
import 'package:project/models/tag.dart';

void main() {
  group("constructor", () {
    test("empty", () {
      final project = Project();
      expect(project, isNot(null));
      expect(project.title, "");
      expect(project.description, "");
      expect(project.owner, "");
      expect(project.collaborators.isEmpty, true);
      expect(project.tags.isEmpty, true);
      expect(project.imageUrl, projectAvatars[0]);
    });

    test("valid data", () {
      String projectId = "some id";
      String title = "an awesome title for your project";

      List<Tag> tags = [
        Tag(text: "some tag", color: "#FFFF00"),
        Tag(text: "some other tag", color: "#FFF000"),
      ];
      List<String> collaborators = ["my user id goes here", "your user id too"];
      String owner = "a user id";
      String imageUrl = projectAvatars[7];
      String description = "a cool description";
      bool isPublic = false;
      String lastUpdated = DateTime.now().toIso8601String();
      final project = Project(
        projectId: projectId,
        title: title,
        description: description,
        tags: tags,
        collaborators: collaborators,
        owner: owner,
        imageUrl: imageUrl,
        isPublic: isPublic,
        lastUpdated: lastUpdated,
      );

      expect(project, isNot(null));
      expect(project.projectId, projectId);
      expect(project.title, title);
      expect(project.description, description);
      expect(project.tags, tags);
      expect(project.collaborators, collaborators);
      expect(project.owner, owner);
      expect(project.imageUrl, imageUrl);
      expect(project.isPublic, isPublic);
      expect(project.lastUpdated, lastUpdated);
    });
  });

  group("from map", () {
    test("null data", () {
      final message = Project.fromMap(null);
      expect(message, null);
    });

    test(
      "missing data",
      () {
        String projectId = "some id";
        String title = "an awesome task title";

        final project = Project.fromMap({
          "projectId": projectId,
          "title": title,
        });

        expect(project, null);
      },
    );

    test("valid data", () {
      String projectId = "some id";
      String title = "an awesome title for your project";
      List<Map<String, dynamic>> tags = [
        {"tagId": "some tag id", "text": "awesome", "color": "#0400FF"},
        {"tagId": "other tag id", "text": "cool", "color": "#0400FF"},
      ];
      List<String> collaborators = ["my user id goes here", "your user id too"];
      String owner = "a user id";
      String imageUrl = "https://aimageurl.com/image";
      String description = "a cool description";
      bool isPublic = false;
      String lastUpdated = DateTime.now().toIso8601String();

      final project = Project.fromMap({
        "projectId": projectId,
        "title": title,
        "tags": tags,
        "collaborators": collaborators,
        "owner": owner,
        "imageUrl": imageUrl,
        "description": description,
        "isPublic": isPublic,
        "lastUpdated": lastUpdated,
      });

      expect(project, isNot(null));
      expect(
        project,
        Project(
          projectId: projectId,
          title: title,
          tags: Tag.fromMaps(tags),
          owner: owner,
          collaborators: collaborators,
          description: description,
          imageUrl: imageUrl,
          lastUpdated: lastUpdated,
          isPublic: isPublic,
        ),
      );
    });

    test("valid with missing data", () {
      String projectId = "some id";
      String title = "an awesome title for your project";
      List<Map<String, dynamic>> tags = [
        {"tagId": "some tag id", "text": "awesome", "color": "#0400FF"},
        {"tagId": "other tag id", "text": "cool", "color": "#0400FF"},
      ];
      String owner = "a user id";
      String imageUrl = "https://aimageurl.com/image";
      bool isPublic = false;
      String lastUpdated = DateTime.now().toIso8601String();

      final project = Project.fromMap({
        "projectId": projectId,
        "title": title,
        "tags": tags,
        "owner": owner,
        "imageUrl": imageUrl,
        "isPublic": isPublic,
        "lastUpdated": lastUpdated,
      });

      expect(project, isNot(null));
      expect(
        project,
        Project(
          projectId: projectId,
          title: title,
          tags: Tag.fromMaps(tags),
          owner: owner,
          imageUrl: imageUrl,
          lastUpdated: lastUpdated,
          isPublic: isPublic,
        ),
      );
    });
  });

  test("to map", () {
    String projectId = "some id";
    String title = "an awesome title for your project";
    List<Map<String, dynamic>> tags = [
      {"tagId": "some tag id", "text": "awesome", "color": "#0400FF"},
      {"tagId": "other tag id", "text": "cool", "color": "#0400FF"},
    ];
    List<String> collaborators = ["my user id goes here", "your user id too"];
    String owner = "a user id";
    String imageUrl = "https://aimageurl.com/image";
    String description = "a cool description";
    bool isPublic = false;
    String lastUpdated = DateTime.now().toIso8601String();

    final project = Project(
      projectId: projectId,
      title: title,
      tags: Tag.fromMaps(tags),
      owner: owner,
      collaborators: collaborators,
      description: description,
      imageUrl: imageUrl,
      lastUpdated: lastUpdated,
      isPublic: isPublic,
    ).toMap();

    expect(project, isNot(null));
    expect(project, {
      "projectId": projectId,
      "title": title,
      "tags": tags,
      "collaborators": collaborators,
      "owner": owner,
      "imageUrl": imageUrl,
      "description": description,
      "isPublic": isPublic,
      "lastUpdated": lastUpdated,
    });
  });
}
