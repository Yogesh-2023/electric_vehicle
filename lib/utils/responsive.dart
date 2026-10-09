part of '../main.dart';

class Responsive {
  const Responsive._();

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 600 && width < 1024;
  }

  static double maxContentWidth(BuildContext context) {
    if (isCompact(context)) {
      return double.infinity;
    }
    return isTablet(context) ? 720 : 960;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 380) {
      return const EdgeInsets.symmetric(horizontal: 12);
    }
    if (width < 600) {
      return const EdgeInsets.symmetric(horizontal: 16);
    }
    return const EdgeInsets.symmetric(horizontal: 24);
  }

  static int dashboardColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 360) {
      return 1;
    }
    if (width < 700) {
      return 2;
    }
    if (width < 1100) {
      return 3;
    }
    return 4;
  }

  static double dashboardAspectRatio(BuildContext context) {
    final columns = dashboardColumns(context);
    if (columns == 1) {
      return 1.25;
    }
    if (columns == 2) {
      return 0.58;
    }
    return 0.72;
  }
}
