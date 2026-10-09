part of '../main.dart';

class AccessoriesPartsScreen extends StatefulWidget {
  const AccessoriesPartsScreen({
    super.key,
    this.job,
    this.area = 'General Service',
    this.initialSelectedIndexes = const <int>{},
  });

  final CreatedJob? job;
  final String area;
  final Set<int> initialSelectedIndexes;

  @override
  State<AccessoriesPartsScreen> createState() => _AccessoriesPartsScreenState();
}

class _AccessoriesPartsScreenState extends State<AccessoriesPartsScreen> {
  late final Set<int> _selectedIndexes;

  @override
  void initState() {
    super.initState();
    _selectedIndexes = {...widget.initialSelectedIndexes};
  }

  int get _selectedTotal {
    return _selectedIndexes.fold<int>(
      0,
      (total, index) => total + DemoData.accessoryParts[index].priceAmount,
    );
  }

  String get _selectedTotalLabel => _formatPrice(_selectedTotal);

  @override
  Widget build(BuildContext context) {
    final selectedCount = _selectedIndexes.length;

    return AppScaffold(
      title: 'Parts & Accessories',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: SectionHeader(title: 'Service Parts'),
              ),
              _SelectionPill(
                label: selectedCount == 0
                    ? '0 selected'
                    : '$selectedCount selected',
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...DemoData.accessoryParts.asMap().entries.map((entry) {
            final index = entry.key;
            return AccessoryPartCard(
              item: entry.value,
              selected: _selectedIndexes.contains(index),
              onTap: () {
                setState(() {
                  if (!_selectedIndexes.add(index)) {
                    _selectedIndexes.remove(index);
                  }
                });
              },
            );
          }),
          const SizedBox(height: 6),
          _SelectionSummary(
            selectedCount: selectedCount,
            totalLabel: _selectedTotalLabel,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                    selectedCount == 0 ? AppColors.muted : AppColors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: selectedCount == 0
                  ? null
                  : () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => SelectedPartsReviewScreen(
                            job: widget.job,
                            area: widget.area,
                            selectedIndexes: _selectedIndexes,
                          ),
                        ),
                      );
                    },
              child: const Text(
                'CONTINUE',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int amount) {
    return _formatRupees(amount);
  }
}

class SelectedPartsReviewScreen extends StatefulWidget {
  const SelectedPartsReviewScreen({
    super.key,
    required this.area,
    required this.selectedIndexes,
    this.job,
  });

  final CreatedJob? job;
  final String area;
  final Set<int> selectedIndexes;

  @override
  State<SelectedPartsReviewScreen> createState() => _SelectedPartsReviewScreenState();
}

class _SelectedPartsReviewScreenState extends State<SelectedPartsReviewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final Set<int> _selectedIndexes;

  CreatedJob get _job => widget.job ?? DemoData.defaultOpenJobs.first;

  List<AccessoryPart> get _parts => _selectedIndexes
      .map((index) => DemoData.accessoryParts[index])
      .toList();

  int get _total => _parts.fold<int>(0, (total, item) => total + item.priceAmount);

  @override
  void initState() {
    super.initState();
    _selectedIndexes = {...widget.selectedIndexes};
  }

  void _handleDrawerItem(String key) {
    Navigator.pop(context);
    if (key == 'home' ||
        key == 'all' ||
        key == 'service_center' ||
        key == 'individual_user') {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (key == 'accessories_parts') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AccessoriesPartsScreen()),
      );
    } else if (key == 'create_job') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CreateJobScreen()),
      );
    } else if (key == 'logout') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = Responsive.isCompact(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      drawer: EVSideDrawer(onItem: _handleDrawerItem),
      appBar: MotoHeader(
        title: 'Selected Parts',
        rightIcon: Icons.add_rounded,
        onRight: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => AccessoriesPartsScreen(
                job: widget.job,
                area: widget.area,
                initialSelectedIndexes: _selectedIndexes,
              ),
            ),
          );
        },
        onMenu: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.maxContentWidth(context),
            ),
            child: ListView(
              padding: Responsive.pagePadding(context).copyWith(
                top: 14,
                bottom: 28,
              ),
              children: [
                Text(
                  _job.vehicleModel,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_job.customerName} | ${_job.vehicleNumber}',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                if (_parts.isEmpty)
                  AppCard(
                    child: Column(
                      children: [
                        const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 34),
                        const SizedBox(height: 10),
                        const Text(
                          'No parts selected',
                          style: TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => AccessoriesPartsScreen(
                                  job: widget.job,
                                  area: widget.area,
                                  initialSelectedIndexes: _selectedIndexes,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Add Parts'),
                        ),
                      ],
                    ),
                  )
                else
                  ..._selectedIndexes.map((index) {
                    final item = DemoData.accessoryParts[index];
                    return _ReviewPartTile(
                      item: item,
                      onDelete: () => setState(() => _selectedIndexes.remove(index)),
                    );
                  }),
                const SizedBox(height: 8),
                _TotalCard(total: _total),
                const SizedBox(height: 14),
                isCompact
                    ? Column(
                        children: [
                          _ServiceFlowButton(
                            label: 'SAVE',
                            color: AppColors.primary,
                            onPressed: _parts.isEmpty
                                ? null
                                : _saveAndOpenEstimation,
                          ),
                          const SizedBox(height: 10),
                          _ServiceFlowButton(
                            label: 'SAVE & START',
                            color: AppColors.green,
                            onPressed: _parts.isEmpty
                                ? null
                                : _saveAndStartInspection,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _ServiceFlowButton(
                              label: 'SAVE',
                              color: AppColors.primary,
                              onPressed: _parts.isEmpty
                                  ? null
                                  : _saveAndOpenEstimation,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ServiceFlowButton(
                              label: 'SAVE & START',
                              color: AppColors.green,
                              onPressed: _parts.isEmpty
                                  ? null
                                  : _saveAndStartInspection,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ServiceOrder _createOrder(String status) {
    final existingIndex = DemoData.serviceOrders.indexWhere((o) => o.job.id == _job.id);
    final order = ServiceOrder(
      id: existingIndex >= 0
          ? DemoData.serviceOrders[existingIndex].id
          : 'SRV-${DemoData.serviceOrders.length + 1001}',
      job: _job,
      area: widget.area,
      parts: _parts,
      totalAmount: _total,
      status: status,
    );
    if (existingIndex >= 0) {
      DemoData.serviceOrders[existingIndex] = order;
    } else {
      DemoData.serviceOrders.insert(0, order);
    }
    return order;
  }

  void _saveAndOpenEstimation() {
    _createOrder('Saved');
    var record = DemoData.inspectionForJob(_job);
    record ??= DemoData.saveInspection(
      job: _job,
      results: {
        for (final item in [
          'Battery',
          'Motor',
          'Controller',
          'Charger',
          'Brake',
          'Suspension',
          'Tyre',
          'Others'
        ])
          item: const InspectionResult(
            passed: true,
            action: 'Pass',
            cost: 0,
            remarks: '',
          ),
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Estimation saved successfully!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.green,
      ),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const JobsScreen()),
    );
  }

  void _saveAndStartInspection() {
    _createOrder('Started');
    var record = DemoData.inspectionForJob(_job);
    record ??= DemoData.saveInspection(
      job: _job,
      results: {
        for (final item in [
          'Battery',
          'Motor',
          'Controller',
          'Charger',
          'Brake',
          'Suspension',
          'Tyre',
          'Others'
        ])
          item: const InspectionResult(
            passed: true,
            action: 'Pass',
            cost: 0,
            remarks: '',
          ),
      },
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ServiceProgressScreen(record: record!),
      ),
    );
  }
}

class _ReviewPartTile extends StatelessWidget {
  const _ReviewPartTile({
    required this.item,
    required this.onDelete,
  });

  final AccessoryPart item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.greenSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item.icon, color: AppColors.green, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.price,
                    style: const TextStyle(
                      color: AppColors.green,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleDeliveryScreen extends StatefulWidget {
  const ScheduleDeliveryScreen({
    super.key,
    required this.area,
    required this.selectedIndexes,
    this.job,
  });

  final CreatedJob? job;
  final String area;
  final Set<int> selectedIndexes;

  @override
  State<ScheduleDeliveryScreen> createState() => _ScheduleDeliveryScreenState();
}

class _ScheduleDeliveryScreenState extends State<ScheduleDeliveryScreen> {
  final TextEditingController _dateController = TextEditingController(text: '25 May 2026');
  final TextEditingController _notesController = TextEditingController();
  String _selectedSlot = '12:00 PM - 02:00 PM';

  CreatedJob get _job => widget.job ?? DemoData.defaultOpenJobs.first;
  List<AccessoryPart> get _parts => widget.selectedIndexes
      .map((index) => DemoData.accessoryParts[index])
      .toList();
  int get _total => _parts.fold<int>(0, (total, item) => total + item.priceAmount);

  @override
  void dispose() {
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const slots = [
      '10:00 AM - 12:00 PM',
      '12:00 PM - 02:00 PM',
      '02:00 PM - 04:00 PM',
      '04:00 PM - 06:00 PM',
    ];

    return AppScaffold(
      title: 'Schedule Delivery',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel('Select Date'),
          const SizedBox(height: 8),
          TextField(
            controller: _dateController,
            readOnly: true,
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.calendar_month_outlined),
              hintText: 'Select date',
            ),
          ),
          const SizedBox(height: 18),
          const FieldLabel('Select Time Slot'),
          const SizedBox(height: 8),
          ...slots.map((slot) {
            final selected = _selectedSlot == slot;
            return InkWell(
              onTap: () => setState(() => _selectedSlot = slot),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: selected ? AppColors.primary : AppColors.muted,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        slot,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          const FieldLabel('Additional Notes'),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            minLines: 3,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Enter notes (optional)',
            ),
          ),
          const SizedBox(height: 18),
          _TotalCard(total: _total),
          const SizedBox(height: 16),
          _ServiceFlowButton(
            label: 'ADD TO QUEUE',
            color: AppColors.green,
            onPressed: _addToQueue,
          ),
        ],
      ),
    );
  }

  void _addToQueue() {
    final order = ServiceOrder(
      id: 'SRV-${DemoData.serviceOrders.length + 1001}',
      job: _job,
      area: widget.area,
      parts: _parts,
      totalAmount: _total,
      status: 'Queued',
      deliveryDate: _dateController.text,
      deliveryTime: _selectedSlot,
      notes: _notesController.text.trim(),
    );
    DemoData.serviceOrders.insert(0, order);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ServiceOrdersScreen()),
    );
  }
}

class ServiceOrdersScreen extends StatelessWidget {
  const ServiceOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = DemoData.serviceOrders;
    return AppScaffold(
      title: 'Saved Services',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBadge(label: 'SERVICE QUEUE', icon: Icons.playlist_add_check),
          const SizedBox(height: 14),
          const Text(
            'Saved service items',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          if (orders.isEmpty)
            const AppCard(
              child: Text(
                'No saved service items yet.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            ...orders.map((order) => _ServiceOrderCard(order: order)),
        ],
      ),
    );
  }
}

class _ServiceOrderCard extends StatelessWidget {
  const _ServiceOrderCard({required this.order});

  final ServiceOrder order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.job.vehicleModel,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                StatusChip(label: order.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${order.area} | ${order.parts.length} item${order.parts.length == 1 ? '' : 's'}',
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            ...order.parts.map((part) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        part.name,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      part.price,
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const Divider(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.deliveryTime.isEmpty
                        ? order.id
                        : '${order.deliveryDate}, ${order.deliveryTime}',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  _formatRupees(order.totalAmount),
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.greenSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.green,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Service Estimate',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                _formatRupees(total),
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.greenSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Selected parts total. Labour and taxes can be added during final billing.',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceFlowButton extends StatelessWidget {
  const _ServiceFlowButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

String _formatRupees(int amount) {
  final value = amount.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < value.length; i++) {
    final reverseIndex = value.length - i;
    buffer.write(value[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write(',');
    }
  }
  return 'Rs. $buffer';
}

class AccessoryPartCard extends StatelessWidget {
  const AccessoryPartCard({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AccessoryPart item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final imageSize = Responsive.isCompact(context) ? 72.0 : 88.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppColors.green : AppColors.border,
                width: selected ? 1.6 : 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F0F172A),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: Image.asset(
                      item.imageAsset,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.text,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                height: 1.22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _SelectionMark(selected: selected),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${item.category} part for EV service. ${item.stock}.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.price,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionMark extends StatelessWidget {
  const _SelectionMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: selected ? AppColors.green : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.green : const Color(0xFFE3E8F4),
        ),
      ),
      child: Icon(
        selected ? Icons.check_rounded : Icons.radio_button_unchecked_rounded,
        color: selected ? Colors.white : AppColors.primary,
        size: 16,
      ),
    );
  }
}

class _SelectionPill extends StatelessWidget {
  const _SelectionPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.greenSoft,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.green,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SelectionSummary extends StatelessWidget {
  const _SelectionSummary({
    required this.selectedCount,
    required this.totalLabel,
  });

  final int selectedCount;
  final String totalLabel;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: selectedCount == 0
                      ? AppColors.primarySoft
                      : AppColors.greenSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  selectedCount == 0
                      ? Icons.touch_app_outlined
                      : Icons.check_circle_outline,
                  color: selectedCount == 0 ? AppColors.primary : AppColors.green,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedCount == 0
                      ? 'Select parts to continue'
                      : '$selectedCount selected',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                selectedCount == 0 ? 'Rs. 0' : totalLabel,
                style: TextStyle(
                  color: selectedCount == 0 ? AppColors.muted : AppColors.green,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: selectedCount == 0
                  ? AppColors.primarySoft
                  : AppColors.greenSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              selectedCount == 0
                  ? 'Pick the parts or accessories needed for this service.'
                  : 'Review selected items on the next screen before saving.',
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
