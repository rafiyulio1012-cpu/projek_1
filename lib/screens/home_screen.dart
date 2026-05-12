import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'add_entry_dialog.dart';
import 'profile_screen.dart';
import 'login_screen.dart'; // ✅ TAMBAHAN: import untuk logout

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  final List<TransactionModel> _transactions = [];

  final _usd = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  double get _totalBalance =>
      _transactions.fold(0, (s, t) => s + t.signedAmount);

  double get _totalIncome => _transactions
      .where((t) => t.isIncome)
      .fold(0, (s, t) => s + t.amount);

  double get _totalExpense => _transactions
      .where((t) => !t.isIncome)
      .fold(0, (s, t) => s + t.amount);

  void _openAddEntry() {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => AddEntryDialog(
        onCommit: (tx) {
          setState(() => _transactions.insert(0, tx));
        },
      ),
    );
  }

  void _deleteTransaction(String id) {
    setState(() => _transactions.removeWhere((t) => t.id == id));
  }

  // ✅ FIX: Fungsi logout yang benar — navigasi ke LoginScreen
  void _doLogout() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _currentTab,
        children: [
          _PortfolioTab(
            user: widget.user,
            transactions: _transactions,
            totalBalance: _totalBalance,
            totalIncome: _totalIncome,
            totalExpense: _totalExpense,
            usd: _usd,
            onDelete: _deleteTransaction,
          ),
          _AnalysisTab(
            transactions: _transactions,
            totalBalance: _totalBalance,
            totalIncome: _totalIncome,
            totalExpense: _totalExpense,
            usd: _usd,
          ),
          _VaultTab(transactions: _transactions, usd: _usd),
          ProfileScreen(
            user: widget.user,
            onUserUpdated: () => setState(() {}), // ✅ rebuild saat profil diupdate
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFAB() {
    final bool isPortfolio = _currentTab == 0;
    return SizedBox(
      width: 62,
      height: 62,
      child: FloatingActionButton(
        onPressed: isPortfolio ? _openAddEntry : null,
        backgroundColor: Colors.transparent,
        elevation: isPortfolio ? 6 : 0,
        shape: const CircleBorder(),
        child: Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isPortfolio
                ? const LinearGradient(
                    colors: [AppTheme.goldLight, AppTheme.goldDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isPortfolio ? null : AppTheme.bgCardLight,
            boxShadow: isPortfolio
                ? const [
                    BoxShadow(
                      color: Color(0x66F0B429),
                      blurRadius: 18,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            Icons.add,
            color: isPortfolio ? Colors.black : AppTheme.textMuted,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      color: AppTheme.bgCard,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      notchMargin: 6,
      shape: const CircularNotchedRectangle(),
      padding: EdgeInsets.zero,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
        ),
        height: 64,
        child: Row(
          children: [
            Expanded(child: _navItem(Icons.home, Icons.home, 'Home', 0)),
            Expanded(child: _navItem(Icons.show_chart_outlined, Icons.show_chart_rounded, 'Analysis', 1)),
            const SizedBox(width: 72),
            Expanded(child: _navItem(Icons.lock_outline_rounded, Icons.lock_rounded, 'Vault', 2)),
            Expanded(child: _navItem(Icons.person_2, Icons.person_2, 'Profile', 3)),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, IconData activeIcon, String label, int index) {
    final isActive = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: isActive ? AppTheme.gold : AppTheme.textMuted,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppTheme.gold : AppTheme.textMuted,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ REVISI LENGKAP: Drawer menampilkan username + email dari input login/register
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppTheme.bgCard,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Brand title
            const Text('DAILY REPORT', style: AppTheme.brandTitleSmall),
            const SizedBox(height: 16),

            // ✅ Avatar
            Container(
              width: 70,
              height: 70,
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
                size: 34,
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Nama user dari input (fullName)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.user.fullName,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),

            // ✅ Email user dari input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.user.email,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),

            // ✅ Username user dari input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '@${widget.user.username}',
                style: const TextStyle(
                  color: AppTheme.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 20),
            const Divider(color: AppTheme.border),

            // Menu items
            _drawerItem(Icons.home, 'Home', 0),
            _drawerItem(Icons.show_chart_rounded, 'Analysis', 1),
            _drawerItem(Icons.lock_rounded, 'Vault', 2),
            _drawerItem(Icons.person, 'Profile', 3),

            const Spacer(),
            const Divider(color: AppTheme.border),

            // ✅ FIX: Logout benar-benar navigasi ke LoginScreen
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: AppTheme.danger),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  color: AppTheme.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // tutup drawer terlebih dahulu
                _doLogout();           // lalu navigasi ke login
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, int index) {
    final isActive = _currentTab == index;
    return ListTile(
      leading: Icon(icon,
          color: isActive ? AppTheme.gold : AppTheme.textSecondary),
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? AppTheme.gold : AppTheme.textSecondary,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
      tileColor: isActive ? AppTheme.gold.withValues(alpha: .05) : null,
      onTap: () {
        Navigator.pop(context);
        setState(() => _currentTab = index);
      },
    );
  }
}

// ─────────────────────────────────────────────
// Portfolio Tab
// ─────────────────────────────────────────────
class _PortfolioTab extends StatelessWidget {
  final UserModel user;
  final List<TransactionModel> transactions;
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final NumberFormat usd;
  final Function(String) onDelete;

  const _PortfolioTab({
    required this.user,
    required this.transactions,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.usd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── App Bar ──────────────────────────
        SliverAppBar(
          pinned: true,
          backgroundColor: AppTheme.bgPrimary,
          elevation: 0,
          leading: Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu, color: AppTheme.textSecondary),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          title: const Text('DAILY REPORT', style: AppTheme.brandTitleSmall),
          centerTitle: true,
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 8),

                // ── Balance Card ─────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.borderGold, width: 1),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'TOTAL BALANCE',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        usd.format(totalBalance),
                        style: TextStyle(
                          color: totalBalance >= 0
                              ? AppTheme.textPrimary
                              : AppTheme.danger,
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.bgCardLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'SYSTEM READY',
                              style: TextStyle(
                                color: AppTheme.success,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                if (transactions.isEmpty) ...[
                  // ── Empty State ────────────────
                  const SizedBox(height: 32),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.borderGold),
                    ),
                    child: const Icon(
                      Icons.account_balance_rounded,
                      color: AppTheme.gold,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Awaiting Foundation',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your portfolio canvas is empty. Establish your initial asset allocation to activate the dashboard analytics.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 120),
                ] else ...[
                  // ── Summary Row ─────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _summaryCard(
                          'INCOME',
                          totalIncome,
                          AppTheme.success,
                          Icons.arrow_downward_rounded,
                          usd,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _summaryCard(
                          'EXPENSE',
                          totalExpense,
                          AppTheme.danger,
                          Icons.arrow_upward_rounded,
                          usd,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Transaction List ────────────
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('RECENT ENTRIES', style: AppTheme.labelStyle),
                  ),
                  const SizedBox(height: 12),
                  ...transactions.map((tx) => _txTile(tx, context)),
                  const SizedBox(height: 100),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(String label, double amount, Color color, IconData icon, NumberFormat fmt) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                        letterSpacing: 1)),
                const SizedBox(height: 2),
                Text(
                  fmt.format(amount),
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _txTile(TransactionModel tx, BuildContext context) {
    final isIncome = tx.isIncome;
    final color = isIncome ? AppTheme.success : AppTheme.danger;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.description,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${tx.classification}  ·  ${DateFormat('MMM d, yyyy').format(tx.date)}',
                  style: const TextStyle(
                      color: AppTheme.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'}Rp ${NumberFormat('#,###', 'id_ID').format(tx.amount)}',
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => _confirmDelete(context, tx.id),
                child: const Icon(Icons.delete_outline_rounded,
                    color: AppTheme.textMuted, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Transaksi?',
            style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text('Data tidak dapat dikembalikan.',
            style: TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete(id);
            },
            child: const Text('Hapus',
                style: TextStyle(
                    color: AppTheme.danger, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Analysis Tab
// ─────────────────────────────────────────────
class _AnalysisTab extends StatelessWidget {
  final List<TransactionModel> transactions;
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final NumberFormat usd;

  const _AnalysisTab({
    required this.transactions,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.usd,
  });

  @override
  Widget build(BuildContext context) {
    final incomeRatio = (totalIncome + totalExpense) > 0
        ? totalIncome / (totalIncome + totalExpense)
        : 0.0;

    final Map<String, double> byClass = {};
    for (final tx in transactions) {
      byClass[tx.classification] =
          (byClass[tx.classification] ?? 0) + tx.amount;
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppTheme.bgPrimary,
          elevation: 0,
          leading: Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu, color: AppTheme.textSecondary),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          title: const Text('DAILY REPORT', style: AppTheme.brandTitleSmall),
          centerTitle: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ANALYSIS', style: AppTheme.labelStyle),
                const SizedBox(height: 16),

                if (transactions.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Column(
                        children: [
                          const Icon(Icons.show_chart_rounded,
                              color: AppTheme.textMuted, size: 60),
                          const SizedBox(height: 16),
                          const Text('Belum ada data untuk dianalisis',
                              style: TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 14)),
                        ],
                      ),
                    ),
                  )
                else ...[
                  // ── Cash Flow Visual ────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppTheme.cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('CASH FLOW RATIO', style: AppTheme.labelStyle),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 14,
                            child: Row(
                              children: [
                                Flexible(
                                  flex: (incomeRatio * 100).round(),
                                  child: Container(color: AppTheme.success),
                                ),
                                Flexible(
                                  flex: ((1 - incomeRatio) * 100).round(),
                                  child: Container(color: AppTheme.danger),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _legendDot(AppTheme.success,
                                'Income ${(incomeRatio * 100).toStringAsFixed(1)}%'),
                            _legendDot(AppTheme.danger,
                                'Expense ${((1 - incomeRatio) * 100).toStringAsFixed(1)}%'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Net Worth ───────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppTheme.cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('NET POSITION', style: AppTheme.labelStyle),
                        const SizedBox(height: 12),
                        Text(
                          usd.format(totalBalance),
                          style: TextStyle(
                            color: totalBalance >= 0
                                ? AppTheme.gold
                                : AppTheme.danger,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          totalBalance >= 0
                              ? 'Portfolio in surplus'
                              : 'Portfolio in deficit',
                          style: TextStyle(
                            color: totalBalance >= 0
                                ? AppTheme.success
                                : AppTheme.danger,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── By Classification ───────────
                  if (byClass.isNotEmpty) ...[
                    const Text('BY CLASSIFICATION', style: AppTheme.labelStyle),
                    const SizedBox(height: 12),
                    ...byClass.entries.map((e) {
                      final pct = (totalIncome + totalExpense) > 0
                          ? e.value / (totalIncome + totalExpense)
                          : 0.0;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: AppTheme.cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e.key,
                                    style: const TextStyle(
                                        color: AppTheme.textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                Text(usd.format(e.value),
                                    style: const TextStyle(
                                        color: AppTheme.gold,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct,
                                minHeight: 6,
                                backgroundColor: AppTheme.border,
                                valueColor: const AlwaysStoppedAnimation(
                                    AppTheme.gold),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  const SizedBox(height: 80),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 12)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Vault Tab
// ─────────────────────────────────────────────
class _VaultTab extends StatelessWidget {
  final List<TransactionModel> transactions;
  final NumberFormat usd;

  const _VaultTab({required this.transactions, required this.usd});

  @override
  Widget build(BuildContext context) {
    final sorted = [...transactions]
      ..sort((a, b) => b.date.compareTo(a.date));

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppTheme.bgPrimary,
          elevation: 0,
          leading: Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu, color: AppTheme.textSecondary),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          title: const Text('DAILY REPORT', style: AppTheme.brandTitleSmall),
          centerTitle: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('VAULT — ALL RECORDS', style: AppTheme.labelStyle),
                const SizedBox(height: 16),
                if (sorted.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Column(
                        children: const [
                          Icon(Icons.lock_rounded,
                              color: AppTheme.textMuted, size: 60),
                          SizedBox(height: 16),
                          Text('Vault kosong',
                              style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                  )
                else
                  ...sorted.map((tx) {
                    final color =
                        tx.isIncome ? AppTheme.success : AppTheme.danger;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: AppTheme.cardDecoration(),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: .12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              tx.isIncome
                                  ? Icons.arrow_downward_rounded
                                  : Icons.arrow_upward_rounded,
                              color: color,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tx.description,
                                    style: const TextStyle(
                                        color: AppTheme.textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 2),
                                Text(
                                  tx.classification,
                                  style: const TextStyle(
                                      color: AppTheme.textMuted, fontSize: 11),
                                ),
                                Text(
                                  DateFormat('EEEE, MMM d yyyy').format(tx.date),
                                  style: const TextStyle(
                                      color: AppTheme.textMuted, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${tx.isIncome ? '+' : '-'}${usd.format(tx.amount)}',
                            style: TextStyle(
                              color: color,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}