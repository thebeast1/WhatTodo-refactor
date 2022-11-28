import 'package:flutter/material.dart';
import 'package:flutter_app/db/AppDatabase.dart';
import 'package:flutter_app/models/Tasks.dart';
import 'package:flutter_app/pages/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helper.dart';

void main() {
  testWidgets(
    'complete task option is available in menu',
    (tester) async {
      await tester.pumpWidget(
          HomeScreen().wrapWithMaterialApp().wrapWithProviderScope());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ValueKey("key_home_option")));
      await tester.pumpAndSettle();

      expect(find.text('Completed Task'), findsOneWidget);
    },
  );

  group('Home Task List', () {
    testWidgets('No Task Added', (tester) async {
      await tester.pumpWidget(
          HomeScreen().wrapWithMaterialApp().wrapWithProviderScope());
      await tester.pumpAndSettle();

      expect(find.text('No Task Added'), findsOneWidget);
    });

    testWidgets(
      'Show task item in list',
      (tester) async {
        AppDatabase.setTestInstance(FakeAppDatabase());
        await tester.pumpWidget(
            HomeScreen().wrapWithMaterialApp().wrapWithProviderScope());
        await tester.pumpAndSettle();

        expect(find.text('Title One'), findsOneWidget);
        expect(find.text('Inbox'), findsOneWidget);
      },
    );
  });
}

class FakeAppDatabase extends AppDatabase {
  @override
  Future<List<Tasks>> getTasks(
      {int startDate = 0, int endDate = 0, TaskStatus taskStatus}) async {
    var task = Tasks.create(title: 'Title One', projectId: 1);
    task.projectName = 'Inbox';
    task.projectColor = Colors.red.value;
    return Future.value([task]);
  }
}
