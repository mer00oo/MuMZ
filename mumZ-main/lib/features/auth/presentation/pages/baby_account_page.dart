// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class BabyAccountPage extends StatefulWidget {
  const BabyAccountPage({super.key});

  @override
  State<BabyAccountPage> createState() => _BabyAccountPageState();
}

class _BabyAccountPageState extends State<BabyAccountPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD4C4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE89B88)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'إدارة البيانات',
          style: TextStyle(
            color: Color(0xFFE89B88),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFFE89B88)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'حساب طفلي',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/dd.png',
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.child_care,
                        size: 60,
                        color: Color(0xFFFFB4A0),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField(
                controller: nameController,
                label: 'اسم الطفل',
                icon: Icons.child_care,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: genderController,
                label: 'جنس الطفل',
                icon: Icons.person,
              ),
              const SizedBox(height: 20),
              _buildDateField(),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // حفظ التعديلات
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB4A0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 18,
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'حفظ التعديلات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
            color: Color(0xFFBBBBBB),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFFBBBBBB),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFFFFB4A0),
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            selectedDate = picked;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xFFBBBBBB),
            ),
            Text(
              selectedDate != null
                  ? '${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}'
                  : 'عمر الطفل',
              style: const TextStyle(
                color: Color(0xFFBBBBBB),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    genderController.dispose();
    super.dispose();
  }
}