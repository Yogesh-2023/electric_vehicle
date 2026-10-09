import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

part 'theme/app_colors.dart';
part 'utils/responsive.dart';
part 'utils/draft_service.dart';
part 'models/app_models.dart';
part 'data/demo_data.dart';
part 'screens/splash_screen.dart';
part 'screens/onboarding_screen.dart';
part 'screens/login_screen.dart';
part 'screens/app_shell.dart';
part 'screens/dashboard_screen.dart';
part 'screens/inspections_screen.dart';
part 'screens/create_job_screen.dart';
part 'screens/jobs_screen.dart';
part 'screens/inventory_screen.dart';
part 'screens/accessories_parts_screen.dart';
part 'screens/profile_screen.dart';
part 'screens/forgot_password_screen.dart';
part 'screens/legal_screens.dart';
part 'widgets/app_scaffold.dart';
part 'widgets/dashboard_widgets.dart';
part 'widgets/form_widgets.dart';
part 'widgets/content_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DraftService.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const EVServiceApp());
}

class EVServiceApp extends StatelessWidget {
  const EVServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EV Service',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Sora',
        scaffoldBackgroundColor: AppColors.surface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.green,
          surface: AppColors.surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.text,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
