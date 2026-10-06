import 'package:flutter/material.dart';
import 'package:my_backend_app_2/screens/utils/colors.dart';
import 'package:my_backend_app_2/screens/widgets/dashboard_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SMARTINTERESTX', style: dashText(10, FontWeight.w800, DashColors.blue)),
                    Text('Settings', style: dashText(26, FontWeight.w800, DashColors.mainText)),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: DashColors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text('JD', style: dashText(14, FontWeight.w700, Colors.white))),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _sectionLabel('ACCOUNT'),
            const SizedBox(height: 8),
            DashCard(
              child: Column(
                children: [
                  _SettingsItem(
                    icon: Icons.person_outline,
                    iconColor: DashColors.blue,
                    iconBg: DashColors.blueSoft,
                    title: 'Profile',
                    subtitle: 'John Doe • john.doe@smartinterestx.com',
                  ),
                  const Divider(height: 24, color: DashColors.border),
                  _SettingsItem(
                    icon: Icons.shield_outlined,
                    iconColor: DashColors.success,
                    iconBg: DashColors.successBg,
                    title: 'Security',
                    subtitle: 'Passcode, Face ID & 2FA Setup',
                    trailingWidget: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: DashColors.successBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('ACTIVE', style: dashText(10, FontWeight.w700, DashColors.success)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionLabel('NOTIFICATIONS'),
            const SizedBox(height: 8),
            DashCard(
              child: _SettingsItem(
                icon: Icons.notifications_none,
                iconColor: DashColors.purple,
                iconBg: DashColors.purpleBg,
                title: 'Reminder Settings',
                subtitle: 'Yield payouts & balance milestone alerts',
              ),
            ),
            const SizedBox(height: 24),
            _sectionLabel('DATA'),
            const SizedBox(height: 8),
            DashCard(
              child: Column(
                children: [
                  _SettingsItem(
                    icon: Icons.cloud_outlined,
                    iconColor: DashColors.orange,
                    iconBg: DashColors.pendingBg,
                    title: 'Backup',
                    subtitle: 'Secure cloud sync & recovery key',
                  ),
                  const Divider(height: 24, color: DashColors.border),
                  _SettingsItem(
                    icon: Icons.download_outlined,
                    iconColor: DashColors.purple,
                    iconBg: DashColors.purpleBg,
                    title: 'Export Data',
                    subtitle: 'Download portfolio statements (PDF/CSV)',
                  ),
                  const Divider(height: 24, color: DashColors.border),
                  _SettingsItem(
                    icon: Icons.receipt_long_outlined,
                    iconColor: const Color(0xFF06B6D4), // Cyan
                    iconBg: const Color(0xFFECFEFF),
                    title: 'Payment Proof',
                    subtitle: 'Receipts and cryptographically signed logs',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionLabel('APPEARANCE'),
            const SizedBox(height: 8),
            DashCard(
              child: _SettingsItem(
                icon: Icons.wb_sunny_outlined,
                iconColor: const Color(0xFFEAB308), // Yellow
                iconBg: const Color(0xFFFEF9C3),
                title: 'Theme',
                subtitle: 'Customize your app interface layout',
                trailingText: 'System Default',
              ),
            ),
            const SizedBox(height: 24),
            _sectionLabel('ABOUT'),
            const SizedBox(height: 8),
            DashCard(
              child: _SettingsItem(
                icon: Icons.info_outline,
                iconColor: DashColors.subText,
                iconBg: DashColors.background,
                title: 'About SmartInterestX',
                subtitle: 'Licensing, legal & documentation',
                trailingText: 'v2.4.1',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: dashText(11, FontWeight.w700, DashColors.subText),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final Widget? trailingWidget;
  final String? trailingText;

  const _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    this.trailingWidget,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: dashText(14, FontWeight.w700, DashColors.mainText)),
              const SizedBox(height: 2),
              Text(subtitle, style: dashText(11, FontWeight.w500, DashColors.subText)),
            ],
          ),
        ),
        if (trailingText != null) ...[
          const SizedBox(width: 8),
          Text(trailingText!, style: dashText(12, FontWeight.w600, DashColors.subText)),
        ],
        if (trailingWidget != null) ...[
          const SizedBox(width: 8),
          trailingWidget!,
        ],
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right, size: 20, color: DashColors.subText),
      ],
    );
  }
}
