import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../navigation/app_routes.dart';
import '../services/gemini_service.dart';
import '../utils/image_validator.dart';

class AIAnalysisProgress extends StatefulWidget {
  const AIAnalysisProgress({super.key});

  @override
  State<AIAnalysisProgress> createState() => _AIAnalysisProgressState();
}

class _AIAnalysisProgressState extends State<AIAnalysisProgress> {
  double _progress = 0.0;
  String _statusText = 'Initializing AI engine...';
  String? _imagePath;
  final GeminiService _geminiService = GeminiService();
  bool _isAnalysisComplete = false;
  Map<String, dynamic>? _analysisResult;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_imagePath == null) {
      _imagePath = ModalRoute.of(context)?.settings.arguments as String?;
      _runAnalysis();
    }
  }

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _runAnalysis() async {
    if (_imagePath == null) return;

    // 1. Local Image Validation
    final validationError = await ImageValidator.validateImage(_imagePath!);
    if (validationError != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validationError)),
        );
        Navigator.pop(context);
      }
      return;
    }

    // 2. AI Analysis
    final result = await _geminiService.analyzeSkin(_imagePath!);
    
    if (mounted) {
      if (result.containsKey('error')) {
        _showError(result['error']);
      } else {
        setState(() {
          _analysisResult = result;
          _isAnalysisComplete = true;
          if (_progress >= 1.0) {
            _navigateToResults();
          }
        });
      }
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Analysis Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            },
            child: const Text('Go Home'),
          ),
        ],
      ),
    );
  }

  void _startAnimation() {
    const totalSteps = 100;
    const stepDuration = Duration(milliseconds: 50);

    Timer.periodic(stepDuration, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_progress < 0.95) {
          _progress += 1 / totalSteps;
        }
        
        if (_progress >= 0.3) _statusText = 'Scanning skin patterns...';
        if (_progress >= 0.6) _statusText = 'Evaluating melanin distribution...';
        if (_progress >= 0.9) _statusText = 'Generating report...';

        if (_progress >= 1.0 || (_isAnalysisComplete && _progress >= 0.95)) {
          _progress = 1.0;
          timer.cancel();
          if (_isAnalysisComplete) {
            _navigateToResults();
          }
        }
      });
    });
  }

  void _navigateToResults() {
    if (_analysisResult == null) return;
    
    Navigator.pushReplacementNamed(
      context, 
      AppRoutes.results,
      arguments: {
        'imagePath': _imagePath,
        'data': _analysisResult,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.medicalGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildModernLoader(),
              const SizedBox(height: 60),
              const Text(
                'Analyzing Your Skin',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Our AI is examining your skin condition. Please wait a few seconds while we generate your report.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 48),
              _buildProgressBar(),
              const SizedBox(height: 24),
              Text(
                '${(_progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user_outlined, size: 16, color: AppTheme.primaryBlue),
                    SizedBox(width: 8),
                    Text(
                      'CLINICAL GRADE PRECISION',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                        letterSpacing: 1.1,
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

  Widget _buildModernLoader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: CircularProgressIndicator(
            value: _progress,
            strokeWidth: 8,
            backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
            strokeCap: StrokeCap.round,
          ),
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.face_retouching_natural, size: 50, color: AppTheme.primaryBlue),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _statusText,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textDark),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 8,
            backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
          ),
        ),
      ],
    );
  }
}
