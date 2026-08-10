import 'package:flutter/material.dart';

class TransactionRecord {
  final String accountName;
  final String description;
  final double amount;
  final DateTime date;
  final bool isIncome;

  TransactionRecord({
    required this.accountName,
    required this.description,
    required this.amount,
    required this.date,
    required this.isIncome,
  });
}

class TransactionHistoryRepository {
  static final List<TransactionRecord> records = [];

  static void add(TransactionRecord record) {
    records.insert(0, record);
  }

  static List<TransactionRecord> getAll() => List.unmodifiable(records);
}

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

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
    final transactions = TransactionHistoryRepository.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติการทำรายการ'),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Text(
                'ยังไม่มีประวัติการทำรายการ',
                style: TextStyle(color: Colors.black54),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemCount: transactions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000).withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    title: Text(
                      transaction.description,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${transaction.accountName} · ${_formatDate(transaction.date)}',
                    ),
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
                );
              },
            ),
    );
  }
}
