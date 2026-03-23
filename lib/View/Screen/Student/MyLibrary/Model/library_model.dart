class LibraryItemModel {
  final String id;
  final String title;
  final String date;
  final String type; // 'pdf', 'scan', 'plan'

  LibraryItemModel({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
  });
}
