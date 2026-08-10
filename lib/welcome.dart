import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF6C63FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.08),

              // โลโก้ / ไอคอนแอป
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.explore_rounded,
                  size: 72,
                  color: Color(0xFF6C63FF),
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              // ชื่อแอป
              const Text(
                'Navigation App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // คำบรรยาย
              const Text(
                'ยินดีต้อนรับ! เริ่มต้นใช้งานแอปของเรา\nเพื่อสำรวจฟีเจอร์ทั้งหมดได้เลย',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // ปุ่มเริ่มต้นใช้งาน
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6C63FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // TODO: แก้ให้ไปหน้าที่ต้องการ เช่น
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (_) => const HomeScreen()),
                    // );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('กดปุ่มเริ่มต้นใช้งานแล้ว!'),
                      ),
                    );
                  },
                  child: const Text(
                    'เริ่มต้นใช้งาน',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  // TODO: ไปหน้า Login
                },
                child: const Text(
                  'มีบัญชีอยู่แล้ว? เข้าสู่ระบบ',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
