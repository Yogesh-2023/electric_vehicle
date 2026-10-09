part of '../main.dart';

class InspectionOptionsScreen extends StatelessWidget {
  const InspectionOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Inspection',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBadge(
            label: 'INSPECTION TYPE',
            icon: Icons.fact_check_outlined,
          ),
          const SizedBox(height: 14),
          const Text(
            'Select inspection',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 18),
          _InspectionOptionCard(
            icon: Icons.playlist_add_check_circle_outlined,
            title: 'Pre Inspection',
            subtitle: 'Vehicle intake and service checklist',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PreInspectionJobsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _InspectionOptionCard(
            icon: Icons.receipt_long_outlined,
            title: 'Final Estimation',
            subtitle: 'View detailed cost breakdown & final estimates',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const FinalEstimatesListScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _InspectionOptionCard(
            icon: Icons.verified_outlined,
            title: 'Pre Delivery',
            subtitle: 'Final checks before vehicle handover',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const InspectionsScreen(
                    title: 'Pre Delivery',
                    checklistTitle: 'Pre-Delivery Checklist',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InspectionOptionCard extends StatelessWidget {
  const _InspectionOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.greenSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.green, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InspectionsScreen extends StatelessWidget {
  const InspectionsScreen({
    super.key,
    this.title = 'Inspection',
    this.checklistTitle = 'Pre-Service Checklist',
  });

  final String title;
  final String checklistTitle;

  @override
  Widget build(BuildContext context) {
    final ticket = DemoData.inspections.first;
    return AppScaffold(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VehicleHero(ticket: ticket),
          const SizedBox(height: 18),
          SectionHeader(title: checklistTitle),
          const SizedBox(height: 10),
          ...ticket.sections.map((section) => ChecklistRow(section: section)),
          const SizedBox(height: 18),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Technician Remarks',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 12),
                const TextField(
                  minLines: 3,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText:
                        'Battery temperature, tyre condition, customer complaint...',
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('Add Proof'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.green,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FinalEstimatesListScreen extends StatelessWidget {
  const FinalEstimatesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = DemoData.serviceInspectionRecords;
    final columns = Responsive.dashboardColumns(context);

    return AppScaffold(
      title: 'Final Estimation',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBadge(
            label: 'ESTIMATE SUMMARY',
            icon: Icons.receipt_long_rounded,
          ),
          const SizedBox(height: 14),
          const Text(
            'Final Service Estimates',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'View repair items, parts subtotal, and final total estimates for vehicle services.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          if (records.isEmpty)
            AppCard(
              child: Column(
                children: [
                  const Icon(
                    Icons.receipt_long_outlined,
                    color: AppColors.primary,
                    size: 38,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'No final estimates available yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Complete a pre-service inspection to generate vehicle repair and parts estimates.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const OpenJobsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.work_outline_rounded),
                    label: const Text('View Open Jobs'),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: Responsive.dashboardAspectRatio(context),
              ),
              itemBuilder: (context, index) {
                final record = records[index];
                return InspectionEstimateCard(
                  record: record,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FinalEstimateScreen(record: record),
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

class PreInspectionJobsScreen extends StatelessWidget {
  const PreInspectionJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = DemoData.serviceInspectionRecords;
    final columns = Responsive.dashboardColumns(context);

    return AppScaffold(
      title: 'Pre Inspection',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBadge(label: 'INSPECTION SAVED', icon: Icons.fact_check),
          const SizedBox(height: 14),
          const Text(
            'Completed inspections',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Final pass/fail estimate cards appear here after service inspection is submitted.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          if (records.isEmpty)
            AppCard(
              child: Column(
                children: [
                  const Icon(
                    Icons.assignment_outlined,
                    color: AppColors.primary,
                    size: 36,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'No completed inspections yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Open a job, start service inspection, submit pass/fail estimate, then it will show here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const OpenJobsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.work_outline_rounded),
                    label: const Text('View Open Jobs'),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: Responsive.dashboardAspectRatio(context),
              ),
              itemBuilder: (context, index) {
                final record = records[index];
                return InspectionEstimateCard(
                  record: record,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            InspectionJobDetailsScreen(record: record),
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

class InspectionJobDetailsScreen extends StatelessWidget {
  const InspectionJobDetailsScreen({super.key, required this.record});

  final ServiceInspectionRecord record;

  @override
  Widget build(BuildContext context) {
    final job = record.job;

    return AppScaffold(
      title: 'Inspection Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBadge(label: record.status.toUpperCase(), icon: Icons.receipt),
          const SizedBox(height: 14),
          Text(
            job.vehicleModel,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${job.id} | ${job.vehicleNumber}',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Customer Details'),
                const SizedBox(height: 12),
                _InspectionDetailRow(
                  icon: Icons.person_outline,
                  label: 'Customer Name',
                  value: job.customerName,
                ),
                _InspectionDetailRow(
                  icon: Icons.call_outlined,
                  label: 'Mobile Number',
                  value: job.mobileNumber,
                ),
                _InspectionDetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: job.address,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Vehicle Details'),
                const SizedBox(height: 12),
                _InspectionDetailRow(
                  icon: Icons.confirmation_number_outlined,
                  label: 'Vehicle Number',
                  value: job.vehicleNumber,
                ),
                _InspectionDetailRow(
                  icon: Icons.business_outlined,
                  label: 'Vehicle Brand',
                  value: job.vehicleBrand,
                ),
                _InspectionDetailRow(
                  icon: Icons.two_wheeler_outlined,
                  label: 'Vehicle Model',
                  value: job.vehicleModel,
                ),
                _InspectionDetailRow(
                  icon: Icons.electric_bolt_outlined,
                  label: 'Vehicle Type',
                  value: job.vehicleType,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Other Details'),
                const SizedBox(height: 12),
                _InspectionDetailRow(
                  icon: Icons.settings_outlined,
                  label: 'Motor Number',
                  value: job.motorNumber.isEmpty ? 'Not provided' : job.motorNumber,
                ),
                _InspectionDetailRow(
                  icon: Icons.battery_charging_full_outlined,
                  label: 'Battery Number',
                  value: job.batteryNumber.isEmpty
                      ? 'Not provided'
                      : job.batteryNumber,
                ),
                _InspectionDetailRow(
                  icon: Icons.speed_outlined,
                  label: 'KM Reading',
                  value: job.odometerReading.isEmpty
                      ? 'Not provided'
                      : '${job.odometerReading} KM',
                ),
                _InspectionDetailRow(
                  icon: Icons.calendar_month_outlined,
                  label: 'Registration Date',
                  value: job.registrationDate.isEmpty
                      ? 'Not provided'
                      : job.registrationDate,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _InspectionTotalCard(record: record),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FinalEstimateScreen(record: record),
                  ),
                );
              },
              child: const Text(
                'VIEW FINAL ESTIMATE',
                style: TextStyle(
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
}

class ServiceInspectionChecklistScreen extends StatefulWidget {
  const ServiceInspectionChecklistScreen({super.key, required this.job});

  final CreatedJob job;

  @override
  State<ServiceInspectionChecklistScreen> createState() =>
      _ServiceInspectionChecklistScreenState();
}

class _ServiceInspectionChecklistScreenState
    extends State<ServiceInspectionChecklistScreen> {
  final Map<String, InspectionResult> _results = {};
  int _stage = 0;

  static const _items = [
    'Battery',
    'Motor',
    'Controller',
    'Charger',
    'Brake',
    'Suspension',
    'Tyre',
    'Others',
  ];

  int get _totalEstimate {
    return _results.values.fold<int>(
      0,
      (total, result) => total + (result.passed ? 0 : result.cost),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_stage == 1) {
      return _buildSummary(context);
    }
    if (_stage == 2) {
      return _buildProceed(context);
    }

    final isCompact = Responsive.isCompact(context);

    return AppScaffold(
      title: 'Pre-Service Inspection',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.greenSoft,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.green.withAlpha(76)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.task_alt_rounded,
                  color: AppColors.green,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'SERVICE STARTED',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            widget.job.vehicleModel,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${widget.job.customerName} | ${widget.job.vehicleNumber}',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Inspection Checklist'),
                const SizedBox(height: 14),
                if (isCompact)
                  ..._items.map((item) {
                    final result = _results[item];
                    return _ServiceInspectionRow(
                      label: item,
                      result: result,
                      onPass: () {
                        setState(() {
                          _results[item] = const InspectionResult(
                            passed: true,
                            action: 'Pass',
                            cost: 0,
                            remarks: '',
                          );
                        });
                      },
                      onFail: () => _showFailDialog(item),
                    );
                  })
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 60,
                    ),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      final result = _results[item];
                      return _ServiceInspectionRow(
                        label: item,
                        result: result,
                        onPass: () {
                          setState(() {
                            _results[item] = const InspectionResult(
                              passed: true,
                              action: 'Pass',
                              cost: 0,
                              remarks: '',
                            );
                          });
                        },
                        onFail: () => _showFailDialog(item),
                      );
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              onPressed: () {
                for (final item in _items) {
                  _results.putIfAbsent(
                    item,
                    () => const InspectionResult(
                      passed: true,
                      action: 'Pass',
                      cost: 0,
                      remarks: '',
                    ),
                  );
                }
                setState(() => _stage = 1);
              },
              child: const Text(
                'SUBMIT INSPECTION',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showFailDialog(String item) async {
    final current = _results[item];
    String action = current?.action == 'Replace' ? 'Replace' : 'Repair';
    final estimatedCost = current != null && current.cost > 0
        ? current.cost
        : _defaultCostFor(item);

    final result = await showDialog<InspectionResult>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                '$item - Inspection',
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w800,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Inspection Result'),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                      ),
                      child: const Text(
                        'Fail',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const FieldLabel('Select Action'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _DialogChoiceButton(
                            label: 'Repair',
                            selected: action == 'Repair',
                            onTap: () => setDialogState(() => action = 'Repair'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DialogChoiceButton(
                            label: 'Replace',
                            selected: action == 'Replace',
                            onTap: () => setDialogState(() => action = 'Replace'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const FieldLabel('Estimated Cost'),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.muted,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _formatInspectionCost(estimatedCost),
                              style: const TextStyle(
                                color: AppColors.text,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
              actions: [
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(
                        dialogContext,
                        InspectionResult(
                          passed: false,
                          action: action,
                          cost: estimatedCost,
                          remarks: '',
                        ),
                      );
                    },
                    child: const Text(
                      'SAVE & NEXT',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null || !mounted) return;
    setState(() {
      _results[item] = result;
    });
  }

  Widget _buildSummary(BuildContext context) {
    return AppScaffold(
      title: 'Inspection Summary',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBadge(label: 'PRE-SERVICE SUMMARY', icon: Icons.summarize),
          const SizedBox(height: 14),
          Text(
            widget.job.vehicleModel,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${widget.job.customerName} | ${widget.job.vehicleNumber}',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                ..._items.map((item) {
                  final result = _results[item]!;
                  return _SummaryInspectionRow(label: item, result: result);
                }),
                const Divider(height: 22),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total Estimated Cost',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      _formatInspectionCost(_totalEstimate),
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              onPressed: () {
                DemoData.saveInspection(job: widget.job, results: _results);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => AccessoriesPartsScreen(job: widget.job),
                  ),
                );
              },
              child: const Text(
                'CONTINUE TO PARTS & ACCESSORIES',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProceed(BuildContext context) {
    return AppScaffold(
      title: 'Pre-Service Inspection Done',
      child: Column(
        children: [
          AppCard(
            padding: const EdgeInsets.fromLTRB(18, 28, 18, 22),
            child: Column(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(
                    color: AppColors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Inspection Completed Successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Proceed to select parts & accessories for this service.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => AccessoriesPartsScreen(job: widget.job),
                        ),
                      );
                    },
                    child: const Text(
                      'CONTINUE TO PARTS & ACCESSORIES',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const PreInspectionJobsScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'VIEW ALL INSPECTIONS',
                      style: TextStyle(fontWeight: FontWeight.w800),
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

  int _defaultCostFor(String item) {
    switch (item) {
      case 'Controller':
        return 1250;
      case 'Suspension':
        return 850;
      case 'Battery':
        return 1800;
      case 'Motor':
        return 1500;
      case 'Charger':
        return 900;
      case 'Brake':
        return 650;
      case 'Tyre':
        return 700;
      default:
        return 500;
    }
  }
}

class _ServiceInspectionRow extends StatelessWidget {
  const _ServiceInspectionRow({
    required this.label,
    required this.result,
    required this.onPass,
    required this.onFail,
  });

  final String label;
  final InspectionResult? result;
  final VoidCallback onPass;
  final VoidCallback onFail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _PassFailButton(
            label: 'Pass',
            selected: result?.passed == true,
            color: AppColors.green,
            selectedColor: const Color(0xFFDCFCE7),
            onTap: onPass,
          ),
          const SizedBox(width: 10),
          _PassFailButton(
            label: 'Fail',
            selected: result?.passed == false,
            color: Colors.red,
            selectedColor: const Color(0xFFFEE2E2),
            onTap: onFail,
          ),
        ],
      ),
    );
  }
}

class _PassFailButton extends StatelessWidget {
  const _PassFailButton({
    required this.label,
    required this.selected,
    required this.color,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          width: 66,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? selectedColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? color : AppColors.border,
              width: selected ? 1.6 : 1.0,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? color : AppColors.muted,
              fontSize: 13,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogChoiceButton extends StatelessWidget {
  const _DialogChoiceButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? AppColors.primarySoft : Colors.white,
        side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: selected ? AppColors.primary : AppColors.text,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SummaryInspectionRow extends StatelessWidget {
  const _SummaryInspectionRow({
    required this.label,
    required this.result,
  });

  final String label;
  final InspectionResult result;

  @override
  Widget build(BuildContext context) {
    final status = result.passed ? 'Pass' : result.action;
    final color = result.passed ? AppColors.green : AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (!result.passed)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                _formatInspectionCost(result.cost),
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class FinalEstimateScreen extends StatelessWidget {
  const FinalEstimateScreen({super.key, required this.record});

  final ServiceInspectionRecord record;

  @override
  Widget build(BuildContext context) {
    final order = DemoData.orderByJob(record.job);
    final selectedParts = order?.parts ?? [];
    final failedResults = record.results.entries
        .where((entry) => !entry.value.passed)
        .toList();
    final grandTotal = record.grandTotalEstimate;

    return AppScaffold(
      title: 'Final Estimate',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBadge(label: 'FINAL ESTIMATE', icon: Icons.receipt_long_rounded),
          const SizedBox(height: 14),
          Text(
            record.job.vehicleModel,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${record.job.customerName} | ${record.job.vehicleNumber}',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: SectionHeader(title: 'Inspection Repairs & Services'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${failedResults.length} Items',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (failedResults.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'All inspection items passed.',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else
                  ...failedResults.map((entry) {
                    final item = entry.key;
                    final res = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: res.action == 'Replace'
                                  ? const Color(0xFFFEF2F2)
                                  : AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              res.action == 'Replace'
                                  ? Icons.build_circle_outlined
                                  : Icons.handyman_outlined,
                              color: res.action == 'Replace'
                                  ? Colors.red
                                  : AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item,
                                  style: const TextStyle(
                                    color: AppColors.text,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Action: ${res.action}',
                                  style: TextStyle(
                                    color: res.action == 'Replace'
                                        ? Colors.red
                                        : AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _formatInspectionCost(res.cost),
                            style: const TextStyle(
                              color: AppColors.text,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                const Divider(height: 20),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Repair Subtotal',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      _formatInspectionCost(record.totalEstimate),
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: SectionHeader(title: 'Selected Parts & Accessories'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.greenSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${selectedParts.length} Parts',
                        style: const TextStyle(
                          color: AppColors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (selectedParts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'No additional parts added yet.',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AccessoriesPartsScreen(job: record.job),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Add Parts'),
                        ),
                      ],
                    ),
                  )
                else
                  ...selectedParts.map((part) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.greenSoft,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(part.icon, color: AppColors.green, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  part.name,
                                  style: const TextStyle(
                                    color: AppColors.text,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  part.category,
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _formatInspectionCost(part.priceAmount),
                            style: const TextStyle(
                              color: AppColors.text,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                if (selectedParts.isNotEmpty) ...[
                  const Divider(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Parts Subtotal',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        _formatInspectionCost(record.partsEstimate),
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.green.withAlpha(50),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.payments_rounded,
                    color: AppColors.green,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FINAL TOTAL ESTIMATE',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatInspectionCost(grandTotal),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              onPressed: () {
                record.status = 'Service Started';
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => ServiceProgressScreen(record: record),
                  ),
                );
              },
              child: const Text(
                'START SERVICE',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceProgressScreen extends StatefulWidget {
  const ServiceProgressScreen({super.key, required this.record});

  final ServiceInspectionRecord record;

  @override
  State<ServiceProgressScreen> createState() => _ServiceProgressScreenState();
}

class _ServiceProgressScreenState extends State<ServiceProgressScreen> {
  @override
  Widget build(BuildContext context) {
    final record = widget.record;
    final progressTotal = record.serviceProgress.length;
    final completed = record.completedServiceCount;

    return AppScaffold(
      title: 'Service Progress',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBadge(
            label: record.isServiceComplete ? 'SERVICE COMPLETE' : 'IN SERVICE',
            icon: Icons.handyman_rounded,
          ),
          const SizedBox(height: 14),
          Text(
            record.job.vehicleModel,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$completed of $progressTotal repair tasks completed',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Repair Tasks'),
                const SizedBox(height: 12),
                ...record.serviceProgress.entries.map((entry) {
                  final result = record.results[entry.key]!;
                  return _ServiceProgressRow(
                    label: entry.key,
                    result: result,
                    done: entry.value,
                    onChanged: (value) {
                      setState(() {
                        record.serviceProgress[entry.key] = value;
                        record.status = record.isServiceComplete
                            ? 'Service Complete'
                            : 'Service Started';
                      });
                    },
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _InspectionTotalCard(record: record),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                    record.isServiceComplete ? AppColors.green : AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _showScreenSnack(
                  context,
                  record.isServiceComplete
                      ? 'Service completed'
                      : 'Service progress saved',
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const PreInspectionJobsScreen(),
                  ),
                );
              },
              child: Text(
                record.isServiceComplete ? 'FINISH SERVICE' : 'SAVE PROGRESS',
                style: const TextStyle(
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
}

class _ServiceProgressRow extends StatelessWidget {
  const _ServiceProgressRow({
    required this.label,
    required this.result,
    required this.done,
    required this.onChanged,
  });

  final String label;
  final InspectionResult result;
  final bool done;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: done ? AppColors.greenSoft : AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: done ? const Color(0xFFD6EED0) : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: done,
            activeColor: AppColors.green,
            onChanged: (value) => onChanged(value ?? false),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${result.action} | ${_formatInspectionCost(result.cost)}',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          StatusChip(label: done ? 'Done' : 'Pending'),
        ],
      ),
    );
  }
}

class _InspectionDetailRow extends StatelessWidget {
  const _InspectionDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.greenSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
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

class _InspectionTotalCard extends StatelessWidget {
  const _InspectionTotalCard({required this.record});

  final ServiceInspectionRecord record;

  @override
  Widget build(BuildContext context) {
    final grandTotal = record.grandTotalEstimate;
    final totalIssues = record.failedCount;
    final order = DemoData.orderByJob(record.job);
    final partsCount = order?.parts.length ?? 0;

    return AppCard(
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Final Estimate Summary',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  partsCount > 0
                      ? '$totalIssues issue${totalIssues == 1 ? '' : 's'} • $partsCount part${partsCount == 1 ? '' : 's'}'
                      : '$totalIssues issue${totalIssues == 1 ? '' : 's'} found',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatInspectionCost(grandTotal),
            style: const TextStyle(
              color: AppColors.green,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatInspectionCost(int amount) {
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
