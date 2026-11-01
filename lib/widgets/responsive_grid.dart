import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// A non-scrolling, variable-height grid driven by its parent's available width.
///
/// Requires bounded horizontal constraints. Children receive equal widths and
/// determine their own heights. Rows start after the tallest item in the prior
/// row. Like [Wrap], all children are built eagerly.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    required this.minItemWidth,
    required this.spacing,
    required this.runSpacing,
  }) : assert(minItemWidth > 0 && minItemWidth < double.infinity),
       assert(spacing >= 0 && spacing < double.infinity),
       assert(runSpacing >= 0 && runSpacing < double.infinity);

  final List<Widget> children;
  final double minItemWidth;
  final double spacing;
  final double runSpacing;

  // Samples TextScaler at a stable logical size; this is a layout policy,
  // not a text style. Keep the existing prototype's scaling behavior.
  static const _scaleReference = 16.0;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      assert(
        constraints.hasBoundedWidth,
        'ResponsiveGrid needs a bounded width.',
      );
      if (constraints.maxWidth == 0 || children.isEmpty) {
        return const SizedBox.shrink();
      }
      final scale =
          MediaQuery.textScalerOf(context).scale(_scaleReference) /
          _scaleReference;
      final columns = math.max(
        1,
        ((constraints.maxWidth + spacing) / (minItemWidth * scale + spacing))
            .floor(),
      );
      final itemWidth =
          (constraints.maxWidth - (columns - 1) * spacing) / columns;
      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: [
          for (final child in children)
            SizedBox(width: itemWidth, child: child),
        ],
      );
    },
  );
}
