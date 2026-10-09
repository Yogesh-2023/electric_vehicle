part of '../main.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _handleDrawerItem(String key) {
    Navigator.pop(context);
    if (key == 'create_job') {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const CreateJobScreen()));
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
    } else if (key == 'accessories_parts') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AccessoriesPartsScreen()),
      );
    }
  }

  Widget _buildGrid() {
    final pagePadding = Responsive.pagePadding(context);
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
        pagePadding.left,
        12,
        pagePadding.right,
        20,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.dashboardColumns(context),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: Responsive.dashboardAspectRatio(
          context,
        ),
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        if (index == 0) {
          return CreateJobCard(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CreateJobScreen(),
                ),
              );
              if (mounted) {
                setState(() {});
              }
            },
          );
        }
        if (index == 1) {
          return CreateJobCard(
            title: 'View Open Job',
            subtitle: 'See active job sheets',
            icon: Icons.work_outline_rounded,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const OpenJobsScreen(),
                ),
              );
              if (mounted) {
                setState(() {});
              }
            },
          );
        }
        if (index == 2) {
          return CreateJobCard(
            title: 'Check Estimation',
            subtitle: 'Review service estimate',
            icon: Icons.receipt_long_outlined,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const JobsScreen(),
                ),
              );
            },
          );
        }
        if (index == 3) {
          return CreateJobCard(
            title: 'Inspection',
            subtitle: 'Open vehicle inspection',
            icon: Icons.fact_check_outlined,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const InspectionOptionsScreen(),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF1F7FB),
      drawer: EVSideDrawer(onItem: _handleDrawerItem),
      appBar: EVHomeHeader(
        scaffoldKey: _scaffoldKey,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.maxContentWidth(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildGrid(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
