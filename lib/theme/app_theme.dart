import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color bgPrimary    = Color(0xFF0F0F0F);
  static const Color bgCard       = Color(0xFF1A1A1A);
  static const Color bgCardLight  = Color(0xFF222222);
  static const Color gold         = Color(0xFFF0B429);
  static const Color goldDark     = Color(0xFFD4941A);
  static const Color goldLight    = Color(0xFFF7CC5F);
  static const Color textPrimary  = Color(0xFFFFFFFF);
  static const Color textSecondary= Color(0xFF888888);
  static const Color textMuted    = Color(0xFF555555);
  static const Color border       = Color(0xFF2A2A2A);
  static const Color borderGold   = Color(0xFF3A3018);
  static const Color danger       = Color(0xFFE53E3E);
  static const Color success      = Color(0xFF48BB78);

  // Text styles
  static const TextStyle brandTitle = TextStyle(
    fontFamily: 'serif',
    fontSize: 36,
    fontWeight: FontWeight.w900,
    color: gold,
    letterSpacing: 3,
  );

  static const TextStyle brandTitleSmall = TextStyle(
    fontFamily: 'serif',
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: gold,
    letterSpacing: 3,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: textSecondary,
    letterSpacing: 1.5,
  );

  static InputDecoration inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: textMuted, fontSize: 14),
      prefixIcon: Icon(prefixIcon, color: textMuted, size: 18),
      suffixIcon: suffixIcon,
      filled: false,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: border, width: 1),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: gold, width: 1.5),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: danger, width: 1),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: danger, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
    );
  }

  static BoxDecoration cardDecoration({bool hasBorder = true}) {
    return BoxDecoration(
      color: bgCard,
      borderRadius: BorderRadius.circular(16),
      border: hasBorder
          ? Border.all(color: border, width: 1)
          : null,
    );
  }

  static Widget goldButton({
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
    IconData? leadingIcon,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.black,
          disabledBackgroundColor: goldDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
      ),
    );
  }
}