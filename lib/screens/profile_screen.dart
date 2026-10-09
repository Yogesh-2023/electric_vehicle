part of '../main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Profile',
      child: Column(
        children: [
          AppCard(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: AppColors.primarySoft,
                  child: Icon(Icons.person, size: 42, color: AppColors.primary),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Amit Verma',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Senior EV Technician',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: const [
                    Expanded(
                      child: MetricPill(value: '142', label: 'Jobs'),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: MetricPill(value: '4.9', label: 'Rating'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
          ),
          const SettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
          ),
          const SettingsTile(
            icon: Icons.support_agent_outlined,
            title: 'Service Centre Support',
          ),
          const SettingsTile(icon: Icons.logout, title: 'Logout', danger: true),
        ],
      ),
    );
  }
}
