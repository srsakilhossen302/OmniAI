import 'package:get/get.dart';

class LibraryItem {
  final String title;
  final String date;
  final String type; // pdf, scan, plan
  final String iconType; // color scheme

  LibraryItem({
    required this.title,
    required this.date,
    required this.type,
    required this.iconType,
  });
}

class TeacherLibraryController extends GetxController {
  final selectedFilter = 'All'.obs;
  final searchQuery = ''.obs;

  final allItems = <LibraryItem>[
    LibraryItem(title: 'Algebra Solutions', date: '2024-03-20', type: 'PDFs', iconType: 'red'),
    LibraryItem(title: 'Physics Problems', date: '2024-03-19', type: 'Scans', iconType: 'blue'),
    LibraryItem(title: 'SSC Mathematics', date: '2024-03-18', type: 'Plans', iconType: 'yellow'),
    LibraryItem(title: 'Climate Change Report', date: '2024-03-17', type: 'PDFs', iconType: 'red'),
    LibraryItem(title: 'Chemistry Equations', date: '2024-03-16', type: 'Scans', iconType: 'blue'),
    LibraryItem(title: 'Exam Preparation Plan', date: '2024-03-15', type: 'Plans', iconType: 'yellow'),
  ].obs;

  final filters = ['All', 'PDFs', 'Scans', 'Plans'];

  List<LibraryItem> get filteredItems {
    List<LibraryItem> items = allItems;
    if (selectedFilter.value != 'All') {
      items = items.where((item) => item.type == selectedFilter.value).toList();
    }
    if (searchQuery.value.isNotEmpty) {
      items = items.where((item) => item.title.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
    }
    return items;
  }

  int getCount(String filter) {
    if (filter == 'All') return allItems.length;
    return allItems.where((item) => item.type == filter).length;
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }

  void downloadItem(LibraryItem item) {
    // Logic later
  }

  void deleteItem(LibraryItem item) {
    allItems.remove(item);
  }
}
