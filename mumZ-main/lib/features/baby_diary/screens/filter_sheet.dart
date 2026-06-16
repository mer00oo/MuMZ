import 'package:flutter/material.dart';
import 'package:mamyapp/features/baby_diary/models/memory_model.dart';
import 'package:mamyapp/widgets/diary_widgets.dart' show AppFilterChip;
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import 'package:mamyapp/features/baby_diary/providers/diary_provider.dart';


class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      provider.clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'مسح الكل',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Text(
                    'تصفية الذكريات',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Categories
              _buildSectionTitle('الفئة'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: MemoryCategory.values.map((cat) {
                  final isSelected =
                  provider.selectedCategories.contains(cat);
                  return GestureDetector(
                    onTap: () => provider.toggleCategory(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cat.color
                            : cat.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? cat.color
                              : cat.color.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cat.labelAr,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                              isSelected ? Colors.white : cat.color,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(cat.icon,
                              size: 14,
                              color:
                              isSelected ? Colors.white : cat.color),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Age groups
              _buildSectionTitle('عمر الطفل'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: AgeGroup.values.map((age) {
                  return AppFilterChip(
                    label: age.label,
                    isSelected: provider.selectedAgeGroups.contains(age),
                    onTap: () => provider.toggleAgeGroup(age),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Date filter
              _buildSectionTitle('الفترة الزمنية'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  AppFilterChip(
                    label: 'هذا الأسبوع',
                    isSelected:
                    provider.dateFilter == DateFilter.thisWeek,
                    onTap: () => provider.setDateFilter(
                        provider.dateFilter == DateFilter.thisWeek
                            ? DateFilter.all
                            : DateFilter.thisWeek),
                  ),
                  AppFilterChip(
                    label: 'هذا الشهر',
                    isSelected:
                    provider.dateFilter == DateFilter.thisMonth,
                    onTap: () => provider.setDateFilter(
                        provider.dateFilter == DateFilter.thisMonth
                            ? DateFilter.all
                            : DateFilter.thisMonth),
                  ),
                  AppFilterChip(
                    label: 'نطاق مخصص',
                    isSelected: provider.dateFilter == DateFilter.custom,
                    onTap: () async {
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        builder: (ctx, child) => Theme(
                          data: Theme.of(ctx).copyWith(
                            colorScheme: const ColorScheme.light(
                                primary: AppTheme.primary),
                          ),
                          child: child!,
                        ),
                      );
                      if (range != null) {
                        provider.setDateFilter(DateFilter.custom,
                            range: range);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Favorites only
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: provider.favoritesOnly
                        ? const Color(0xFFFFB347).withOpacity(0.5)
                        : AppTheme.divider,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Switch.adaptive(
                      value: provider!.favoritesOnly,
                      onChanged: provider.setFavoritesOnly,
                      activeColor: const Color(0xFFFFB347),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'المفضلة فقط ⭐',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Apply button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'تطبيق الفلاتر',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom + 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
        fontFamily: 'Cairo',
      ),
    );
  }
}

extension on Object? {
  bool? get favoritesOnly => null;
}