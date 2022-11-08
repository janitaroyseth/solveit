// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:project/main.dart';
import 'package:project/models/project.dart';
import 'package:project/data/example_data.dart';
import 'package:project/widgets/sign_in_button.dart';

void main() {
  testWidgets('SignInButton is displayed and functions correctly',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(42, 42);
    await tester.pumpWidget(const MyApp());
    expect(find.widgetWithText(SignInButton, 'Continue with Google'),
        findsOneWidget);
    expect(find.byIcon(PhosphorIcons.googleLogo), findsOneWidget);
    expect(find.widgetWithText(SignInButton, 'Continue with Facebook'),
        findsOneWidget);
    expect(find.byIcon(PhosphorIcons.facebookLogo), findsOneWidget);
    expect(find.widgetWithText(SignInButton, 'Continue with Apple'),
        findsOneWidget);
    expect(find.byIcon(PhosphorIcons.appleLogo), findsOneWidget);

    //await tester.tap(find.widgetWithText(SignInButton, 'Continue with Google'));
    //expect(find.byType(BottomAppBar), findsOneWidget);
  });
}
