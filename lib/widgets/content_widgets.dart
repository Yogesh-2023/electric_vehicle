part of '../main.dart';

class VehicleHero extends StatelessWidget {
  const VehicleHero({super.key, required this.ticket});

  final InspectionTicket ticket;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/new-ev-scooter.png',
              height: 150,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            ticket.vehicle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            '${ticket.registration} • ${ticket.customer}',
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: ticket.progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(99),
            backgroundColor: AppColors.border,
            color: AppColors.green,
          ),
        ],
      ),
    );
  }
}

class InspectionTile extends StatelessWidget {
  const InspectionTile({super.key, required this.ticket});

  final InspectionTicket ticket;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.two_wheeler, color: AppColors.primary),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.vehicle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ticket.id} • ${ticket.registration}',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: ticket.progress,
                    minHeight: 7,
                    borderRadius: BorderRadius.circular(99),
                    backgroundColor: AppColors.border,
                    color: AppColors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            StatusChip(label: ticket.priority),
          ],
        ),
      ),
    );
  }
}

class ChecklistRow extends StatelessWidget {
  const ChecklistRow({super.key, required this.section});

  final InspectionSection section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Icon(section.icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                section.title,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            Icon(
              section.done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: section.done ? AppColors.green : AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class TimelineRow extends StatelessWidget {
  const TimelineRow({super.key, required this.item});

  final TimelineItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.done ? Icons.check_circle : Icons.circle_outlined,
            color: item.done ? AppColors.green : AppColors.muted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InventoryTile extends StatelessWidget {
  const InventoryTile({super.key, required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    final isLow = item.status == 'Low Stock';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isLow ? const Color(0xFFFFF7ED) : AppColors.primarySoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                item.icon,
                color: isLow ? AppColors.amber : AppColors.primary,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.qty,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            StatusChip(label: item.status, warning: isLow),
          ],
        ),
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  const QuickAction({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = AppCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 30),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ],
      ),
    );

    if (onTap == null) return card;

    return GestureDetector(onTap: onTap, child: card);
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: danger ? Colors.red : AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: danger ? Colors.red : AppColors.text,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = Colors.white,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color == Colors.white ? AppColors.border : Colors.transparent,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action});

  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
        const Spacer(),
        if (action != null)
          Text(
            action!,
            style: const TextStyle(
              color: AppColors.green,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
      ],
    );
  }
}

class AppBadge extends StatelessWidget {
  const AppBadge({super.key, required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.greenSoft,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: const Color(0xFFD6EED0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.green, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.green,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}

class MetricPill extends StatelessWidget {
  const MetricPill({
    super.key,
    required this.value,
    required this.label,
    this.dark = false,
  });

  final String value;
  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: dark ? Colors.white.withValues(alpha: 0.12) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: dark ? Colors.white.withValues(alpha: 0.18) : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: dark ? Colors.white : AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: dark ? const Color(0xFFDCEBFF) : AppColors.muted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, this.warning = false});

  final String label;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: warning ? const Color(0xFFFFF7ED) : AppColors.greenSoft,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: warning ? AppColors.amber : AppColors.green,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
