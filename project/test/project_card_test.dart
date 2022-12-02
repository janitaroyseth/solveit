import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/data/project_avatar_options.dart';
import 'package:project/models/project.dart';
import 'package:project/widgets/project_card.dart';

void main() {
  testWidgets("public project card", (WidgetTester tester) async {
    Project project = Project(
        title: "cool",
        description: "a very cool description",
        collaborators: ["my user id", "your user id"],
        imageUrl: projectAvatars[2],
        isPublic: true,
        owner: "my user id");

    bool pressed = false;

    final projectCard = find.byType(ProjectCard);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ProjectCard(project: project, handler: () => pressed = true),
        ),
      ),
    );

    expect(find.text(project.title), findsOneWidget);
    expect(find.byIcon(PhosphorIcons.usersThin), findsOneWidget);
    expect(find.text("public"), findsOneWidget);
    expect(find.image(AssetImage(projectAvatars[2])), findsOneWidget);
    await tester.tap(projectCard);
    expect(pressed, true);
  });

  testWidgets("private project card", (WidgetTester tester) async {
    Project project = Project(
        title: "cool",
        description: "a very cool description",
        collaborators: ["my user id", "your user id"],
        imageUrl: projectAvatars[6],
        isPublic: false,
        owner: "my user id");

    bool pressed = false;

    final projectCard = find.byType(ProjectCard);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ProjectCard(project: project, handler: () => pressed = true),
        ),
      ),
    );

    expect(find.text(project.title), findsOneWidget);
    expect(find.byIcon(PhosphorIcons.lockSimpleThin), findsOneWidget);
    expect(find.text("private"), findsOneWidget);
    expect(find.image(AssetImage(projectAvatars[6])), findsOneWidget);
    await tester.tap(projectCard);
    expect(pressed, true);
  });
}
