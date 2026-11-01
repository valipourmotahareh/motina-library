import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motina_library/widgets/responsive_grid.dart';
import 'package:motina_library/prototype/demo_books.dart';
import 'package:motina_library/prototype/design_tokens.dart';
import 'package:motina_library/prototype/library_home.dart';

Widget host(Widget child, {double scale = 1}) => MaterialApp(
  theme: DesignTokens.theme,
  home: MediaQuery(
    data: MediaQueryData(textScaler: TextScaler.linear(scale)),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        child: Align(alignment: Alignment.topRight, child: child),
      ),
    ),
  ),
);

void main() {
  // The test viewport is wider than the parent: columns must use parent width.
  for (final scenario in [
    (width: 80.0, scale: 1.0, itemWidth: 80.0, columns: 1),
    (width: 335.0, scale: 1.0, itemWidth: 335.0, columns: 1),
    (width: 336.0, scale: 1.0, itemWidth: 160.0, columns: 2),
    (width: 368.0, scale: 1.0, itemWidth: 176.0, columns: 2),
    (width: 752.0, scale: 1.0, itemWidth: 176.0, columns: 4),
    (width: 368.0, scale: 2.0, itemWidth: 368.0, columns: 1),
    (width: 752.0, scale: 2.0, itemWidth: 368.0, columns: 2),
  ]) {
    testWidgets('parent width ${scenario.width}, scale ${scenario.scale}', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          SizedBox(
            width: scenario.width,
            child: ResponsiveGrid(
              minItemWidth: 160,
              spacing: 16,
              runSpacing: 32,
              children: [
                for (var i = 0; i < 5; i++)
                  SizedBox(key: ValueKey(i), height: 40),
              ],
            ),
          ),
          scale: scenario.scale,
        ),
      );
      final first = find.byKey(const ValueKey(0));
      expect(tester.getSize(first).width, closeTo(scenario.itemWidth, .001));
      final firstTop = tester.getTopLeft(first).dy;
      for (var i = 0; i < scenario.columns; i++) {
        expect(tester.getTopLeft(find.byKey(ValueKey(i))).dy, firstTop);
      }
      expect(
        tester.getTopLeft(find.byKey(ValueKey(scenario.columns))).dy,
        firstTop + 72,
      );
      if (scenario.columns > 1) {
        final second = find.byKey(const ValueKey(1));
        expect(
          tester.getTopLeft(first).dx - tester.getTopRight(second).dx,
          closeTo(16, .001),
        );
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'variable heights determine row extent without stretching children',
    (tester) async {
      await tester.pumpWidget(
        host(
          const SizedBox(
            width: 336,
            child: ResponsiveGrid(
              minItemWidth: 160,
              spacing: 16,
              runSpacing: 32,
              children: [
                SizedBox(key: ValueKey('short'), height: 40),
                SizedBox(key: ValueKey('tall'), height: 80),
                SizedBox(key: ValueKey('next'), height: 50),
              ],
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byKey(const ValueKey('short'))).height, 40);
      expect(tester.getSize(find.byKey(const ValueKey('tall'))).height, 80);
      expect(
        tester.getTopLeft(find.byKey(const ValueKey('next'))).dy -
            tester.getTopLeft(find.byKey(const ValueKey('tall'))).dy,
        112,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('empty and zero-width grids have no layout exceptions', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const Column(
          children: [
            SizedBox(
              width: 200,
              child: ResponsiveGrid(
                minItemWidth: 160,
                spacing: 16,
                runSpacing: 32,
                children: [],
              ),
            ),
            SizedBox(
              width: 0,
              child: ResponsiveGrid(
                minItemWidth: 160,
                spacing: 16,
                runSpacing: 32,
                children: [Text('not laid out')],
              ),
            ),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  const title =
      'یادداشت‌های یک خواننده دربارهٔ کتاب‌ها و زندگی — یادگیری Flutter 3 جلد ۲';
  for (final width in [80.0, 120.0, 160.0]) {
    for (final scale in [1.0, 2.0, 3.0]) {
      testWidgets('long mixed Persian card at $width and scale $scale', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        try {
          await tester.pumpWidget(
            host(
              SizedBox(
                width: width,
                child: const BookCard(
                  book: DemoBook(
                    title,
                    'نویسنده / Author',
                    ReadingStatus.reading,
                  ),
                  index: 0,
                ),
              ),
              scale: scale,
            ),
          );
          final cover = tester.getSize(find.byType(BookCoverPlaceholder));
          expect(cover.width / cover.height, closeTo(2 / 3, .001));
          expect(
            find.bySemanticsLabel('$title، نویسنده / Author، در حال مطالعه'),
            findsOneWidget,
          );
          expect(tester.takeException(), isNull);
        } finally {
          semantics.dispose();
        }
      });
    }
  }

  testWidgets('accessible title grows with user text scaling', (tester) async {
    const card = SizedBox(
      width: 160,
      child: BookCard(
        book: DemoBook(title, 'نویسنده', ReadingStatus.reading),
        index: 0,
      ),
    );
    await tester.pumpWidget(host(card));
    final normal = tester.getSize(find.text(title).last).height;
    await tester.pumpWidget(host(card, scale: 2));
    expect(tester.getSize(find.text(title).last).height, greaterThan(normal));
    expect(tester.takeException(), isNull);
  });
}
