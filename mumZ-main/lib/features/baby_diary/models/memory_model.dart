import 'package:flutter/material.dart';

enum MemoryCategory {
  firstMoments,
  vaccinations,
  health,
  playTime,
  family,
  milestones,
}

enum AgeGroup {
  newborn,
  oneToThreeMonths,
  threeToSixMonths,
  sixToTwelveMonths,
}

extension MemoryCategoryExtension on MemoryCategory {
  String get label {
    switch (this) {
      case MemoryCategory.firstMoments:
        return 'First Moments';
      case MemoryCategory.vaccinations:
        return 'Vaccinations';
      case MemoryCategory.health:
        return 'Health';
      case MemoryCategory.playTime:
        return 'Play Time';
      case MemoryCategory.family:
        return 'Family';
      case MemoryCategory.milestones:
        return 'Milestones';
    }
  }

  String get labelAr {
    switch (this) {
      case MemoryCategory.firstMoments:
        return 'اللحظات الأولى';
      case MemoryCategory.vaccinations:
        return 'التطعيمات';
      case MemoryCategory.health:
        return 'الصحة';
      case MemoryCategory.playTime:
        return 'وقت اللعب';
      case MemoryCategory.family:
        return 'العائلة';
      case MemoryCategory.milestones:
        return 'المعالم';
    }
  }

  IconData get icon {
    switch (this) {
      case MemoryCategory.firstMoments:
        return Icons.star_rounded;
      case MemoryCategory.vaccinations:
        return Icons.vaccines_rounded;
      case MemoryCategory.health:
        return Icons.favorite_rounded;
      case MemoryCategory.playTime:
        return Icons.toys_rounded;
      case MemoryCategory.family:
        return Icons.people_rounded;
      case MemoryCategory.milestones:
        return Icons.emoji_events_rounded;
    }
  }

  Color get color {
    switch (this) {
      case MemoryCategory.firstMoments:
        return const Color(0xFFF4A261);
      case MemoryCategory.vaccinations:
        return const Color(0xFF90BE6D);
      case MemoryCategory.health:
        return const Color(0xFFE76F51);
      case MemoryCategory.playTime:
        return const Color(0xFF9B72CF);
      case MemoryCategory.family:
        return const Color(0xFF43AA8B);
      case MemoryCategory.milestones:
        return const Color(0xFFFFB347);
    }
  }
}

extension AgeGroupExtension on AgeGroup {
  String get label {
    switch (this) {
      case AgeGroup.newborn:
        return 'Newborn';
      case AgeGroup.oneToThreeMonths:
        return '1–3 Months';
      case AgeGroup.threeToSixMonths:
        return '3–6 Months';
      case AgeGroup.sixToTwelveMonths:
        return '6–12 Months';
    }
  }
}

class Memory {
  final String id;
  final String? imagePath;
  final String title;
  final String? description;
  final DateTime date;
  final MemoryCategory category;
  final AgeGroup ageGroup;
  bool isFavorite;

  Memory({
    required this.id,
    this.imagePath,
    required this.title,
    this.description,
    required this.date,
    required this.category,
    required this.ageGroup,
    this.isFavorite = false,
  });

  Memory copyWith({
    String? id,
    String? imagePath,
    String? title,
    String? description,
    DateTime? date,
    MemoryCategory? category,
    AgeGroup? ageGroup,
    bool? isFavorite,
  }) {
    return Memory(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
      ageGroup: ageGroup ?? this.ageGroup,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}