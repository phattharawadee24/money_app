import 'package:flutter/material.dart';

/// หน้ารายการบัญชี (Account List Screen)
///
/// หน้านี้แยกออกจากหน้า API/Account ตามที่อาจารย์สั่ง โดยใช้ข้อมูลจำลอง (mock data)
/// ไปก่อน ถ้าจะดึงข้อมูลจริงจาก API ทีหลัง ให้แก้ตรงส่วน `_accounts`
/// เป็นการดึงข้อมูลจาก service/API แทน
///
/// วิธีใช้:
/// 1. คัดลอกไฟล์นี้ไปไว้ที่ lib/account_list.dart ในโปรเจกต์
/// 2. import แล้วเรียกใช้ เช่น
///
///    import 'account_list.dart';
///
///    Navigator.push(
///      context,
///      MaterialPageRoute(builder: (_) => const AccountListScreen()),
///    );

class Account {
  final String name;
  final String number;
  final double balance;
  final IconData icon;

  const Account({
    required this.name,
    required this.number,
    required this.balance,
    required this.icon,
  });
}

class AccountListScreen extends StatelessWidget {
  const AccountListScreen({super.key});

  // TODO: แทนที่ mock data นี้ด้วยข้อมูลจริงจาก API/Database ภายหลัง
  static const List<Account> _accounts = [
    Account(
      name: 'บัญชีออมทรัพย์',
      number: '123-4-56789-0',
      balance: 15230.50,
      icon: Icons.savings_rounded,
    ),
    Account(
      name: 'บัญชีกระแสรายวัน',
      number: '987-6-54321-0',
      balance: 8720.00,
      icon: Icons.account_balance_rounded,
    ),
    Account(
      name: 'บัญชีเงินฝากประจำ',
      number: '456-7-89012-3',
      balance: 50000.00,
      icon: Icons.lock_clock_rounded,
    ),
  ];

  double get _totalBalance =>
      _accounts.fold(0, (sum, acc) => sum + acc.balance);

  String _formatMoney(double amount) {
    return amount
        .toStringAsFixed(2)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        title: const Text('รายการบัญชี'),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // การ์ดสรุปยอดรวม
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ยอดรวมทั้งหมด',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  '฿ ${_formatMoney(_totalBalance)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_accounts.length} บัญชี',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // หัวข้อรายการ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'บัญชีของฉัน',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                TextButton.icon(
                  onPressed: () {
                    // TODO: ไปหน้าเพิ่มบัญชีใหม่
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('เพิ่มบัญชี'),
                ),
              ],
            ),
          ),

          // รายการบัญชี
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _accounts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final account = _accounts[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(account.icon, color: const Color(0xFF6C63FF)),
                    ),
                    title: Text(
                      account.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(account.number),
                    trailing: Text(
                      '฿ ${_formatMoney(account.balance)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
