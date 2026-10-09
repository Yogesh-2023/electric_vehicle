part of '../main.dart';

class OpenJobsScreen extends StatefulWidget {
  const OpenJobsScreen({super.key});

  @override
  State<OpenJobsScreen> createState() => _OpenJobsScreenState();
}

class _OpenJobsScreenState extends State<OpenJobsScreen> {
  @override
  Widget build(BuildContext context) {
    final jobs = DemoData.openJobs;
    final isMobile = Responsive.isCompact(context);

    return AppScaffold(
      title: 'Open Jobs',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBadge(label: 'OPEN JOBS', icon: Icons.work_outline_rounded),
          const SizedBox(height: 14),
          const Text(
            'View open jobs',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 18),
          if (jobs.isEmpty)
            AppCard(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.work_off_outlined, size: 48, color: AppColors.muted),
                    const SizedBox(height: 12),
                    const Text(
                      'No Open Jobs',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.text),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Create a new job sheet to get started.',
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CreateJobScreen()),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Create Job'),
                    ),
                  ],
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: jobs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 2 : Responsive.dashboardColumns(context),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 310,
              ),
              itemBuilder: (context, index) {
                final job = jobs[index];
                return JobSummaryCard(
                  job: job,
                  onTap: () async {
                    if (job.isDraft || job.status == 'Draft') {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CreateJobScreen(existingDraft: job),
                        ),
                      );
                    } else {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => JobDetailsScreen(job: job),
                        ),
                      );
                    }
                    if (mounted) setState(() {});
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key, required this.job});

  final CreatedJob job;

  @override
  Widget build(BuildContext context) {
    final savedInspection = DemoData.inspectionForJob(job);

    return AppScaffold(
      title: 'Job Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBadge(label: job.status.toUpperCase(), icon: Icons.work_outline),
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
                _JobDetailRow(
                  icon: Icons.person_outline,
                  label: 'Customer Name',
                  value: job.customerName,
                ),
                _JobDetailRow(
                  icon: Icons.call_outlined,
                  label: 'Mobile Number',
                  value: job.mobileNumber,
                ),
                _JobDetailRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: job.email.isEmpty ? 'Not provided' : job.email,
                ),
                _JobDetailRow(
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
                _JobDetailRow(
                  icon: Icons.confirmation_number_outlined,
                  label: 'Vehicle Number',
                  value: job.vehicleNumber,
                ),
                _JobDetailRow(
                  icon: Icons.business_outlined,
                  label: 'Vehicle Brand',
                  value: job.vehicleBrand,
                ),
                _JobDetailRow(
                  icon: Icons.two_wheeler_outlined,
                  label: 'Vehicle Model',
                  value: job.vehicleModel,
                ),
                _JobDetailRow(
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
                _JobDetailRow(
                  icon: Icons.settings_outlined,
                  label: 'Motor Number',
                  value: job.motorNumber.isEmpty ? 'Not provided' : job.motorNumber,
                ),
                _JobDetailRow(
                  icon: Icons.battery_charging_full_outlined,
                  label: 'Battery Number',
                  value: job.batteryNumber.isEmpty
                      ? 'Not provided'
                      : job.batteryNumber,
                ),
                _JobDetailRow(
                  icon: Icons.speed_outlined,
                  label: 'KM Reading',
                  value: job.odometerReading.isEmpty
                      ? 'Not provided'
                      : '${job.odometerReading} KM',
                ),
                _JobDetailRow(
                  icon: Icons.calendar_month_outlined,
                  label: 'Registration Date',
                  value: job.registrationDate.isEmpty
                      ? 'Not provided'
                      : job.registrationDate,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (savedInspection == null)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ServiceInspectionChecklistScreen(job: job),
                    ),
                  );
                },
                child: const Text(
                  'START SERVICE / INSPECTION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            )
          else
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FinalEstimateScreen(record: savedInspection),
                        ),
                      );
                    },
                    icon: const Icon(Icons.receipt_long_outlined, size: 20),
                    label: const Text(
                      'VIEW SAVED ESTIMATE',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ServiceInspectionChecklistScreen(job: job),
                            ),
                          );
                        },
                        icon: const Icon(Icons.fact_check_outlined, size: 18),
                        label: const Text('Re-Inspect'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AccessoriesPartsScreen(job: job),
                            ),
                          );
                        },
                        icon: const Icon(Icons.electrical_services_rounded, size: 18),
                        label: const Text('Edit Parts'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _JobDetailRow extends StatelessWidget {
  const _JobDetailRow({
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

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key, this.initialTabIndex = 0});

  final int initialTabIndex;

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<int> _selectedPartIndexes = {};
  bool _includeFittingFee = true;
  static const int _fittingFee = 200;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get _partsSubtotal {
    return _selectedPartIndexes.fold<int>(
      0,
      (sum, idx) => sum + DemoData.accessoryParts[idx].priceAmount,
    );
  }

  int get _grandTotalEstimate =>
      _partsSubtotal +
      (_selectedPartIndexes.isNotEmpty && _includeFittingFee ? _fittingFee : 0);

  void _togglePart(int index) {
    setState(() {
      if (_selectedPartIndexes.contains(index)) {
        _selectedPartIndexes.remove(index);
      } else {
        _selectedPartIndexes.add(index);
      }
    });
  }

  void _showFinalEstimateModal() {
    final selectedParts = _selectedPartIndexes
        .map((idx) => DemoData.accessoryParts[idx])
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).padding.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.greenSoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.green,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FINAL PARTS ESTIMATION',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Instant estimate summary for walk-in customer',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 14),
              const Text(
                'Selected Items:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: selectedParts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final part = selectedParts[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Icon(part.icon, color: AppColors.green, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              part.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          Text(
                            part.price,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              if (_includeFittingFee)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Labor / Service Fitting Charge',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        _formatInspectionCost(_fittingFee),
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ESTIMATED TOTAL COST',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Includes taxes & charges',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _formatInspectionCost(_grandTotalEstimate),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _savePartsAsJob();
                      },
                      icon: const Icon(Icons.add_task_rounded, size: 18),
                      label: const Text(
                        'Save as Job',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _savePartsAsJob() {
    final selectedParts = _selectedPartIndexes
        .map((idx) => DemoData.accessoryParts[idx])
        .toList();

    final jobId = 'EV-INSP-${DemoData.openJobs.length + 2047}';
    final job = CreatedJob(
      id: jobId,
      customerName: 'Walk-in Customer',
      mobileNumber: 'Not provided',
      email: '',
      address: 'EV Care Service Centre',
      vehicleNumber: 'DL EV TEMP',
      vehicleBrand: 'EV Scooter',
      vehicleModel: 'Generic EV',
      vehicleType: 'Electric Scooter',
      motorNumber: '',
      batteryNumber: '',
      odometerReading: '0',
      registrationDate: '',
      status: 'Estimate Saved',
      scheduleTime: 'Today',
      location: 'EV Care Service Centre',
    );

    DemoData.createdJobs.insert(0, job);

    final order = ServiceOrder(
      id: 'SRV-${DemoData.serviceOrders.length + 1001}',
      job: job,
      area: 'Parts Estimation',
      parts: selectedParts,
      totalAmount: _grandTotalEstimate,
      status: 'Saved',
    );
    DemoData.serviceOrders.insert(0, order);

    DemoData.saveInspection(
      job: job,
      results: {},
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Job Sheet $jobId created with estimate!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.green,
      ),
    );

    setState(() {
      _selectedPartIndexes.clear();
      _tabController.animateTo(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Check Estimation',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBadge(
            label: 'ESTIMATION & PARTS',
            icon: Icons.receipt_long_rounded,
          ),
          const SizedBox(height: 14),
          const Text(
            'Check Estimation',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Calculate instant estimate for parts & accessories or view saved job estimates.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.all(3),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.primary,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.muted,
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              tabs: const [
                Tab(text: 'Parts Estimator'),
                Tab(text: 'Saved Estimates'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPartsEstimatorTab(context),
                _buildSavedEstimatesTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartsEstimatorTab(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: DemoData.accessoryParts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final part = DemoData.accessoryParts[index];
              final isSelected = _selectedPartIndexes.contains(index);

              return InkWell(
                onTap: () => _togglePart(index),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.greenSoft : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.green : AppColors.border,
                      width: isSelected ? 1.8 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.green.withAlpha(40)
                              : AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          part.icon,
                          color: isSelected ? AppColors.green : AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              part.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: isSelected ? AppColors.green : AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${part.category} | ${part.stock}',
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            part.price,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.green : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isSelected ? 'SELECTED' : '+ ADD',
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.text,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 12,
                offset: Offset(0, -3),
              ),
            ],
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '${_selectedPartIndexes.length} parts selected',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: AppColors.muted,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _includeFittingFee = !_includeFittingFee;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          _includeFittingFee
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded,
                          color: AppColors.green,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Fitting Fee (+₹200)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL ESTIMATE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.muted,
                          ),
                        ),
                        Text(
                          _formatInspectionCost(_grandTotalEstimate),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 46,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _selectedPartIndexes.isEmpty
                          ? null
                          : _showFinalEstimateModal,
                      icon: const Icon(Icons.receipt_long_rounded, size: 18),
                      label: const Text(
                        'FINAL ESTIMATE',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSavedEstimatesTab(BuildContext context) {
    final records = DemoData.serviceInspectionRecords;

    if (records.isEmpty) {
      return AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No Saved Estimations Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Go to "View Open Job", perform pre-service inspection (Pass/Fail) and select parts & accessories to save an estimation.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 220,
              height: 44,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OpenJobsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.work_outline_rounded, size: 18),
                label: const Text(
                  'View Open Jobs',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (Responsive.isCompact(context)) {
      return ListView.separated(
        shrinkWrap: true,
        itemCount: records.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final record = records[index];
          return _CheckEstimationCard(
            record: record,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FinalEstimateScreen(record: record),
                ),
              );
              if (mounted) setState(() {});
            },
            onEditParts: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AccessoriesPartsScreen(job: record.job),
                ),
              );
              if (mounted) setState(() {});
            },
          );
        },
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      itemCount: records.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.dashboardColumns(context),
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        mainAxisExtent: 310,
      ),
      itemBuilder: (context, index) {
        final record = records[index];
        return _CheckEstimationCard(
          record: record,
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FinalEstimateScreen(record: record),
              ),
            );
            if (mounted) setState(() {});
          },
          onEditParts: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AccessoriesPartsScreen(job: record.job),
              ),
            );
            if (mounted) setState(() {});
          },
        );
      },
    );
  }
}

class _CheckEstimationCard extends StatelessWidget {
  const _CheckEstimationCard({
    required this.record,
    required this.onTap,
    required this.onEditParts,
  });

  final ServiceInspectionRecord record;
  final VoidCallback onTap;
  final VoidCallback onEditParts;

  @override
  Widget build(BuildContext context) {
    final order = DemoData.orderByJob(record.job);
    final partsCount = order?.parts.length ?? 0;
    final failedCount = record.failedCount;
    final grandTotal = record.grandTotalEstimate;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  record.job.vehicleModel,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.greenSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.green.withAlpha(76)),
                ),
                child: Text(
                  record.status,
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${record.job.id} | ${record.job.customerName}',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _EstimateBadgeTile(
                  icon: Icons.build_circle_outlined,
                  color: AppColors.primary,
                  bg: AppColors.primarySoft,
                  label: 'Repairs ($failedCount)',
                  value: _formatInspectionCost(record.totalEstimate),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _EstimateBadgeTile(
                  icon: Icons.electrical_services_rounded,
                  color: AppColors.green,
                  bg: AppColors.greenSoft,
                  label: 'Parts ($partsCount)',
                  value: _formatInspectionCost(record.partsEstimate),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL ESTIMATE',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  _formatInspectionCost(grandTotal),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onEditParts,
                  child: const Text(
                    'Add/Edit Parts',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onTap,
                  child: const Text(
                    'View Details',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EstimateBadgeTile extends StatelessWidget {
  const _EstimateBadgeTile({
    required this.icon,
    required this.color,
    required this.bg,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final Color bg;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
