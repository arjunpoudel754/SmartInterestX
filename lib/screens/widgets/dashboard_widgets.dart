import 'package:flutter/material.dart';
import 'package:my_backend_app_2/screens/utils/colors.dart';

/// White rounded card with a light border (Overview / Transactions containers).
class DashCard extends StatelessWidget {
  final Widget child;
  const DashCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DashColors.border),
      ),
      child: child,
    );
  }
}

/// Blue header with menu button, title and bell.
class DashAppBar extends StatelessWidget {
  final VoidCallback? onMenu;
  final VoidCallback? onBell;
  const DashAppBar({super.key, this.onMenu, this.onBell});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: DashColors.blue,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onMenu,
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SmartInterestX',
                    style: dashText(22, FontWeight.w700, Colors.white)),
                const SizedBox(height: 2),
                Text('Loan & interest dashboard',
                    style: dashText(
                        12, FontWeight.w500, Colors.white.withOpacity(0.8))),
              ],
            ),
          ),
          InkWell(
            onTap: onBell,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.notifications_none,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Total Amount Given | Total Amount Taken" box.
class TotalsRow extends StatelessWidget {
  final String givenAmount, takenAmount;
  const TotalsRow({
    super.key,
    required this.givenAmount,
    required this.takenAmount,
  });

  Widget _side(String label, String amount, Color noteColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: dashText(12, FontWeight.w600, Colors.black)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(amount,
                style: dashText(22, FontWeight.w700, Colors.black)),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 14, 15, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DashColors.border),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _side('Total Amount Given', givenAmount,
                DashColors.success),
            Container(
              width: 1,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: DashColors.border,
            ),
            _side('Total Amount Taken', takenAmount,
                DashColors.danger),
          ],
        ),
      ),
    );
  }
}

/// Colored stat tile (Interest Earned, Interest Paid, ...).
class StatTile extends StatelessWidget {
  final String title, amount;
  final Color background, accent;
  final Color remarkColor;

  const StatTile({
    super.key,
    required this.title,
    required this.amount,
    required this.background,
    required this.accent,
    Color? remarkColor,
  }) : remarkColor = remarkColor ?? accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: dashText(12, FontWeight.w600, accent)),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(amount,
                style: dashText(22, FontWeight.w700, DashColors.mainText)),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

/// Dropdown-looking filter chip.
class FilterChipBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const FilterChipBox(
      {super.key, required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: DashColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: DashColors.subText),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: dashText(13, FontWeight.w600, DashColors.mainText)),
            ),
            const Icon(Icons.keyboard_arrow_down,
                size: 16, color: DashColors.subText),
          ],
        ),
      ),
    );
  }
}

enum TxTone { blue, orange, green, red }

/// One row in "Recent transactions".
class TransactionRow extends StatelessWidget {
  final String name, subtitle, amount, status;
  final IconData icon;
  final TxTone tone;

  const TransactionRow({
    super.key,
    required this.name,
    required this.subtitle,
    required this.amount,
    required this.status,
    required this.icon,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    late final Color rowBg, iconBg, fg;
    switch (tone) {
      case TxTone.blue:
        rowBg = DashColors.blueRowBg;
        iconBg = DashColors.blueRowIcon;
        fg = DashColors.blue;
        break;
      case TxTone.orange:
        rowBg = DashColors.pendingBg;
        iconBg = DashColors.pendingBgHigh;
        fg = DashColors.pending;
        break;
      case TxTone.green:
        rowBg = DashColors.successBg;
        iconBg = DashColors.successBg;
        fg = DashColors.success;
        break;
      case TxTone.red:
        rowBg = DashColors.dangerBg;
        iconBg = DashColors.dangerBg;
        fg = DashColors.danger;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: rowBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tone == TxTone.green ? DashColors.successBg.withOpacity(0.5) : 
                     tone == TxTone.red ? DashColors.dangerBg.withOpacity(0.5) : iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: fg),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        dashText(14, FontWeight.w700, DashColors.mainText)),
                const SizedBox(height: 2),
                Text(subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: dashText(12, FontWeight.w500, DashColors.subText)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: dashText(14, FontWeight.w700, fg)),
              const SizedBox(height: 2),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(status, style: dashText(11, FontWeight.w700, fg)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Floating blue bottom navigation pill.
class DashNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const DashNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  static const _icons = [
    Icons.grid_view_rounded,
    Icons.receipt_long_outlined,
    Icons.bar_chart_rounded,
    Icons.people_alt_sharp,
    Icons.settings_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: DashColors.blue,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_icons.length, (i) {
            final selected = i == currentIndex;
            return InkWell(
              onTap: () => onTap(i),
              customBorder: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: selected ? Colors.white.withOpacity(0.15) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(_icons[i],
                    size: 24,
                    color: selected ? Colors.white : Colors.white70),
              ),
            );
          }),
        ),
      ),
    );
  }
}