import 'package:flutter/material.dart';
import 'account_list.dart';
import 'login.dart';
import 'transaction_history.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _openAccountList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AccountListScreen()),
    );
  }

  void _openTransactionHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าแรก'),
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF6C63FF)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'เมนูหลัก',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'เลือกหน้าเพื่อไปต่อ',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet_rounded),
                title: const Text('รายการบัญชี'),
                onTap: () {
                  Navigator.pop(context);
                  _openAccountList(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history_rounded),
                title: const Text('ประวัติการทำรายการ'),
                onTap: () {
                  Navigator.pop(context);
                  _openTransactionHistory(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text('ออกจากระบบ'),
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFF6C63FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.08),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 72,
                  color: Color(0xFF6C63FF),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              const Text(
                'Money App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'ยินดีต้อนรับ! นี่คือหน้าแรกหลังล็อกอิน คุณสามารถเลือกไปหน้ารายการบัญชีหรือออกจากระบบได้จากเมนูด้านบน',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
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
                  onPressed: () => _openAccountList(context),
                  child: const Text(
                    'ไปยังรายการบัญชี',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _logout(context),
                child: const Text(
                  'ออกจากระบบ',
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
