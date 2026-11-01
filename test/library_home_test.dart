import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motina_library/main.dart';
import 'package:motina_library/prototype/demo_books.dart';
import 'package:motina_library/prototype/design_tokens.dart';
import 'package:motina_library/prototype/library_home.dart';

void main() {
  test(
    'mock search combines title/author with status without changing data',
    () {
      expect(
        filterDemoBooks(
          demoBooks,
          'معروفی',
          ReadingStatus.reading,
        ).single.title,
        'سمفونی مردگان',
      );
      expect(
        filterDemoBooks(demoBooks, 'معروفی', ReadingStatus.finished),
        isEmpty,
      );
      expect(filterDemoBooks(demoBooks, 'little prince', null), hasLength(1));
      expect(demoBooks, hasLength(8));
    },
  );

  testWidgets('search, clear and empty preview remain distinct', (
    tester,
  ) async {
    await tester.pumpWidget(const MainApp());
    await tester.enterText(find.byType(TextField), 'not-a-book');
    await tester.pump();
    expect(find.text('کتابی پیدا نشد'), findsOneWidget);
    await tester.tap(find.byTooltip('پاک کردن جست‌وجو'));
    await tester.pump();
    expect(find.byType(BookCard), findsNWidgets(8));
    await tester.ensureVisible(find.text('نمایش کتابخانهٔ خالی'));
    await tester.tap(find.text('نمایش کتابخانهٔ خالی'));
    await tester.pump();
    expect(find.byType(EmptyLibraryView), findsOneWidget);
    expect(find.byType(BookCard), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('status filters and query combine and reset in the UI', (
    tester,
  ) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('در حال مطالعه'));
    await tester.pump();
    expect(find.byType(BookCard), findsNWidgets(2));
    await tester.enterText(find.byType(TextField), 'معروفی');
    await tester.pump();
    expect(find.byType(BookCard), findsOneWidget);
    await tester.tap(find.text('خوانده‌شده'));
    await tester.pump();
    expect(find.text('کتابی پیدا نشد'), findsOneWidget);
    await tester.ensureVisible(find.text('پاک کردن جست‌وجو و فیلترها'));
    await tester.tap(find.text('پاک کردن جست‌وجو و فیلترها'));
    await tester.pump();
    expect(find.byType(BookCard), findsNWidgets(8));
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
  });

  testWidgets('Add explains prototype and does not add data', (tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('افزودن کتاب'));
    await tester.pumpAndSettle();
    expect(find.text('پیش‌نمایش طراحی'), findsOneWidget);
    await tester.tap(find.text('متوجه شدم'));
    await tester.pumpAndSettle();
    expect(find.byType(BookCard), findsNWidgets(8));
  });

  for (final width in [320.0, 400.0, 768.0, 1440.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('no layout exceptions at $width with text scale $scale', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          MaterialApp(
            theme: DesignTokens.theme,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: const Directionality(
              textDirection: TextDirection.rtl,
              child: LibraryHome(),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      });
    }
  }
}
