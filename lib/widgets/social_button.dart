import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
      ),
      icon: Icon(icon, color: const Color(0xFF0F172A), size: 20),
      label: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF334155),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
