import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/diary_widgets.dart';

import '../models/memory_model.dart';
import '../providers/diary_provider.dart';
import 'add_memory_screen.dart';
import 'memory_details_screen.dart';
import 'filter_sheet.dart';

class DiaryMainScreen extends StatefulWidget {
  const DiaryMainScreen({super.key});

  @override
  State<DiaryMainScreen> createState() => _DiaryMainScreenState();
}

class _DiaryMainScreenState extends State<DiaryMainScreen>
    with TickerProviderStateMixin {
  bool _isGridView = true;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fabAnimController;
  late AnimationController _switchAnimController;

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _switchAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabAnimController.dispose();
    _switchAnimController.dispose();
    super.dispose();
  }

  void _toggleView() {
    _switchAnimController.forward(from: 0);
    setState(() => _isGridView = !_isGridView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Consumer<DiaryProvider>(
              builder: (context, provider, _) {
                final memories = provider.filteredMemories;
                final motd = provider.memoryOfTheDay;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Search + Filter bar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: _buildSearchBar(provider),
                      ),
                    ),

                    // Active filters indicator
                    if (provider.hasActiveFilters)
                      SliverToBoxAdapter(
                        child: _buildActiveFiltersRow(provider),
                      ),

                    // Memory of the Day
                    if (motd != null && !provider.hasActiveFilters)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SectionHeader(title: '✨ ذكرى اليوم'),
                              const SizedBox(height: 10),
                              MemoryOfTheDayBanner(
                                memory: motd,
                                onTap: () => _openDetails(context, motd),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Grid/List header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${memories.length} ذكرى',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                _buildSortMenu(provider),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'ذكرياتي',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // View toggle pill (centered)
                    SliverToBoxAdapter(
                      child: Center(
                        child: _buildViewToggle(),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // Memories content
                    memories.isEmpty
                        ? SliverFillRemaining(
                      child: EmptyStateWidget(
                        message: provider.hasActiveFilters
                            ? 'لا توجد ذكريات بهذه الفلاتر\nجربي فلاتر أخرى'
                            : 'لا توجد ذكريات بعد\nابدئي بتسجيل أول لحظة 💕',
                      ),
                    )
                        : _isGridView
                        ? _buildGridSliver(context, memories, provider)
                        : _buildListSliver(context, memories, provider),

                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _fabAnimController,
          curve: Curves.elasticOut,
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _openAddMemory(context),
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_photo_alternate_rounded),
          label: const Text(
            'أضيفي ذكرى',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
            ),
          ),
          elevation: 6,
        ),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFE8915A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              const Column(
                children: [
                  Text(
                    'مذكرات الطفل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Text(
                    'Little Moments 💕',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Search Bar ────────────────────────────────────────────────────────────
  Widget _buildSearchBar(DiaryProvider provider) {
    return Row(
      children: [
        // Filter button
        GestureDetector(
          onTap: () => _openFilterSheet(context, provider),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: provider.hasActiveFilters
                  ? AppTheme.primary
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.tune_rounded,
                  color: provider.hasActiveFilters
                      ? Colors.white
                      : AppTheme.primary,
                  size: 22,
                ),
                if (provider.hasActiveFilters)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Search field
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              textDirection: TextDirection.rtl,
              onChanged: provider.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'ابحثي عن ذكرى...',
                hintStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppTheme.primary.withOpacity(0.6),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  color: AppTheme.textSecondary,
                  onPressed: () {
                    _searchController.clear();
                    provider.setSearchQuery('');
                  },
                )
                    : null,
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Active Filters Row ────────────────────────────────────────────────────
  Widget _buildActiveFiltersRow(DiaryProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            onPressed: () {
              _searchController.clear();
              provider.clearFilters();
            },
            icon: const Icon(Icons.close_rounded, size: 14),
            label: const Text(
              'مسح الفلاتر',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 12),
            ),
            style: TextButton.styleFrom(foregroundColor: AppTheme.primaryDark),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'فلاتر نشطة',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.primaryDark,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── View Toggle ───────────────────────────────────────────────────────────
  Widget _buildViewToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleBtn(Icons.grid_view_rounded, _isGridView, () {
            if (!_isGridView) _toggleView();
          }),
          _toggleBtn(Icons.view_list_rounded, !_isGridView, () {
            if (_isGridView) _toggleView();
          }),
        ],
      ),
    );
  }

  Widget _toggleBtn(IconData icon, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: active ? Colors.white : AppTheme.textSecondary,
        ),
      ),
    );
  }

  // ─── Sort Menu ─────────────────────────────────────────────────────────────
  Widget _buildSortMenu(DiaryProvider provider) {
    return PopupMenuButton<SortOrder>(
      onSelected: provider.setSortOrder,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort_rounded, size: 14, color: AppTheme.primary),
            const SizedBox(width: 4),
            Text(
              provider.sortOrder == SortOrder.newestFirst ? 'الأحدث' : 'الأقدم',
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: SortOrder.newestFirst,
          child: Text('الأحدث أولاً', style: TextStyle(fontFamily: 'Cairo')),
        ),
        const PopupMenuItem(
          value: SortOrder.oldestFirst,
          child: Text('الأقدم أولاً', style: TextStyle(fontFamily: 'Cairo')),
        ),
      ],
    );
  }

  // ─── Grid / List Slivers ───────────────────────────────────────────────────
  Widget _buildGridSliver(
      BuildContext context, List<Memory> memories, DiaryProvider provider) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final memory = memories[index];
            return AnimatedOpacity(
              duration: Duration(milliseconds: 300 + index * 50),
              opacity: 1,
              child: MemoryGridCard(
                memory: memory,
                onTap: () => _openDetails(context, memory),
                onFavoriteToggle: () => provider.toggleFavorite(memory.id),
              ),
            );
          },
          childCount: memories.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.78,
        ),
      ),
    );
  }

  Widget _buildListSliver(
      BuildContext context, List<Memory> memories, DiaryProvider provider) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final memory = memories[index];
            return MemoryListCard(
              memory: memory,
              onTap: () => _openDetails(context, memory),
              onFavoriteToggle: () => provider.toggleFavorite(memory.id),
            );
          },
          childCount: memories.length,
        ),
      ),
    );
  }

  // ─── Navigation ────────────────────────────────────────────────────────────
  void _openDetails(BuildContext context, Memory memory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<DiaryProvider>(),
          child: MemoryDetailsScreen(memoryId: memory.id),
        ),
      ),
    );
  }

  void _openAddMemory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<DiaryProvider>(),
          child: const AddMemoryScreen(),
        ),
      ),
    );
  }

  void _openFilterSheet(BuildContext context, DiaryProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: const FilterSheet(),
      ),
    );
  }
}