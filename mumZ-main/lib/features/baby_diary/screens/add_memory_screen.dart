import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart' show AppTheme;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../widgets/diary_widgets.dart';
import '../models/memory_model.dart' show Memory, AgeGroup, MemoryCategory, MemoryCategoryExtension, AgeGroupExtension;
import '../providers/diary_provider.dart' show DiaryProvider;

class AddMemoryScreen extends StatefulWidget {
  final Memory? memoryToEdit;
  const AddMemoryScreen({super.key, this.memoryToEdit});

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String? _imagePath;

  MemoryCategory _selectedCategory = MemoryCategory.firstMoments;
  AgeGroup _selectedAgeGroup = AgeGroup.newborn;
  DateTime _selectedDate = DateTime.now();
  bool _isFavorite = false;
  bool _isSaving = false;

  bool get _isEditing => widget.memoryToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final m = widget.memoryToEdit!;
      _titleController.text = m.title;
      _descController.text = m.description ?? '';
      _selectedCategory = m.category;
      _selectedAgeGroup = m.ageGroup;
      _selectedDate = m.date;
      _isFavorite = m.isFavorite;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 500));

    final provider = context.read<DiaryProvider>();
    final memory = Memory(
      id: _isEditing
          ? widget.memoryToEdit!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      date: _selectedDate,
      category: _selectedCategory,
      ageGroup: _selectedAgeGroup,
      isFavorite: _isFavorite,
    );

    if (_isEditing) {
      provider.updateMemory(memory);
    } else {
      provider.addMemory(memory);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'تم تعديل الذكرى ✨' : 'تمت إضافة الذكرى 💕',
            style: const TextStyle(fontFamily: 'Cairo'),
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: AppTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildImagePicker(),
                    const SizedBox(height: 24),

                    _buildLabel('عنوان الذكرى *'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      textDirection: TextDirection.rtl,
                      validator: (v) =>
                      v == null || v.trim().isEmpty ? 'أدخلي عنواناً' : null,
                      decoration: const InputDecoration(
                        hintText: 'مثال: أول ابتسامة 😊',
                        prefixIcon: Icon(Icons.title_rounded, color: AppTheme.primary),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildLabel('وصف (اختياري)'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descController,
                      textDirection: TextDirection.rtl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'اكتبي تفاصيل هذه اللحظة الجميلة...',
                        prefixIcon: Icon(Icons.notes_rounded, color: AppTheme.primary),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildLabel('التاريخ'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.divider),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _formatDate(_selectedDate),
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.calendar_today_rounded,
                                color: AppTheme.primary, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildLabel('الفئة'),
                    const SizedBox(height: 10),
                    _buildCategorySelector(),
                    const SizedBox(height: 20),

                    _buildLabel('عمر الطفل'),
                    const SizedBox(height: 10),
                    _buildAgeGroupSelector(),
                    const SizedBox(height: 20),

                    _buildFavoriteToggle(),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _save,
                        icon: _isSaving
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Icon(_isEditing
                            ? Icons.save_rounded
                            : Icons.add_photo_alternate_rounded),
                        label: Text(
                          _isEditing ? 'حفظ التعديلات' : 'أضيفي الذكرى 💕',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
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
                icon: const Icon(Icons.close_rounded,
                    color: Colors.white, size: 22),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                _isEditing ? 'تعديل الذكرى' : 'ذكرى جديدة',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Label ─────────────────────────────────────────────────────────────────
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
        fontFamily: 'Cairo',
      ),
    );
  }

  // ─── Image Picker ──────────────────────────────────────────────────────────
  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final XFile? file =
        await picker.pickImage(source: ImageSource.gallery);
        if (file != null) setState(() => _imagePath = file.path);
      },
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: AppTheme.accent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.4),
            width: 2,
          ),
        ),
        child: _imagePath != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.file(
            File(_imagePath!),
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_photo_alternate_rounded,
                size: 32,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'أضيفي صورة للذكرى',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'اضغطي هنا لاختيار صورة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Category Selector ─────────────────────────────────────────────────────
  Widget _buildCategorySelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.end,
      children: MemoryCategory.values.map((cat) {
        final isSelected = _selectedCategory == cat;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? cat.color : cat.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? cat.color : cat.color.withOpacity(0.3),
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
                    color: isSelected ? Colors.white : cat.color,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(cat.icon,
                    size: 16,
                    color: isSelected ? Colors.white : cat.color),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── Age Group Selector ────────────────────────────────────────────────────
  Widget _buildAgeGroupSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.end,
      children: AgeGroup.values.map((age) {
        final isSelected = _selectedAgeGroup == age;
        return AppFilterChip(
          label: age.label,
          isSelected: isSelected,
          onTap: () => setState(() => _selectedAgeGroup = age),
        );
      }).toList(),
    );
  }

  // ─── Favorite Toggle ───────────────────────────────────────────────────────
  Widget _buildFavoriteToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFavorite
              ? const Color(0xFFFFB347).withOpacity(0.5)
              : AppTheme.divider,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Switch.adaptive(
            value: _isFavorite,
            onChanged: (v) => setState(() => _isFavorite = v),
            activeColor: const Color(0xFFFFB347),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'إضافة للمفضلة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'ستظهر في قائمة الذكريات المميزة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Icon(
            _isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
            color: _isFavorite
                ? const Color(0xFFFFB347)
                : AppTheme.textSecondary,
            size: 26,
          ),
        ],
      ),
    );
  }
}

// ─── Helper ────────────────────────────────────────────────────────────────
String _formatDate(DateTime date) {
  final months = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}