import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class AddEntryDialog extends StatefulWidget {
  final Function(TransactionModel) onCommit;

  const AddEntryDialog({super.key, required this.onCommit});

  @override
  State<AddEntryDialog> createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<AddEntryDialog>
    with SingleTickerProviderStateMixin {
  final _amountCtrl = TextEditingController(text: '0');
  final _descCtrl = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedClass;
  bool _isIncome = true;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  final List<String> _classifications = [
    'Salary / Income',
    'Investment',
    'Real Estate',
    'Stocks & Bonds',
    'Business Revenue',
    'Operating Expense',
    'Asset Purchase',
    'Tax & Legal',
    'Personal',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppTheme.gold,
            onPrimary: Colors.black,
            surface: AppTheme.bgCard,
            onSurface: AppTheme.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _commit() {
    final rawAmount = _amountCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = double.tryParse(rawAmount) ?? 0;

    if (amount <= 0) {
      _shake('Masukkan jumlah yang valid');
      return;
    }
    if (_selectedDate == null) {
      _shake('Pilih tanggal terlebih dahulu');
      return;
    }
    if (_descCtrl.text.trim().isEmpty) {
      _shake('Deskripsi wajib diisi');
      return;
    }
    if (_selectedClass == null) {
      _shake('Pilih klasifikasi transaksi');
      return;
    }

    final tx = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      date: _selectedDate!,
      description: _descCtrl.text.trim(),
      classification: _selectedClass!,
      isIncome: _isIncome,
    );

    widget.onCommit(tx);
    Navigator.pop(context);
  }

  void _shake(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.borderGold, width: 1),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Header ──────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'New Entry',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppTheme.bgCardLight,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: AppTheme.textSecondary,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    const Divider(color: AppTheme.border, height: 24),

                    // ── Income / Expense Toggle ──────
                    Row(
                      children: [
                        _typeToggle('Income', true),
                        const SizedBox(width: 10),
                        _typeToggle('Expense', false),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Amount ──────────────────────
                    const Text('AMOUNT', style: AppTheme.labelStyle),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Rp',
                          style: TextStyle(
                            color: _isIncome ? AppTheme.gold : AppTheme.danger,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _amountCtrl,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: _isIncome ? AppTheme.gold : AppTheme.danger,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              hintText: '0',
                            ),
                            onTap: () {
                              if (_amountCtrl.text == '0') {
                                _amountCtrl.clear();
                              }
                            },
                            onChanged: (v) {
                              final raw = v.replaceAll(RegExp(r'[^0-9]'), '');
                              if (raw.isEmpty) {
                                _amountCtrl.value = const TextEditingValue(text: '');
                                return;
                              }
                              final formatted = NumberFormat('#,###', 'id_ID').format(int.parse(raw));
                              _amountCtrl.value = TextEditingValue(
                                text: formatted,
                                selection: TextSelection.collapsed(offset: formatted.length),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: AppTheme.border),

                    const SizedBox(height: 20),

                    // ── Date ────────────────────────
                    const Text('DATE', style: AppTheme.labelStyle),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppTheme.bgCardLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              color: AppTheme.textSecondary,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _selectedDate == null
                                    ? 'mm/dd/yyyy'
                                    : DateFormat('MM/dd/yyyy')
                                        .format(_selectedDate!),
                                style: TextStyle(
                                  color: _selectedDate == null
                                      ? AppTheme.textMuted
                                      : AppTheme.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.calendar_view_month_rounded,
                              color: AppTheme.textMuted,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Description ─────────────────
                    const Text('DESCRIPTION', style: AppTheme.labelStyle),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.bgCardLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: TextFormField(
                        controller: _descCtrl,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'e.g., Wire Transfer to Escrow',
                          hintStyle: const TextStyle(
                              color: AppTheme.textMuted, fontSize: 14),
                          prefixIcon: const Icon(
                            Icons.edit_note_rounded,
                            color: AppTheme.textMuted,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                   // ── Classification ──────────────
                    const Text('CLASSIFICATION', style: AppTheme.labelStyle),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.bgCardLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedClass,
                          dropdownColor: AppTheme.bgCard,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppTheme.textSecondary,
                          ),
                          hint: Row(
                            children: [
                              const Icon(
                                Icons.folder_open_outlined,
                                color: AppTheme.textMuted,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              // ---> TAMBAHKAN EXPANDED DI SINI <---
                              Expanded(
                                child: Text(
                                  'Select asset class or category',
                                  style: TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 13,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          isExpanded: true,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                          ),
                          items: _classifications
                              .map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(
                                      c,
                                      // Opsional: Tambahkan overflow juga di item agar tidak error jika namanya kepanjangan
                                      overflow: TextOverflow.ellipsis, 
                                    ),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedClass = v),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Commit Button ───────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _commit,
                        icon: const Icon(Icons.check, color: Colors.black, size: 18),
                        label: const Text(
                          'COMMIT RECORD',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.gold,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ── Cancel Button ───────────────
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'CANCEL',
                          style: TextStyle(
                            color: AppTheme.gold,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _typeToggle(String label, bool isIncome) {
    final isSelected = _isIncome == isIncome;
    final color = isIncome ? AppTheme.success : AppTheme.danger;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isIncome = isIncome),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : AppTheme.border,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isIncome
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: isSelected ? color : AppTheme.textMuted,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : AppTheme.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}