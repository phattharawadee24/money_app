import 'package:flutter/material.dart';
import 'account_list.dart';

class TransactionRecord {
  final String description;
  final double amount;
  final DateTime date;
  final bool isIncome;

  TransactionRecord({
    required this.description,
    required this.amount,
    required this.date,
    required this.isIncome,
  });
}

class AccountDetailScreen extends StatefulWidget {
  final Account account;

  const AccountDetailScreen({super.key, required this.account});

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  final List<TransactionRecord> _transactions = [
    TransactionRecord(
      description: 'เงินเดือนเข้าบัญชี',
      amount: 15000.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      isIncome: true,
    ),
    TransactionRecord(
      description: 'ค่ากินข้าวเที่ยง',
      amount: 120.00,
      date: DateTime.now().subtract(const Duration(days: 1)),
      isIncome: false,
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isIncome = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showAddTransactionDialog() {
    _descriptionController.clear();
    _amountController.clear();
    _isIncome = false;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('เพิ่มบันทึกรายการ'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _descriptionController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'รายละเอียด',
                    hintText: 'เช่น ค่ากินข้าว หรือ เงินเดือน',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'กรุณากรอกคำอธิบาย';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'จำนวนเงิน',
                    hintText: 'เช่น 120.00',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'กรุณากรอกจำนวนเงิน';
                    }
                    final amount = double.tryParse(value.replaceAll(',', ''));
                    if (amount == null || amount <= 0) {
                      return 'กรุณากรอกจำนวนเงินที่ถูกต้อง';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('รายรับ'),
                        value: true,
                        groupValue: _isIncome,
                        onChanged: (value) {
                          setState(() {
                            _isIncome = value ?? false;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('รายจ่าย'),
                        value: false,
                        groupValue: _isIncome,
                        onChanged: (value) {
                          setState(() {
                            _isIncome = value ?? false;
                          });
                        },
                      ),
                    ),
                  ],
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
              onPressed: _saveTransaction,
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  void _saveTransaction() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(_amountController.text.replaceAll(',', ''));
    final newTransaction = TransactionRecord(
      description: _descriptionController.text.trim(),
      amount: amount,
      date: DateTime.now(),
      isIncome: _isIncome,
    );

    setState(() {
      _transactions.insert(0, newTransaction);
    });

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เพิ่มรายการ "${newTransaction.description}" แล้ว'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteTransaction(int index) {
    final deleted = _transactions[index];
    setState(() {
      _transactions.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ลบรายการ "${deleted.description}" เรียบร้อยแล้ว'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatMoney(double amount) {
    final text = amount.toStringAsFixed(2);
    return text.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final account = widget.account;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        title: Text(account.name),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.number,
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Text(
                  '฿ ${_formatMoney(account.balance)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ยอดคงเหลือในบัญชี ${account.name}',
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'บันทึกรายการ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddTransactionDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('เพิ่มบันทึก'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _transactions.isEmpty
                ? const Center(
                    child: Text(
                      'ยังไม่มีบันทึกสำหรับบัญชีนี้',
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: _transactions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final transaction = _transactions[index];
                      return Dismissible(
                        key: ValueKey(
                          transaction.date.toIso8601String() +
                              transaction.description,
                        ),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) => _deleteTransaction(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            title: Text(
                              transaction.description,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(_formatDate(transaction.date)),
                            trailing: Text(
                              '${transaction.isIncome ? '+' : '-'}฿ ${_formatMoney(transaction.amount)}',
                              style: TextStyle(
                                color: transaction.isIncome
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
