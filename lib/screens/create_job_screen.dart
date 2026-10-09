part of '../main.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key, this.existingDraft});

  final CreatedJob? existingDraft;

  static const _sections = [
    FormSectionData(
      'Customer Details',
      Icons.person_outline,
      fields: ['Customer Name', 'Mobile Number', 'Email (Optional)', 'Address'],
    ),
    FormSectionData(
      'Vehicle Details',
      Icons.two_wheeler,
      fields: [
        'Vehicle Number',
        'Vehicle Brand',
        'Vehicle Model',
        'Vehicle Type',
      ],
    ),
    FormSectionData(
      'Other',
      Icons.tune_outlined,
      fields: [
        'Motor Number',
        'Battery Number',
        'Odometer Reading (KM)',
        'Registration Date',
        'Others (Optional Notes)',
      ],
    ),
  ];

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<GlobalKey<FormState>> _formKeys = List.generate(
    CreateJobScreen._sections.length,
    (_) => GlobalKey<FormState>(),
  );
  late TabController _tabController;
  int _maxUnlockedIndex = 0;
  late String _draftId;
  bool _startedService = false;

  @override
  void initState() {
    super.initState();
    JobTextField.clearValues();
    if (widget.existingDraft != null) {
      final d = widget.existingDraft!;
      _draftId = d.id;
      JobTextField.values['Customer Name'] = d.customerName;
      JobTextField.values['Mobile Number'] = d.mobileNumber;
      JobTextField.values['Email (Optional)'] = d.email;
      JobTextField.values['Address'] = d.address;
      JobTextField.values['Vehicle Number'] = d.vehicleNumber;
      JobTextField.values['Vehicle Brand'] = d.vehicleBrand;
      JobTextField.values['Vehicle Model'] = d.vehicleModel;
      JobTextField.values['Vehicle Type'] = d.vehicleType;
      JobTextField.values['Motor Number'] = d.motorNumber;
      JobTextField.values['Battery Number'] = d.batteryNumber;
      JobTextField.values['Odometer Reading (KM)'] = d.odometerReading;
      JobTextField.values['Registration Date'] = d.registrationDate;
      JobTextField.values['Others (Optional Notes)'] = d.othersNotes;
      _maxUnlockedIndex = CreateJobScreen._sections.length - 1;
    } else {
      final count = DraftService.drafts.length + DemoData.createdJobs.length + 2047;
      _draftId = 'EV-DRAFT-$count';
    }

    _tabController = TabController(length: CreateJobScreen._sections.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _autoSaveDraftIfNotEmpty() {
    if (_startedService) return;
    final values = JobTextField.values;
    final hasData = values.values.any((val) => val.trim().isNotEmpty);
    if (hasData) {
      final draft = CreatedJob(
        id: _draftId,
        customerName: values['Customer Name']?.trim() ?? '',
        mobileNumber: values['Mobile Number']?.trim() ?? '',
        email: values['Email (Optional)']?.trim() ?? '',
        address: values['Address']?.trim() ?? '',
        vehicleNumber: values['Vehicle Number']?.trim().toUpperCase() ?? '',
        vehicleBrand: values['Vehicle Brand'] ?? 'EV Brand',
        vehicleModel: values['Vehicle Model'] ?? 'EV Scooter',
        vehicleType: values['Vehicle Type'] ?? 'Electric Scooter',
        motorNumber: values['Motor Number']?.trim() ?? '',
        batteryNumber: values['Battery Number']?.trim() ?? '',
        odometerReading: values['Odometer Reading (KM)']?.trim() ?? '',
        registrationDate: values['Registration Date']?.trim() ?? '',
        othersNotes: values['Others (Optional Notes)']?.trim() ?? '',
        status: 'Draft',
        scheduleTime: 'Today, 11:30 AM',
        location: 'EV Care Service Centre',
        isDraft: true,
      );
      DraftService.saveDraft(draft);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        _autoSaveDraftIfNotEmpty();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF1F7FB),
        drawer: EVSideDrawer(onItem: _handleDrawerItem),
        appBar: MotoHeader(
          title: widget.existingDraft != null ? 'Edit Inspection' : 'Create Job',
          idValue: _draftId,
          rightIcon: Icons.save_outlined,
          onRight: _saveDraftAndGoHome,
          onMenu: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.maxContentWidth(context),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: Responsive.pagePadding(context),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            color: AppColors.primary,
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: AppColors.muted,
                          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          tabs: CreateJobScreen._sections.map((section) => Tab(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(section.title),
                            ),
                          )).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: CreateJobScreen._sections.asMap().entries.map((entry) {
                          final index = entry.key;
                          final section = entry.value;
                          final isLocked = index > _maxUnlockedIndex;

                          Widget content = JobFormSection(section: section);

                          if (isLocked) {
                            content = GestureDetector(
                              onTap: () => _showTopSnackBar(context, 'Please complete previous details first.', isError: true),
                              child: AbsorbPointer(
                                child: Opacity(
                                  opacity: 0.5,
                                  child: content,
                                ),
                              ),
                            );
                          }

                          return Form(
                            key: _formKeys[index],
                            child: ListView(
                              padding: Responsive.pagePadding(context).copyWith(bottom: 24),
                              children: [
                                content,
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: Responsive.pagePadding(context).copyWith(top: 8, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.maxContentWidth(context),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        onPressed: () => _saveDraftAndGoHome(),
                        child: const Text(
                          'Save Draft',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(44),
                          backgroundColor: AppColors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          JobTextField.currentError = null;
                          final currentIndex = _tabController.index;
                          
                          if (currentIndex > _maxUnlockedIndex) {
                            _showTopSnackBar(context, 'Please complete previous details first.', isError: true);
                            return;
                          }

                          if (_formKeys[currentIndex].currentState?.validate() ?? false) {
                            if (currentIndex == CreateJobScreen._sections.length - 1) {
                              _startServiceJob();
                              return;
                            }
                            if (currentIndex < CreateJobScreen._sections.length - 1) {
                              setState(() {
                                if (_maxUnlockedIndex < currentIndex + 1) {
                                  _maxUnlockedIndex = currentIndex + 1;
                                }
                              });
                              _tabController.animateTo(currentIndex + 1);
                            }
                          } else {
                            final errorMsg = JobTextField.currentError ?? 'Please fill required fields correctly.';
                            _showTopSnackBar(context, errorMsg, isError: true);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _tabController.index == CreateJobScreen._sections.length - 1
                                  ? 'Start Service'
                                  : 'Next',
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _tabController.index == CreateJobScreen._sections.length - 1
                                  ? Icons.check_circle_outline
                                  : Icons.arrow_forward,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTopSnackBar(BuildContext context, String message, {bool isError = false}) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: -100.0, end: 0.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isError ? Colors.red.shade600 : AppColors.green,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    isError ? Icons.error_outline : Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  void _saveDraftAndGoHome() {
    _startedService = true; // prevent auto-save duplicate
    final values = JobTextField.values;
    final draft = CreatedJob(
      id: _draftId,
      customerName: values['Customer Name']?.trim() ?? '',
      mobileNumber: values['Mobile Number']?.trim() ?? '',
      email: values['Email (Optional)']?.trim() ?? '',
      address: values['Address']?.trim() ?? '',
      vehicleNumber: values['Vehicle Number']?.trim().toUpperCase() ?? '',
      vehicleBrand: values['Vehicle Brand'] ?? 'EV Brand',
      vehicleModel: values['Vehicle Model'] ?? 'EV Scooter',
      vehicleType: values['Vehicle Type'] ?? 'Electric Scooter',
      motorNumber: values['Motor Number']?.trim() ?? '',
      batteryNumber: values['Battery Number']?.trim() ?? '',
      odometerReading: values['Odometer Reading (KM)']?.trim() ?? '',
      registrationDate: values['Registration Date']?.trim() ?? '',
      othersNotes: values['Others (Optional Notes)']?.trim() ?? '',
      status: 'Draft',
      scheduleTime: 'Today, 11:30 AM',
      location: 'EV Care Service Centre',
      isDraft: true,
    );

    DraftService.saveDraft(draft);
    _showTopSnackBar(context, 'Draft inspection saved');
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OpenJobsScreen()),
      );
    });
  }

  void _startServiceJob() {
    _startedService = true;
    final values = JobTextField.values;
    final existingCount = DemoData.createdJobs.length + DemoData.defaultOpenJobs.length + 1;
    final finalJobId = _draftId.startsWith('EV-DRAFT')
        ? 'EV-INSP-${2046 + existingCount}'
        : _draftId;

    final job = CreatedJob(
      id: finalJobId,
      customerName: values['Customer Name']?.trim().isNotEmpty == true
          ? values['Customer Name']!.trim()
          : 'Walk-in Customer',
      mobileNumber: values['Mobile Number']?.trim().isNotEmpty == true
          ? values['Mobile Number']!.trim()
          : '98765 43210',
      email: values['Email (Optional)'] ?? '',
      address: values['Address']?.trim().isNotEmpty == true
          ? values['Address']!.trim()
          : 'EV Care Service Centre',
      vehicleNumber: values['Vehicle Number']?.trim().isNotEmpty == true
          ? values['Vehicle Number']!.trim().toUpperCase()
          : 'DL 05 EV 0000',
      vehicleBrand: values['Vehicle Brand'] ?? 'EV Brand',
      vehicleModel: values['Vehicle Model'] ?? 'EV Scooter',
      vehicleType: values['Vehicle Type']?.trim().isNotEmpty == true
          ? values['Vehicle Type']!.trim()
          : 'Electric Scooter',
      motorNumber: values['Motor Number'] ?? '',
      batteryNumber: values['Battery Number']?.trim().isNotEmpty == true
          ? values['Battery Number']!
          : values['Others (Optional Notes)'] ?? '',
      odometerReading: values['Odometer Reading (KM)'] ?? '',
      registrationDate: values['Registration Date'] ?? '',
      othersNotes: values['Others (Optional Notes)'] ?? '',
      status: 'Pre-Service',
      scheduleTime: 'Today, 11:30 AM',
      location: 'EV Care Service Centre',
      isDraft: false,
    );

    // Remove draft from local storage once Start Service is successful
    DraftService.removeDraft(_draftId);

    // Insert active job into createdJobs
    DemoData.createdJobs.insert(0, job);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => JobCreatedSuccessScreen(job: job),
      ),
    );
  }

  void _handleDrawerItem(String key) {
    Navigator.pop(context);
    if (key == 'home' ||
        key == 'all' ||
        key == 'service_center' ||
        key == 'individual_user') {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (key == 'create_job') {
      return;
    } else if (key == 'accessories_parts') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AccessoriesPartsScreen()),
      );
    } else if (key == 'privacy') {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
    } else if (key == 'terms') {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const TermsOfServiceScreen()));
    } else if (key == 'logout') {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }
}

class JobCreatedSuccessScreen extends StatefulWidget {
  const JobCreatedSuccessScreen({super.key, required this.job});

  final CreatedJob job;

  @override
  State<JobCreatedSuccessScreen> createState() => _JobCreatedSuccessScreenState();
}

class _JobCreatedSuccessScreenState extends State<JobCreatedSuccessScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _handleDrawerItem(String key) {
    Navigator.pop(context);
    if (key == 'home' ||
        key == 'all' ||
        key == 'service_center' ||
        key == 'individual_user') {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (key == 'create_job') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CreateJobScreen()),
      );
    } else if (key == 'accessories_parts') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AccessoriesPartsScreen()),
      );
    } else if (key == 'logout') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF1F7FB),
      drawer: EVSideDrawer(onItem: _handleDrawerItem),
      appBar: MotoHeader(
        title: 'Job Created',
        idValue: widget.job.id,
        onMenu: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.isCompact(context)
                  ? double.infinity
                  : 460,
            ),
            child: ListView(
              padding: Responsive.pagePadding(context).copyWith(
                top: 22,
                bottom: 28,
              ),
              children: [
                AppCard(
                  padding: const EdgeInsets.fromLTRB(18, 26, 18, 22),
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Job Created\nSuccessfully',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Job ID',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.job.id,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.text,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'What would you like to do next?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _SuccessActionButton(
                        label: 'START SERVICE',
                        color: AppColors.green,
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => ServiceInspectionChecklistScreen(job: widget.job),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _SuccessActionButton(
                        label: 'VIEW OPEN JOBS',
                        color: AppColors.primary,
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const OpenJobsScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _SuccessActionButton(
                        label: 'GO TO DASHBOARD',
                        color: AppColors.muted,
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
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

class _SuccessActionButton extends StatelessWidget {
  const _SuccessActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

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
          textAlign: TextAlign.center,
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
