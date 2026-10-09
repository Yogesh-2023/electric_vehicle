part of '../main.dart';

class EVHomeHeader extends StatelessWidget implements PreferredSizeWidget {
  const EVHomeHeader({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: Responsive.maxContentWidth(context),
          ),
          padding: Responsive.pagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/new-ev-care-logo.png',
                    width: 118,
                    height: 52,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => scaffoldKey.currentState?.openDrawer(),
                    icon: const Icon(
                      Icons.menu,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Row(
                children: [
                  Icon(Icons.dashboard_outlined, size: 22, color: Colors.black),
                  SizedBox(width: 6),
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Technician',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(115);
}

class HomeTabChip extends StatelessWidget {
  const HomeTabChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.green : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? AppColors.green : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class CreateJobCard extends StatelessWidget {
  const CreateJobCard({
    super.key,
    required this.onTap,
    this.title = 'Create Job',
    this.subtitle = 'Start EV pre-inspection',
    this.icon = Icons.add,
  });

  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.green, width: 1.4),
            boxShadow: const [
              BoxShadow(
                color: Color(0x10000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: AppColors.greenSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.green, size: 32),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MotoInspectionCard extends StatelessWidget {
  const MotoInspectionCard({
    super.key,
    required this.ticket,
    required this.onTap,
  });

  final InspectionTicket ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.vehicle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _CardInfoRow(
                        icon: Icons.confirmation_number_outlined,
                        text: 'Inspection ID: ${ticket.id}',
                      ),
                      const SizedBox(height: 6),
                      const _CardInfoRow(
                        icon: Icons.schedule_outlined,
                        text: 'Today, 11:30 AM',
                        iconColor: Colors.blue,
                      ),
                      const SizedBox(height: 6),
                      _CardInfoRow(
                        icon: Icons.person_outline,
                        text: ticket.customer,
                        iconColor: AppColors.primary,
                      ),
                      const SizedBox(height: 6),
                      const _CardInfoRow(
                        icon: Icons.call,
                        text: '98765 43210',
                        iconColor: AppColors.green,
                      ),
                      const SizedBox(height: 6),
                      const _CardInfoRow(
                        icon: Icons.location_on_outlined,
                        text: 'EV Care Service Centre',
                        iconColor: AppColors.green,
                        maxLines: 3,
                      ),
                      const Spacer(),
                      StatusChip(label: ticket.status),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: const BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: Colors.white,
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
}

class JobSummaryCard extends StatelessWidget {
  const JobSummaryCard({
    super.key,
    required this.job,
    required this.onTap,
  });

  final CreatedJob job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final vehicleTitle = job.vehicleModel.trim().isNotEmpty
        ? job.vehicleModel
        : (job.vehicleBrand.trim().isNotEmpty ? job.vehicleBrand : 'EV Scooter');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0E000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicleTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _CardInfoRow(
                        icon: Icons.confirmation_number_outlined,
                        text: 'Inspection ID: ${job.id}',
                        iconColor: const Color(0xFF64748B),
                      ),
                      const SizedBox(height: 6),
                      _CardInfoRow(
                        icon: Icons.schedule_outlined,
                        text: job.scheduleTime.isNotEmpty ? job.scheduleTime : 'Today, 11:30 AM',
                        iconColor: const Color(0xFF0EA5E9),
                      ),
                      const SizedBox(height: 6),
                      _CardInfoRow(
                        icon: Icons.person_outline,
                        text: job.customerName.isNotEmpty ? job.customerName : 'Walk-in Customer',
                        iconColor: AppColors.primary,
                      ),
                      const SizedBox(height: 6),
                      _CardInfoRow(
                        icon: Icons.call,
                        text: job.mobileNumber.isNotEmpty ? job.mobileNumber : '98765 43210',
                        iconColor: AppColors.green,
                      ),
                      const SizedBox(height: 6),
                      _CardInfoRow(
                        icon: Icons.location_on_outlined,
                        text: job.location.isNotEmpty ? job.location : 'EV Care Service Centre',
                        iconColor: AppColors.green,
                        maxLines: 2,
                      ),
                      const Spacer(),
                      StatusChip(
                        label: job.isDraft && job.status == 'Draft'
                            ? 'Draft'
                            : job.status,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 16,
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
}

class OpenJobsTileCarousel extends StatefulWidget {
  const OpenJobsTileCarousel({super.key});

  @override
  State<OpenJobsTileCarousel> createState() => _OpenJobsTileCarouselState();
}

class _OpenJobsTileCarouselState extends State<OpenJobsTileCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobs = DemoData.openJobs;

    if (jobs.isEmpty) {
      return CreateJobCard(
        title: 'View Open Job',
        subtitle: 'See active job sheets',
        icon: Icons.work_outline_rounded,
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const OpenJobsScreen()),
          );
          if (mounted) setState(() {});
        },
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: jobs.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
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
          if (jobs.length > 1)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_currentPage + 1}/${jobs.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class InspectionEstimateCard extends StatelessWidget {
  const InspectionEstimateCard({
    super.key,
    required this.record,
    required this.onTap,
  });

  final ServiceInspectionRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final job = record.job;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.vehicleModel,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _CardInfoRow(
                        icon: Icons.confirmation_number_outlined,
                        text: 'Estimate ID: ${record.id}',
                      ),
                      const SizedBox(height: 6),
                      _CardInfoRow(
                        icon: Icons.person_outline,
                        text: job.customerName,
                        iconColor: AppColors.primary,
                      ),
                      const SizedBox(height: 6),
                      _CardInfoRow(
                        icon: Icons.two_wheeler_outlined,
                        text: job.vehicleNumber,
                        iconColor: AppColors.green,
                      ),
                      const SizedBox(height: 6),
                      _CardInfoRow(
                        icon: Icons.report_problem_outlined,
                        text:
                            '${record.failedCount} issue${record.failedCount == 1 ? '' : 's'} | ${_formatInspectionCost(record.totalEstimate)}',
                        iconColor: Colors.red,
                      ),
                      const Spacer(),
                      StatusChip(label: record.status),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: const BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: Colors.white,
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
}

class _CardInfoRow extends StatelessWidget {
  const _CardInfoRow({
    required this.icon,
    required this.text,
    this.iconColor,
    this.maxLines = 1,
  });

  final IconData icon;
  final String text;
  final Color? iconColor;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: iconColor ?? Colors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class EVSideDrawer extends StatelessWidget {
  const EVSideDrawer({super.key, required this.onItem});

  final void Function(String key) onItem;

  @override
  Widget build(BuildContext context) {
    final drawerWidth = MediaQuery.of(context).size.width * 0.74;

    return Drawer(
      width: drawerWidth,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => onItem('home'),
                child: SizedBox(
                  height: 154,
                  child: Transform.translate(
                    offset: const Offset(0, -18),
                    child: Center(
                      child: Image.asset(
                        'assets/images/new-ev-care-logo.png',
                        width: 305,
                        height: 172,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, -22),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DrawerNavTile(
                          icon: Icons.home_rounded,
                          label: 'Home',
                          onTap: () => onItem('home'),
                        ),
                        DrawerNavTile(
                          icon: Icons.add_task_rounded,
                          label: 'Create Job',
                          onTap: () => onItem('create_job'),
                        ),
                        DrawerNavTile(
                          icon: Icons.grid_view_rounded,
                          label: 'All',
                          onTap: () => onItem('all'),
                        ),
                        DrawerNavTile(
                          icon: Icons.business_rounded,
                          label: 'Service Center',
                          onTap: () => onItem('service_center'),
                        ),
                        DrawerNavTile(
                          icon: Icons.person_rounded,
                          label: 'Individual User',
                          onTap: () => onItem('individual_user'),
                        ),
                        DrawerNavTile(
                          icon: Icons.inventory_2_rounded,
                          label: 'Parts & Accessories',
                          onTap: () => onItem('accessories_parts'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EEF5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 20,
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Amit Verma',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.text,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Senior EV Technician',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  onPressed: () => onItem('logout'),
                  label: const Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerNavTile extends StatelessWidget {
  const DrawerNavTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF94A3B8),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
