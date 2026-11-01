// Prototype fixtures only: these are not a production data model or taxonomy.
enum ReadingStatus {
  unread('نخوانده'),
  reading('در حال مطالعه'),
  finished('خوانده‌شده');

  const ReadingStatus(this.label);
  final String label;
}

class DemoBook {
  const DemoBook(this.title, this.author, this.status, {this.cover = true});
  final String title;
  final String author;
  final ReadingStatus status;
  final bool cover;
}

const demoBooks = [
  DemoBook('سمفونی مردگان', 'عباس معروفی', ReadingStatus.reading),
  DemoBook('چشم‌هایش', 'بزرگ علوی', ReadingStatus.unread),
  DemoBook('شازده کوچولو', 'آنتوان دو سنت‌اگزوپری', ReadingStatus.finished),
  DemoBook('سووشون', 'سیمین دانشور', ReadingStatus.unread),
  DemoBook(
    'The Little Prince',
    'Antoine de Saint-Exupéry',
    ReadingStatus.finished,
  ),
  DemoBook('کتابخانه نیمه‌شب', 'مت هیگ', ReadingStatus.reading),
  DemoBook(
    'یادداشت‌های یک خواننده — دربارهٔ کتاب‌ها و زندگی',
    'نمونهٔ نمایشی',
    ReadingStatus.unread,
    cover: false,
  ),
  DemoBook(
    'یادگیری Flutter 3 — جلد ۲',
    'نمونهٔ نمایشی',
    ReadingStatus.unread,
    cover: false,
  ),
];

List<DemoBook> filterDemoBooks(
  List<DemoBook> books,
  String query,
  ReadingStatus? status,
) {
  final needle = query.trim().toLowerCase();
  return books
      .where(
        (book) =>
            (status == null || book.status == status) &&
            '${book.title} ${book.author}'.toLowerCase().contains(needle),
      )
      .toList();
}
