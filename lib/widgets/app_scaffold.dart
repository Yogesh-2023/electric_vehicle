part of '../main.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _handleDrawerItem(String key) {
    Navigator.pop(context);
    if (key == 'home' ||
        key == 'all' ||
        key == 'service_center' ||
        key == 'individual_user') {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const DashboardScreen()));
    } else if (key == 'create_job') {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const CreateJobScreen()));
    } else if (key == 'accessories_parts') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AccessoriesPartsScreen()),
      );
    } else if (key == 'logout') {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      drawer: EVSideDrawer(onItem: _handleDrawerItem),
      appBar: MotoHeader(
        title: widget.title,
        onMenu: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.maxContentWidth(context),
                  ),
                  child: Padding(
                    padding: Responsive.pagePadding(
                      context,
                    ).copyWith(top: 12, bottom: 28),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MotoHeader extends StatelessWidget implements PreferredSizeWidget {
  const MotoHeader({
    super.key,
    required this.title,
    this.idValue,
    this.rightIcon,
    this.onRight,
    this.onMenu,
  });

  final String title;
  final String? idValue;
  final IconData? rightIcon;
  final VoidCallback? onRight;
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.maxContentWidth(context),
            ),
            child: Padding(
              padding: Responsive.pagePadding(context).copyWith(bottom: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (rightIcon != null)
                        GestureDetector(
                          onTap: onRight,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              rightIcon,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      IconButton(
                        onPressed: onMenu,
                        icon: const Icon(
                          Icons.menu,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (idValue != null)
                        Text(
                          idValue!,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(96);
}
