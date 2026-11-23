import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/home_dashboard.dart';
import '../screens/capture_guide.dart';
import '../screens/image_preview_screen.dart';
import '../screens/ai_analysis_progress.dart';
import '../screens/skin_analysis_results.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String guide = '/guide';
  static const String preview = '/preview';
  static const String progress = '/progress';
  static const String results = '/results';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeDashboard(),
    guide: (context) => const CaptureGuide(),
    preview: (context) => const ImagePreviewScreen(),
    progress: (context) => const AIAnalysisProgress(),
    results: (context) => const SkinAnalysisResults(),
  };
}
