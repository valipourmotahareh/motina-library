import 'package:flutter/material.dart';
import 'demo_books.dart';
import 'design_tokens.dart';
import '../widgets/responsive_grid.dart';

TextDirection bookDirection(String text) {
  for (final rune in text.runes) {
    if (rune >= 0x600 && rune <= 0x6ff) {
      return TextDirection.rtl;
    }
    if ((rune >= 65 && rune <= 90) || (rune >= 97 && rune <= 122)) {
      return TextDirection.ltr;
    }
  }
  return TextDirection.rtl;
}

class LibraryHome extends StatefulWidget {
  const LibraryHome({super.key});
  @override
  State<LibraryHome> createState() => _LibraryHomeState();
}

class _LibraryHomeState extends State<LibraryHome> {
  final _search = TextEditingController();
  final _searchFocus = FocusNode();
  ReadingStatus? _status;
  String _query = '';
  bool _emptyDemo = false;

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _explainPrototype() => showDialog<void>(
    context: context,
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('پیش‌نمایش طراحی'),
        content: const Text(
          'افزودن کتاب در این نمونه پیاده‌سازی نشده است. داده‌ها فقط برای بررسی ظاهر نمایش داده می‌شوند.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('متوجه شدم'),
          ),
        ],
      ),
    ),
  );

  void _clear() {
    _search.clear();
    setState(() {
      _query = '';
      _status = null;
    });
    _searchFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final books = filterDemoBooks(_emptyDemo ? [] : demoBooks, _query, _status);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.gap),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: DesignTokens.maxWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: DesignTokens.gap,
                    ),
                    child: Wrap(
                      spacing: DesignTokens.section,
                      runSpacing: DesignTokens.space,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_stories_outlined,
                              color: DesignTokens.green,
                            ),
                            const SizedBox(width: DesignTokens.space),
                            Flexible(
                              child: Text(
                                'موتینا / MOTINA',
                                style: text.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        Text('جایی برای کتاب‌های شما', style: text.bodyMedium),
                      ],
                    ),
                  ),
                  const Divider(color: DesignTokens.line),
                  const SizedBox(height: DesignTokens.section),
                  Wrap(
                    spacing: DesignTokens.section,
                    runSpacing: DesignTokens.gap,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Semantics(
                        header: true,
                        child: Text('کتابخانهٔ من', style: text.headlineLarge),
                      ),
                      if (!_emptyDemo)
                        PrimaryButton(onPressed: _explainPrototype),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.space),
                  Text(
                    'هر کتاب، دری به دنیایی دیگر.',
                    style: text.bodyLarge?.copyWith(color: DesignTokens.muted),
                  ),
                  const SizedBox(height: DesignTokens.section),
                  if (!_emptyDemo) ...[
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: DesignTokens.searchWidth,
                      ),
                      child: SearchField(
                        controller: _search,
                        focusNode: _searchFocus,
                        onChanged: (value) {
                          if (!_search.value.composing.isValid ||
                              _search.value.composing.isCollapsed) {
                            setState(() => _query = value);
                          }
                        },
                        onClear: () {
                          _search.clear();
                          setState(() => _query = '');
                          _searchFocus.requestFocus();
                        },
                      ),
                    ),
                    const SizedBox(height: DesignTokens.gap),
                    ReadingStatusFilter(
                      value: _status,
                      onChanged: (status) => setState(() => _status = status),
                    ),
                    const SizedBox(height: DesignTokens.section),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        '${books.length} کتاب در این نما',
                        style: text.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.gap),
                  ],
                  if (_emptyDemo)
                    EmptyLibraryView(onAdd: _explainPrototype)
                  else if (books.isEmpty)
                    LibraryMessage(
                      icon: Icons.search_off,
                      title: 'کتابی پیدا نشد',
                      message: 'عنوان یا نویسندهٔ دیگری را جست‌وجو کنید.',
                      action: OutlinedButton(
                        onPressed: _clear,
                        child: const Text('پاک کردن جست‌وجو و فیلترها'),
                      ),
                    )
                  else
                    ResponsiveGrid(
                      minItemWidth: DesignTokens.cardMin,
                      spacing: DesignTokens.gap,
                      runSpacing: DesignTokens.section,
                      children: [
                        for (final book in books)
                          BookCard(book: book, index: demoBooks.indexOf(book)),
                      ],
                    ),
                  const SizedBox(height: DesignTokens.section),
                  const Divider(color: DesignTokens.line),
                  Text(
                    'نمونهٔ طراحی · داده‌های نمایشی · بدون ذخیره‌سازی',
                    style: text.bodyMedium,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: DesignTokens.space,
                    children: [
                      Text('ابزار بررسی طراحی:', style: text.bodyMedium),
                      TextButton(
                        onPressed: () =>
                            setState(() => _emptyDemo = !_emptyDemo),
                        child: Text(
                          _emptyDemo
                              ? 'نمایش کتاب‌های نمونه'
                              : 'نمایش کتابخانهٔ خالی',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => FilledButton.icon(
    onPressed: onPressed,
    icon: const Icon(Icons.add),
    label: const Text('افزودن کتاب'),
  );
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    focusNode: focusNode,
    onChanged: onChanged,
    textInputAction: TextInputAction.search,
    onSubmitted: onChanged,
    decoration: InputDecoration(
      labelText: 'جست‌وجوی کتاب',
      hintText: 'عنوان کتاب یا نام نویسنده',
      prefixIcon: const Icon(Icons.search),
      suffixIcon: controller.text.isEmpty
          ? null
          : IconButton(
              tooltip: 'پاک کردن جست‌وجو',
              onPressed: onClear,
              icon: const Icon(Icons.close),
            ),
    ),
  );
}

class ReadingStatusFilter extends StatelessWidget {
  const ReadingStatusFilter({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final ReadingStatus? value;
  final ValueChanged<ReadingStatus?> onChanged;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: DesignTokens.space,
    runSpacing: DesignTokens.space,
    children: [
      for (final status in <ReadingStatus?>[null, ...ReadingStatus.values])
        Semantics(
          selected: value == status,
          child: OutlinedButton.icon(
            onPressed: () => onChanged(status),
            style: OutlinedButton.styleFrom(
              backgroundColor: value == status
                  ? DesignTokens.green
                  : Colors.white,
              foregroundColor: value == status
                  ? Colors.white
                  : DesignTokens.ink,
              side: BorderSide(
                color: value == status
                    ? DesignTokens.green
                    : DesignTokens.control,
              ),
            ),
            // The text checkmark required a separate remote fallback font.
            // Use the already bundled icon font for this decorative indicator.
            icon: value == status ? const Icon(Icons.check) : null,
            label: Text(status?.label ?? 'همهٔ کتاب‌ها'),
          ),
        ),
    ],
  );
}

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.book, required this.index});
  final DemoBook book;
  final int index;
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      label: '${book.title}، ${book.author}، ${book.status.label}',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCoverPlaceholder(book: book, index: index),
            const SizedBox(height: DesignTokens.gap),
            Text(
              book.title,
              textDirection: bookDirection(book.title),
              style: text.titleMedium,
            ),
            const SizedBox(height: DesignTokens.space / 2),
            Text(
              book.author,
              textDirection: bookDirection(book.author),
              style: text.bodyMedium,
            ),
            const SizedBox(height: DesignTokens.space),
            Text(
              '— ${book.status.label}',
              style: text.bodyMedium?.copyWith(color: DesignTokens.green),
            ),
          ],
        ),
      ),
    );
  }
}

/// Original typographic mock covers, not publisher artwork or external assets.
class BookCoverPlaceholder extends StatelessWidget {
  const BookCoverPlaceholder({
    super.key,
    required this.book,
    required this.index,
  });
  final DemoBook book;
  final int index;
  @override
  Widget build(BuildContext context) {
    final color =
        DesignTokens.coverColors[index % DesignTokens.coverColors.length];
    final light =
        ThemeData.estimateBrightnessForColor(color) == Brightness.light;
    final foreground = light ? DesignTokens.ink : Colors.white;
    return ExcludeSemantics(
      child: AspectRatio(
        aspectRatio: DesignTokens.coverRatio,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: book.cover ? color : DesignTokens.paleGreen,
            borderRadius: BorderRadius.circular(DesignTokens.coverRadius),
          ),
          child: book.cover
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    final canvasWidth =
                        constraints.maxWidth < DesignTokens.coverCanvasMinWidth
                        ? DesignTokens.coverCanvasMinWidth
                        : constraints.maxWidth;
                    return FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: canvasWidth,
                        height: canvasWidth / DesignTokens.coverRatio,
                        // Cover lettering is decorative artwork. The real
                        // title below remains fully scaled and accessible.
                        child: MediaQuery.withNoTextScaling(
                          child: Padding(
                            padding: const EdgeInsets.all(DesignTokens.gap),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'M / LIBRARY',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: foreground,
                                    fontSize: DesignTokens.coverLabelSize,
                                    letterSpacing: DesignTokens.coverTracking,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  book.title,
                                  textDirection: bookDirection(book.title),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: foreground,
                                    fontSize: DesignTokens.coverTitleSize,
                                    height: 1.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: DesignTokens.gap),
                                Divider(color: foreground),
                                const SizedBox(height: DesignTokens.gap),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Icon(
                    Icons.menu_book_outlined,
                    size: DesignTokens.emptyIconSize,
                    color: DesignTokens.green,
                  ),
                ),
        ),
      ),
    );
  }
}

class EmptyLibraryView extends StatelessWidget {
  const EmptyLibraryView({super.key, required this.onAdd});
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) => LibraryMessage(
    icon: Icons.auto_stories_outlined,
    title: 'داستان کتابخانهٔ شما از اینجا شروع می‌شود',
    message: 'اولین کتاب خود را به کتابخانه اضافه کنید.',
    action: PrimaryButton(onPressed: onAdd),
  );
}

class LibraryMessage extends StatelessWidget {
  const LibraryMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.action,
  });
  final IconData icon;
  final String title;
  final String message;
  final Widget action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: DesignTokens.section),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DesignTokens.searchWidth),
        child: Column(
          children: [
            Icon(
              icon,
              size: DesignTokens.emptyIconSize,
              color: DesignTokens.green,
            ),
            const SizedBox(height: DesignTokens.gap),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: DesignTokens.space),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: DesignTokens.gap),
            action,
          ],
        ),
      ),
    ),
  );
}
