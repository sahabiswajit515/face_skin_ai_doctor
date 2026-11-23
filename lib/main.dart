import 'package:flutter/material.dart';
import 'navigation/app_routes.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FaceSkinAIDoctor());
}

class FaceSkinAIDoctor extends StatelessWidget {
  const FaceSkinAIDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face & Skin AI Doctor',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
