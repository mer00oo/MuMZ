import 'package:flutter/material.dart';
import 'package:mamyapp/features/baby_diary/models/memory_model.dart';
import 'package:mamyapp/features/baby_diary/providers/diary_provider.dart';
import 'package:mamyapp/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'add_memory_screen.dart';

class MemoryDetailsScreen extends StatelessWidget {
  final String memoryId;
  const MemoryDetailsScreen({super.key, required this.memoryId});

  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryProvider>(
      builder: (context, provider, _) {
        final memory = provider.getById(memoryId);
        if (memory == null) {
          WidgetsBinding.instance.addPostFrameCallback(
                  (_) => Navigator.pop(context));
          return const SizedBox.shrink();
        }

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App bar with large image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  // Favorite button in app bar
                  IconButton(
                    icon: Icon(
                      memory.isFavorite
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: memory.isFavorite
                          ? const Color(0xFFFFD700)
                          : Colors.white,
                    ),
                    onPressed: () => provider.toggleFavorite(memory.id),
                  ),
                  // Edit button
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider.value(
                          value: provider,
                          child: AddMemoryScreen(memoryToEdit: memory),
                        ),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradient background image placeholder
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              memory.category.color,
                              memory.category.color.withOpacity(0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      // Decorative circles
                      Positioned(
                        right: -40,
                        top: -40,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -20,
                        bottom: 20,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.25),
                              ),
                              child: Icon(
                                memory.category.icon,
                                size: 52,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              memory.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Cairo',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Meta info row
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _infoRow(
                              Icons.calendar_today_rounded,
                              'التاريخ',
                              _formatDate(memory.date),
                            ),
                            const Divider(height: 20, color: AppTheme.divider),
                            _infoRow(
                              memory.category.icon,
                              'الفئة',
                              memory.category.labelAr,
                              iconColor: memory.category.color,
                            ),
                            const Divider(height: 20, color: AppTheme.divider),
                            _infoRow(
                              Icons.child_care_rounded,
                              'العمر',
                              memory.ageGroup.label,
                            ),
                            if (memory.isFavorite) ...[
                              const Divider(height: 20, color: AppTheme.divider),
                              _infoRow(
                                Icons.star_rounded,
                                'المفضلة',
                                'ذكرى مميزة ⭐',
                                iconColor: const Color(0xFFFFB347),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Description
                      if (memory.description != null &&
                          memory.description!.isNotEmpty) ...[
                        const Text(
                          'التفاصيل',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            memory.description!,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              height: 1.7,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Category badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color:
                              memory.category.color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: memory.category.color.withOpacity(0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  memory.category.labelAr,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: memory.category.color,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(memory.category.icon,
                                    size: 16,
                                    color: memory.category.color),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Delete button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () => _confirmDelete(context, provider),
                          icon: const Icon(Icons.delete_outline_rounded,
                              color: Colors.red),
                          label: const Text(
                            'حذف الذكرى',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Colors.red, width: 1.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String label, String value,
      {Color iconColor = AppTheme.primary}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(width: 12),
        Icon(icon, size: 18, color: iconColor),
      ],
    );
  }

  void _confirmDelete(BuildContext context, DiaryProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'حذف الذكرى؟',
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'هل أنتِ متأكدة من حذف هذه الذكرى؟ لا يمكن التراجع عن هذا الإجراء.',
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء',
                style: TextStyle(fontFamily: 'Cairo', color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteMemory(memoryId);
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // back to list
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف',
                style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final months = [
    'يناير','فبراير','مارس','أبريل','مايو','يونيو',
    'يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}