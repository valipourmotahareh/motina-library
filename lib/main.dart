import 'package:flutter/material.dart';
import 'prototype/design_tokens.dart';
import 'prototype/library_home.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Motina Library · Prototype',
    debugShowCheckedModeBanner: false,
    theme: DesignTokens.theme,
    home: const Directionality(
      textDirection: TextDirection.rtl,
      child: LibraryHome(),
    ),
  );
}
