import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

// ─────────────────────────────────────────────────────────────────
// SETUP INSTRUCTIONS (pubspec.yaml dependencies):
//
// dependencies:
//   shared_preferences: ^2.2.2
//   flutter_local_notifications: ^17.1.2
//   timezone: ^0.9.4
//
// Android: add to AndroidManifest.xml inside <manifest>:
//   <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
//   <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
//   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
//
// iOS: add to Info.plist:
//   <key>UIBackgroundModes</key>
//   <array><string>fetch</string><string>remote-notification</string></array>
//
// Initialize in main.dart BEFORE runApp():
//   tz.initializeTimeZones();
//   await NotificationService.init();
// ─────────────────────────────────────────────────────────────────

// ══════════════════════════════════════════════════════════════════
// Notification Service
// ══════════════════════════════════════════════════════════════════
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
  }

  /// Schedule a reminder [daysBefore] days before [vaccinationDate] at 9:00 AM
  static Future<void> scheduleReminder({
    required int id,
    required String vaccineName,
    required DateTime vaccinationDate,
    required int daysBefore,
  }) async {
    final reminderDate = vaccinationDate.subtract(Duration(days: daysBefore));
    final scheduled = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      9,
      0,
    );

    // Don't schedule if the reminder time is in the past
    if (scheduled.isBefore(DateTime.now())) return;

    final tzScheduled = tz.TZDateTime.from(scheduled, tz.local);

    await _plugin.zonedSchedule(
      id,
      '💉 تذكير تطعيم',
      'موعد "$vaccineName" بعد $daysBefore يوم${daysBefore > 1 ? '' : ''}',
      tzScheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'vaccination_channel',
          'تذكيرات التطعيم',
          channelDescription: 'تذكيرات مواعيد تطعيمات الطفل',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id);
    // Cancel all reminders for this vaccine (we store up to 2 per vaccine)
    await _plugin.cancel(id + 1000);
  }
}

// ══════════════════════════════════════════════════════════════════
// Vaccination Page
// ══════════════════════════════════════════════════════════════════
class VaccinationPage extends StatefulWidget {
  final String childName;
  final String childBirth;

  const VaccinationPage({
    super.key,
    required this.childName,
    required this.childBirth,
  });

  @override
  State<VaccinationPage> createState() => _VaccinationPageState();
}

class _VaccinationPageState extends State<VaccinationPage> {
  static const _prefsKey = 'vaccinations_v1';

  // ── Default vaccination list ──────────────────────────────────
  final List<Map<String, dynamic>> _defaultVaccinations = [
    {'name': 'تطعيم الهيباتيتس B (الأولى)',       'age': 'عند الولادة',        'ageMonths': 0,  'isCustom': false},
    {'name': 'تطعيم BCG (السل)',                   'age': 'عند الولادة',        'ageMonths': 0,  'isCustom': false},
    {'name': 'تطعيم الخماسي (الأولى)',             'age': 'الشهر الثاني',       'ageMonths': 2,  'isCustom': false},
    {'name': 'تطعيم شلل الأطفال (الأولى)',         'age': 'الشهر الثاني',       'ageMonths': 2,  'isCustom': false},
    {'name': 'تطعيم الروتا (الأولى)',              'age': 'الشهر الثاني',       'ageMonths': 2,  'isCustom': false},
    {'name': 'تطعيم الخماسي (الثانية)',            'age': 'الشهر الرابع',       'ageMonths': 4,  'isCustom': false},
    {'name': 'تطعيم شلل الأطفال (الثانية)',        'age': 'الشهر الرابع',       'ageMonths': 4,  'isCustom': false},
    {'name': 'تطعيم الروتا (الثانية)',             'age': 'الشهر الرابع',       'ageMonths': 4,  'isCustom': false},
    {'name': 'تطعيم الخماسي (الثالثة)',            'age': 'الشهر السادس',       'ageMonths': 6,  'isCustom': false},
    {'name': 'تطعيم الهيباتيتس B (الثالثة)',      'age': 'الشهر السادس',       'ageMonths': 6,  'isCustom': false},
    {'name': 'تطعيم الحصبة MMR (الأولى)',          'age': 'الشهر التاسع',       'ageMonths': 9,  'isCustom': false},
    {'name': 'تطعيم الحصبة MMR (الثانية)',         'age': 'الشهر الخامس عشر',  'ageMonths': 15, 'isCustom': false},
    {'name': 'تطعيم الجرعة المنشطة (الخماسي)',    'age': 'الشهر الثامن عشر',  'ageMonths': 18, 'isCustom': false},
  ];

  List<Map<String, dynamic>> _vaccinations = [];
  bool _isLoading = true;

  // ── Lifecycle ─────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  String get _storageKey => '${_prefsKey}_${widget.childName}';

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final List decoded = jsonDecode(raw);
      setState(() {
        _vaccinations = decoded.map<Map<String, dynamic>>((e) {
          final m = Map<String, dynamic>.from(e);
          if (m['date'] != null) m['date'] = DateTime.parse(m['date']);
          if (m['scheduledDate'] != null) {
            m['scheduledDate'] = DateTime.parse(m['scheduledDate']);
          }
          return m;
        }).toList();
        _isLoading = false;
      });
    } else {
      // First launch – build from defaults
      setState(() {
        _vaccinations = _defaultVaccinations
            .map((v) => {
          ...v,
          'done': false,
          'date': null,
          'scheduledDate': null,
          'reminderDays': null,
        })
            .toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_vaccinations.map((v) {
      final m = Map<String, dynamic>.from(v);
      if (m['date'] is DateTime) m['date'] = (m['date'] as DateTime).toIso8601String();
      if (m['scheduledDate'] is DateTime) {
        m['scheduledDate'] = (m['scheduledDate'] as DateTime).toIso8601String();
      }
      return m;
    }).toList());
    await prefs.setString(_storageKey, encoded);
  }

  // ── Computed ──────────────────────────────────────────────────
  int get _doneCount => _vaccinations.where((v) => v['done'] == true).length;
  double get _progress =>
      _vaccinations.isEmpty ? 0 : _doneCount / _vaccinations.length;

  Map<String, dynamic>? get _nextVaccination {
    try {
      return _vaccinations.firstWhere((v) => v['done'] == false);
    } catch (_) {
      return null;
    }
  }

  // ── Toggle done ───────────────────────────────────────────────
  Future<void> _toggleDone(int index) async {
    setState(() {
      _vaccinations[index]['done'] = !_vaccinations[index]['done'];
      if (_vaccinations[index]['done']) {
        _vaccinations[index]['date'] = DateTime.now();
      } else {
        _vaccinations[index]['date'] = null;
      }
    });
    await _saveData();
  }

  // ── Schedule appointment ──────────────────────────────────────
  Future<void> _showScheduleDialog(int index) async {
    final item = _vaccinations[index];
    DateTime? pickedDate = item['scheduledDate'];
    int reminderDays = item['reminderDays'] ?? 2;

    // Controllers for custom vaccine
    final nameCtrl = TextEditingController(text: item['isCustom'] == true ? item['name'] : '');

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: const Color(0xFFFDF6EE),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تحديد موعد التطعيم',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Color(0xFFE8915A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date picker
                const Text(
                  'تاريخ الموعد',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: pickedDate ?? DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                      locale: const Locale('ar'),
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFFE8915A),
                            onPrimary: Colors.white,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (d != null) setS(() => pickedDate = d);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8915A).withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            color: Color(0xFFE8915A), size: 18),
                        Text(
                          pickedDate != null
                              ? '${pickedDate!.day}/${pickedDate!.month}/${pickedDate!.year}'
                              : 'اختاري التاريخ',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            color: pickedDate != null
                                ? const Color(0xFF333333)
                                : Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Reminder days
                const Text(
                  'التذكير قبل الموعد بـ',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [1, 2, 3].map((d) {
                    final selected = reminderDays == d;
                    return GestureDetector(
                      onTap: () => setS(() => reminderDays = d),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFFE8915A) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFFE8915A)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          '$d ${d == 1 ? 'يوم' : 'أيام'}',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: selected ? Colors.white : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              // Cancel / Remove
              if (item['scheduledDate'] != null)
                TextButton(
                  onPressed: () async {
                    await NotificationService.cancelReminder(index);
                    setState(() {
                      _vaccinations[index]['scheduledDate'] = null;
                      _vaccinations[index]['reminderDays'] = null;
                    });
                    await _saveData();
                    if (mounted) Navigator.pop(ctx);
                  },
                  child: const Text(
                    'إلغاء الموعد',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.red,
                      fontSize: 13,
                    ),
                  ),
                ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8915A),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: pickedDate == null
                    ? null
                    : () async {
                  // Cancel old notifications first
                  await NotificationService.cancelReminder(index);

                  // Schedule new reminder
                  await NotificationService.scheduleReminder(
                    id: index,
                    vaccineName: item['name'],
                    vaccinationDate: pickedDate!,
                    daysBefore: reminderDays,
                  );

                  setState(() {
                    _vaccinations[index]['scheduledDate'] = pickedDate;
                    _vaccinations[index]['reminderDays'] = reminderDays;
                  });
                  await _saveData();

                  if (mounted) {
                    Navigator.pop(ctx);
                    _showSuccessSnackbar(
                      'تم تحديد الموعد! سيتم تذكيرك قبل $reminderDays ${reminderDays == 1 ? 'يوم' : 'أيام'} 🔔',
                    );
                  }
                },
                child: const Text(
                  'حفظ الموعد',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Add custom vaccination ────────────────────────────────────
  Future<void> _showAddCustomDialog() async {
    final nameCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    DateTime? pickedDate;
    int reminderDays = 2;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: const Color(0xFFFDF6EE),
            title: const Text(
              'إضافة تطعيم جديد',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF333333),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dialogField(nameCtrl, 'اسم التطعيم', Icons.vaccines_rounded),
                  const SizedBox(height: 12),
                  _dialogField(ageCtrl, 'العمر / الوصف (اختياري)', Icons.child_care_rounded),
                  const SizedBox(height: 16),
                  const Text(
                    'تاريخ الموعد',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: ctx,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                        locale: const Locale('ar'),
                        builder: (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFFE8915A),
                              onPrimary: Colors.white,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (d != null) setS(() => pickedDate = d);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFE8915A).withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              color: Color(0xFFE8915A), size: 18),
                          Text(
                            pickedDate != null
                                ? '${pickedDate!.day}/${pickedDate!.month}/${pickedDate!.year}'
                                : 'اختاري التاريخ (اختياري)',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: pickedDate != null
                                  ? const Color(0xFF333333)
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (pickedDate != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'التذكير قبل الموعد بـ',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [1, 2, 3].map((d) {
                        final selected = reminderDays == d;
                        return GestureDetector(
                          onTap: () => setS(() => reminderDays = d),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFFE8915A)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFFE8915A)
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              '$d ${d == 1 ? 'يوم' : 'أيام'}',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: selected
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('إلغاء',
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8915A),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: nameCtrl.text.trim().isEmpty
                    ? null
                    : () async {
                  final newVaccine = {
                    'name': nameCtrl.text.trim(),
                    'age': ageCtrl.text.trim().isEmpty
                        ? 'مخصص'
                        : ageCtrl.text.trim(),
                    'ageMonths': -1,
                    'isCustom': true,
                    'done': false,
                    'date': null,
                    'scheduledDate': pickedDate,
                    'reminderDays': pickedDate != null ? reminderDays : null,
                  };

                  final newIndex = _vaccinations.length;
                  setState(() => _vaccinations.add(newVaccine));
                  await _saveData();

                  // Schedule notification if date picked
                  if (pickedDate != null) {
                    await NotificationService.scheduleReminder(
                      id: newIndex,
                      vaccineName: nameCtrl.text.trim(),
                      vaccinationDate: pickedDate!,
                      daysBefore: reminderDays,
                    );
                  }

                  if (mounted) {
                    Navigator.pop(ctx);
                    _showSuccessSnackbar(
                      pickedDate != null
                          ? 'تم إضافة التطعيم وجدولة التذكير 🔔'
                          : 'تم إضافة التطعيم بنجاح ✅',
                    );
                  }
                },
                child: const Text(
                  'إضافة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogField(
      TextEditingController ctrl, String hint, IconData icon) {
    return TextField(
      controller: ctrl,
      textDirection: TextDirection.rtl,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            fontFamily: 'Cairo', fontSize: 12, color: Colors.grey.shade400),
        prefixIcon: Icon(icon, color: const Color(0xFFE8915A), size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color: const Color(0xFFE8915A).withOpacity(0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color: const Color(0xFFE8915A).withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8915A), width: 1.5),
        ),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: const Color(0xFFE8915A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }

  // ════════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFDF6EE),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFE8915A)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EE),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCustomDialog,
        backgroundColor: const Color(0xFFE8915A),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'إضافة تطعيم',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildProgressCard(),
                  const SizedBox(height: 14),
                  if (_nextVaccination != null) _buildNextVaccinationCard(),
                  const SizedBox(height: 14),
                  _buildVaccinationList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFE8915A),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.white, size: 22),
              ),
              const Text(
                'تطعيمات الطفل',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(width: 22),
            ],
          ),
        ),
      ),
    );
  }

  // ── Progress Card ─────────────────────────────────────────────
  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8915A), Color(0xFFF4B08A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8915A).withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_doneCount / ${_vaccinations.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              const Text(
                'تقدم التطعيمات',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(_progress * 100).toInt()}% مكتمل',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  // ── Next Vaccination Card ─────────────────────────────────────
  Widget _buildNextVaccinationCard() {
    final next = _nextVaccination!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE8915A).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE8D8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.vaccines_rounded,
                color: Color(0xFFE8915A), size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'التطعيم القادم',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFE8915A),
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  next['name'],
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  next['age'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontFamily: 'Cairo',
                  ),
                ),
                if (next['scheduledDate'] != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _formatDate(next['scheduledDate']),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFE8915A),
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.notifications_active_rounded,
                          size: 13, color: Color(0xFFE8915A)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Vaccination List ──────────────────────────────────────────
  Widget _buildVaccinationList() {
    final Map<String, List<int>> grouped = {};
    for (int i = 0; i < _vaccinations.length; i++) {
      final age = _vaccinations[i]['age'] as String;
      grouped.putIfAbsent(age, () => []).add(i);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'جدول التطعيمات',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 10),
        ...grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE8915A),
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      height: 1,
                      width: 40,
                      color: const Color(0xFFE8915A).withOpacity(0.3),
                    ),
                  ],
                ),
              ),
              ...entry.value.map((index) => _buildVaccinationItem(index)),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildVaccinationItem(int index) {
    final item = _vaccinations[index];
    final bool isDone = item['done'] as bool;
    final DateTime? scheduledDate = item['scheduledDate'];
    final bool hasSchedule = scheduledDate != null;
    final bool isCustom = item['isCustom'] == true;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone ? Colors.green.shade300 : Colors.grey.shade200,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              // Checkbox
              GestureDetector(
                onTap: () => _toggleDone(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone ? Colors.green : Colors.white,
                    border: Border.all(
                      color: isDone ? Colors.green : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: isDone
                      ? const Icon(Icons.check_rounded,
                      size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isCustom)
                          Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDE8D8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'مخصص',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 9,
                                color: Color(0xFFE8915A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Flexible(
                          child: Text(
                            item['name'],
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDone
                                  ? Colors.green.shade700
                                  : const Color(0xFF333333),
                              fontFamily: 'Cairo',
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isDone && item['date'] != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        'تم في ${_formatDate(item['date'])}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green.shade500,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                    if (hasSchedule && !isDone) ...[
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'موعد: ${_formatDate(scheduledDate)} • تذكير قبل ${item['reminderDays']} ${(item['reminderDays'] as int) == 1 ? 'يوم' : 'أيام'}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFFE8915A),
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.notifications_active_rounded,
                              size: 12, color: Color(0xFFE8915A)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Bell / schedule button
              if (!isDone) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showScheduleDialog(index),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: hasSchedule
                          ? const Color(0xFFE8915A)
                          : const Color(0xFFFDE8D8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      hasSchedule
                          ? Icons.notifications_active_rounded
                          : Icons.notification_add_rounded,
                      color: hasSchedule ? Colors.white : const Color(0xFFE8915A),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}