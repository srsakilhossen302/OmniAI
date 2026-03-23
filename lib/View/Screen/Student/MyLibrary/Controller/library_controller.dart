import 'package:get/get.dart';
import '../Model/library_model.dart';

class LibraryController extends GetxController {
  final items = <LibraryItemModel>[].obs;
  final filteredItems = <LibraryItemModel>[].obs;
  final selectedFilter = 'All'.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchItems();
  }

  void _fetchItems() {
    items.assignAll([
      LibraryItemModel(id: '1', title: 'Algebra Solutio...', date: '2024-03-20', type: 'pdf'),
      LibraryItemModel(id: '2', title: 'Physics Problem...', date: '2024-03-19', type: 'scan'),
      LibraryItemModel(id: '3', title: 'SSC Mathematic...', date: '2024-03-18', type: 'plan'),
      LibraryItemModel(id: '4', title: 'Climate Change ...', date: '2024-03-17', type: 'pdf'),
      LibraryItemModel(id: '5', title: 'Chemistry Equat...', date: '2024-03-16', type: 'scan'),
      LibraryItemModel(id: '6', title: 'Exam Preparatio...', date: '2024-03-15', type: 'plan'),
    ]);
    _applyFilters();
  }

  void setFilter(String filter) {
    if (selectedFilter.value != filter) {
      selectedFilter.value = filter;
      _applyFilters();
    }
  }

  void search(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void _applyFilters() {
    var result = items.toList();

    // Apply Type Filter
    final filter = selectedFilter.value;
    if (filter != 'All') {
      String type = '';
      if (filter == 'PDFs') type = 'pdf';
      if (filter == 'Scans') type = 'scan';
      if (filter == 'Plans') type = 'plan';
      result = result.where((i) => i.type == type).toList();
    }

    // Apply Search
    if (searchQuery.value.isNotEmpty) {
      result = result.where((i) => i.title.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
    }

    filteredItems.assignAll(result);
  }

  int getCount(String filter) {
    if (filter == 'All') return items.length;
    String type = '';
    if (filter == 'PDFs') type = 'pdf';
    if (filter == 'Scans') type = 'scan';
    if (filter == 'Plans') type = 'plan';
    return items.where((i) => i.type == type).length;
  }
}
