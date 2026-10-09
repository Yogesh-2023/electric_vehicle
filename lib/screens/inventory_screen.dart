part of '../main.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Inventory',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Spare Parts Stock', action: 'Update'),
          const SizedBox(height: 12),
          ...DemoData.inventory.map((item) => InventoryTile(item: item)),
          const SizedBox(height: 18),
          AppCard(
            color: AppColors.greenSoft,
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: AppColors.green),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Low stock parts are linked with active job sheets for faster workshop decisions.',
                    style: TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
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
