import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  final VoidCallback? onUserUpdated;

  const ProfileScreen({super.key, required this.user, this.onUserUpdated});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _usernameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  bool _editingUsername = false;
  bool _editingEmail = false;
  bool _editingPhone = false;
  bool _changingPass = false;
  final _passCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameCtrl = TextEditingController(text: widget.user.username);
    _emailCtrl = TextEditingController(text: widget.user.email);
    _phoneCtrl = TextEditingController(
        text: widget.user.phone.isEmpty ? '+62 (555) 000-0000' : widget.user.phone);
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _newPassCtrl.dispose();
    super.dispose();
  }

  void _saveField(String field) {
    setState(() {
      switch (field) {
        case 'username':
          widget.user.username = _usernameCtrl.text.trim();
          widget.user.fullName = _usernameCtrl.text.trim();
          _editingUsername = false;
          break;
        case 'email':
          widget.user.email = _emailCtrl.text.trim();
          _editingEmail = false;
          break;
        case 'phone':
          widget.user.phone = _phoneCtrl.text.trim();
          _editingPhone = false;
          break;
        case 'password':
          if (_newPassCtrl.text.length >= 6) {
            widget.user.password = _newPassCtrl.text;
          }
          _changingPass = false;
          break;
      }
    });
    widget.onUserUpdated?.call();
    _showSuccess('Berhasil diperbarui');
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppTheme.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    ));
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out?',
            style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text(
          'Anda akan keluar dari akun ini.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const LoginScreen(),
                  transitionsBuilder: (_, anim, __, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: const Duration(milliseconds: 400),
                ),
                (route) => false,
              );
            },
            child: const Text('Log Out',
                style: TextStyle(
                    color: AppTheme.danger, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 💡 REVISI: Mengganti Scaffold menjadi Material.
    // Karena ProfileScreen berada di dalam IndexedStack (home_screen.dart),
    // kita tidak butuh Scaffold dan Drawer baru. Kita meminjam milik home_screen!
    return Material(
      color: AppTheme.bgPrimary,
      child: CustomScrollView(
        slivers: [
          // ── App Bar ────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppTheme.bgPrimary,
            elevation: 0,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu, color: AppTheme.textSecondary),
                // Tombol ini sekarang otomatis akan membuka Drawer dari home_screen.dart
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            title: const Text('DAILY REPORT', style: AppTheme.brandTitleSmall),
            centerTitle: true,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // ── Avatar ──────────────────────
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.gold, width: 2),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2A2510), Color(0xFF1A1A1A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: AppTheme.gold,
                      size: 44,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Name
                  Text(
                    widget.user.fullName,
                    style: const TextStyle(
                      color: AppTheme.gold,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.user.email,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Account Details ─────────────
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('ACCOUNT DETAILS', style: AppTheme.labelStyle),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: AppTheme.cardDecoration(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _accountField(
                          label: 'Username',
                          action: 'Edit',
                          controller: _usernameCtrl,
                          isEditing: _editingUsername,
                          onActionTap: () => setState(
                              () => _editingUsername = !_editingUsername),
                          onSave: () => _saveField('username'),
                        ),
                        const SizedBox(height: 16),
                        _accountField(
                          label: 'Email Address',
                          action: 'Update',
                          controller: _emailCtrl,
                          isEditing: _editingEmail,
                          onActionTap: () =>
                              setState(() => _editingEmail = !_editingEmail),
                          onSave: () => _saveField('email'),
                        ),
                        const SizedBox(height: 16),
                        _passwordField(),
                        const SizedBox(height: 16),
                        _accountField(
                          label: 'Phone Number',
                          action: 'Update',
                          controller: _phoneCtrl,
                          isEditing: _editingPhone,
                          onActionTap: () =>
                              setState(() => _editingPhone = !_editingPhone),
                          onSave: () => _saveField('phone'),
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Logout Button ───────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout_rounded,
                          color: AppTheme.danger, size: 18),
                      label: const Text(
                        'LOG OUT',
                        style: TextStyle(
                          color: AppTheme.danger,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.danger, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100), // Memberi jarak tambahan untuk Bottom NavBar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountField({
    required String label,
    required String action,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onActionTap,
    required VoidCallback onSave,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
            GestureDetector(
              onTap: isEditing ? onSave : onActionTap,
              child: Text(
                isEditing ? 'Save' : action,
                style: const TextStyle(
                  color: AppTheme.gold,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.bgCardLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: isEditing
              ? TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  autofocus: true,
                )
              : Text(
                  controller.text,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Password',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            GestureDetector(
              onTap: () {
                if (_changingPass) {
                  _saveField('password');
                } else {
                  setState(() => _changingPass = true);
                }
              },
              child: Text(
                _changingPass ? 'Save' : 'Change',
                style: const TextStyle(
                  color: AppTheme.gold,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.bgCardLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: _changingPass
              ? Column(
                  children: [
                    TextField(
                      controller: _passCtrl,
                      obscureText: true,
                      style: const TextStyle(
                          color: AppTheme.textPrimary, fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Password lama',
                        hintStyle:
                            TextStyle(color: AppTheme.textMuted, fontSize: 13),
                      ),
                    ),
                    const Divider(color: AppTheme.border, height: 16),
                    TextField(
                      controller: _newPassCtrl,
                      obscureText: true,
                      style: const TextStyle(
                          color: AppTheme.textPrimary, fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Password baru (min 6 karakter)',
                        hintStyle:
                            TextStyle(color: AppTheme.textMuted, fontSize: 13),
                      ),
                    ),
                  ],
                )
              : const Text(
                  '● ● ● ● ● ● ● ● ● ● ● ●',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
        ),
      ],
    );
  }
}