import 'package:flutter/material.dart';
import 'account_detail.dart';

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

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({super.key});

  @override
  State<AccountListScreen> createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _balanceController = TextEditingController();

  final List<Account> _accounts = [
    const Account(
      name: 'บัญชีออมทรัพย์',
      number: '123-4-56789-0',
      balance: 15230.50,
      icon: Icons.savings_rounded,
    ),
    const Account(
      name: 'บัญชีกระแสรายวัน',
      number: '987-6-54321-0',
      balance: 8720.00,
      icon: Icons.account_balance_rounded,
    ),
    const Account(
      name: 'บัญชีเงินฝากประจำ',
      number: '456-7-89012-3',
      balance: 50000.00,
      icon: Icons.lock_clock_rounded,
    ),
  ];

  double get _totalBalance =>
      _accounts.fold(0, (sum, acc) => sum + acc.balance);

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _showAddAccountDialog() {
    _nameController.clear();
    _numberController.clear();
    _balanceController.clear();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('เพิ่มบัญชีใหม่'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อบัญชี',
                    hintText: 'เช่น บัญชีออมทรัพย์',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'กรุณากรอกชื่อบัญชี';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _numberController,
                  decoration: const InputDecoration(
                    labelText: 'เลขบัญชี',
                    hintText: 'xxx-x-xxxxx-x',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'กรุณากรอกเลขบัญชี';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _balanceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ยอดเงินเริ่มต้น',
                    hintText: 'เช่น 10000.00',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'กรุณากรอกยอดเงิน';
                    }
                    final amount = double.tryParse(value.replaceAll(',', ''));
                    if (amount == null || amount < 0) {
                      return 'กรุณากรอกยอดเงินที่ถูกต้อง';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: _saveAccount,
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  void _saveAccount() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final balance = double.parse(_balanceController.text.replaceAll(',', ''));
    final newAccount = Account(
      name: _nameController.text.trim(),
      number: _numberController.text.trim(),
      balance: balance,
      icon: Icons.savings_rounded,
    );

    setState(() {
      _accounts.insert(0, newAccount);
    });

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เพิ่มบัญชี "${newAccount.name}" เรียบร้อยแล้ว'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteAccount(int index) {
    final deleted = _accounts[index];
    setState(() {
      _accounts.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ลบบัญชี "${deleted.name}" เรียบร้อยแล้ว'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
                  color: const Color(0xFF000000).withValues(alpha: 0.1),
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
                  onPressed: _showAddAccountDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('เพิ่มบัญชี'),
                ),
              ],
            ),
          ),

          // รายการบัญชี
          Expanded(
            child: _accounts.isEmpty
                ? const Center(
                    child: Text(
                      'ยังไม่มีบัญชีในระบบ',
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: _accounts.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final account = _accounts[index];
                      return Dismissible(
                        key: ValueKey(account.number),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) => _deleteAccount(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF000000,
                                ).withValues(alpha: 0.04),
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
                                color: const Color(
                                  0xFF6C63FF,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                account.icon,
                                color: const Color(0xFF6C63FF),
                              ),
                            ),
                            title: Text(
                              account.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(account.number),
                            trailing: Text(
                              '฿ ${_formatMoney(account.balance)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AccountDetailScreen(account: account),
                                ),
                              );
                            },
                          ),
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
