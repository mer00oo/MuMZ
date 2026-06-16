import 'package:flutter/material.dart';
import '../models/memory_model.dart';

enum SortOrder { newestFirst, oldestFirst }
enum DateFilter { all, thisWeek, thisMonth, custom }

class DiaryProvider extends ChangeNotifier {
  // ─── State ────────────────────────────────────────────────────────────────
  List<Memory> _memories = [];
  String _searchQuery = '';
  Set<MemoryCategory> _selectedCategories = {};
  Set<AgeGroup> _selectedAgeGroups = {};
  bool _favoritesOnly = false;
  SortOrder _sortOrder = SortOrder.newestFirst;
  DateFilter _dateFilter = DateFilter.all;
  DateTimeRange? _customDateRange;

  DiaryProvider() {
    _loadDummyData();
  }

  // ─── Getters ──────────────────────────────────────────────────────────────
  List<Memory> get allMemories => _memories;
  String get searchQuery => _searchQuery;
  Set<MemoryCategory> get selectedCategories => _selectedCategories;
  Set<AgeGroup> get selectedAgeGroups => _selectedAgeGroups;
  bool get favoritesOnly => _favoritesOnly;
  SortOrder get sortOrder => _sortOrder;
  DateFilter get dateFilter => _dateFilter;
  DateTimeRange? get customDateRange => _customDateRange;

  bool get hasActiveFilters =>
      _selectedCategories.isNotEmpty ||
          _selectedAgeGroups.isNotEmpty ||
          _favoritesOnly ||
          _dateFilter != DateFilter.all ||
          _searchQuery.isNotEmpty;

  Memory? get memoryOfTheDay {
    if (_memories.isEmpty) return null;
    final idx = DateTime.now().day % _memories.length;
    return _memories[idx];
  }

  List<Memory> get filteredMemories {
    List<Memory> result = List.from(_memories);

    // Search
    if (_searchQuery.isNotEmpty) {
      result = result.where((m) =>
      m.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (m.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
      ).toList();
    }

    // Categories
    if (_selectedCategories.isNotEmpty) {
      result = result.where((m) => _selectedCategories.contains(m.category)).toList();
    }

    // Age groups
    if (_selectedAgeGroups.isNotEmpty) {
      result = result.where((m) => _selectedAgeGroups.contains(m.ageGroup)).toList();
    }

    // Favorites
    if (_favoritesOnly) {
      result = result.where((m) => m.isFavorite).toList();
    }

    // Date filter
    final now = DateTime.now();
    switch (_dateFilter) {
      case DateFilter.thisWeek:
        final weekAgo = now.subtract(const Duration(days: 7));
        result = result.where((m) => m.date.isAfter(weekAgo)).toList();
        break;
      case DateFilter.thisMonth:
        result = result.where((m) =>
        m.date.year == now.year && m.date.month == now.month
        ).toList();
        break;
      case DateFilter.custom:
        if (_customDateRange != null) {
          result = result.where((m) =>
          m.date.isAfter(_customDateRange!.start) &&
              m.date.isBefore(_customDateRange!.end.add(const Duration(days: 1)))
          ).toList();
        }
        break;
      default:
        break;
    }

    // Sort
    result.sort((a, b) => _sortOrder == SortOrder.newestFirst
        ? b.date.compareTo(a.date)
        : a.date.compareTo(b.date));

    return result;
  }

  // ─── Actions ──────────────────────────────────────────────────────────────
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleCategory(MemoryCategory category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  void toggleAgeGroup(AgeGroup age) {
    if (_selectedAgeGroups.contains(age)) {
      _selectedAgeGroups.remove(age);
    } else {
      _selectedAgeGroups.add(age);
    }
    notifyListeners();
  }

  void setFavoritesOnly(bool value) {
    _favoritesOnly = value;
    notifyListeners();
  }

  void setSortOrder(SortOrder order) {
    _sortOrder = order;
    notifyListeners();
  }

  void setDateFilter(DateFilter filter, {DateTimeRange? range}) {
    _dateFilter = filter;
    _customDateRange = range;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategories.clear();
    _selectedAgeGroups.clear();
    _favoritesOnly = false;
    _dateFilter = DateFilter.all;
    _customDateRange = null;
    _searchQuery = '';
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final idx = _memories.indexWhere((m) => m.id == id);
    if (idx != -1) {
      _memories[idx].isFavorite = !_memories[idx].isFavorite;
      notifyListeners();
    }
  }

  void addMemory(Memory memory) {
    _memories.insert(0, memory);
    notifyListeners();
  }

  void updateMemory(Memory memory) {
    final idx = _memories.indexWhere((m) => m.id == memory.id);
    if (idx != -1) {
      _memories[idx] = memory;
      notifyListeners();
    }
  }

  void deleteMemory(String id) {
    _memories.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  Memory? getById(String id) =>
      _memories.where((m) => m.id == id).firstOrNull;

  // ─── Dummy Data ───────────────────────────────────────────────────────────
  void _loadDummyData() {
    _memories = [
      Memory(
        id: '1',
        imagePath: null,
        title: 'First Smile 😊',
        description: 'Baby smiled for the very first time today! It melted my heart completely.',
        date: DateTime.now().subtract(const Duration(days: 2)),
        category: MemoryCategory.firstMoments,
        ageGroup: AgeGroup.oneToThreeMonths,
        isFavorite: true,
      ),
      Memory(
        id: '2',
        imagePath: null,
        title: 'First Bath',
        description: 'Splashing around and loving the warm water.',
        date: DateTime.now().subtract(const Duration(days: 10)),
        category: MemoryCategory.firstMoments,
        ageGroup: AgeGroup.newborn,
        isFavorite: true,
      ),
      Memory(
        id: '3',
        imagePath: null,
        title: 'Vaccination Day',
        description: 'Brave little one, only cried for a minute.',
        date: DateTime.now().subtract(const Duration(days: 20)),
        category: MemoryCategory.vaccinations,
        ageGroup: AgeGroup.oneToThreeMonths,
        isFavorite: false,
      ),
      Memory(
        id: '4',
        imagePath: null,
        title: 'Tummy Time Fun',
        description: 'Lifted head for 10 seconds! So strong.',
        date: DateTime.now().subtract(const Duration(days: 35)),
        category: MemoryCategory.milestones,
        ageGroup: AgeGroup.oneToThreeMonths,
        isFavorite: true,
      ),
      Memory(
        id: '5',
        imagePath: null,
        title: 'Meet Grandma',
        description: 'The whole family came to visit. So much love!',
        date: DateTime.now().subtract(const Duration(days: 50)),
        category: MemoryCategory.family,
        ageGroup: AgeGroup.newborn,
        isFavorite: false,
      ),
      Memory(
        id: '6',
        imagePath: null,
        title: 'First Toy',
        description: 'Grabbed the rattle and shook it! Brain is growing fast.',
        date: DateTime.now().subtract(const Duration(days: 65)),
        category: MemoryCategory.playTime,
        ageGroup: AgeGroup.threeToSixMonths,
        isFavorite: false,
      ),
      Memory(
        id: '7',
        imagePath: null,
        title: 'Check-up Visit',
        description: 'Healthy and growing right on track.',
        date: DateTime.now().subtract(const Duration(days: 80)),
        category: MemoryCategory.health,
        ageGroup: AgeGroup.threeToSixMonths,
        isFavorite: false,
      ),
      Memory(
        id: '8',
        imagePath: null,
        title: 'First Solid Food',
        description: 'Tried pureed carrots, made the funniest face!',
        date: DateTime.now().subtract(const Duration(days: 120)),
        category: MemoryCategory.milestones,
        ageGroup: AgeGroup.sixToTwelveMonths,
        isFavorite: true,
      ),
    ];
  }
}