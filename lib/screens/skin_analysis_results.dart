import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../navigation/app_routes.dart';
import 'dart:io';

class SkinAnalysisResults extends StatelessWidget {
  const SkinAnalysisResults({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? imagePath = args?['imagePath'];
    final Map<String, dynamic>? data = args?['data'];

    if (data == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No analysis results found.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    }

    final String skinType = data['skin_type'] ?? 'Unknown';
    final List<dynamic> issues = data['detected_issues'] ?? [];
    final List<dynamic> tips = data['beauty_tips'] ?? [];
    final List<dynamic> remedies = data['home_remedies'] ?? [];
    final List<dynamic> medications = data['medicine_suggestions'] ?? [];
    final String assessment = data['overall_assessment'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Skin Analysis Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppTheme.primaryBlue),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildResultHeader(imagePath),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSectionCard(
                    title: 'Skin Type',
                    icon: Icons.face_retouching_natural,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          skinType,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          assessment,
                          style: const TextStyle(fontSize: 14, color: AppTheme.textLight),
                        ),
                      ],
                    ),
                  ),
                  if (issues.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: 'Detected Issues',
                      icon: Icons.warning_amber_rounded,
                      iconColor: Colors.orange,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: issues.map((issue) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _IssueItem(text: issue.toString()),
                        )).toList(),
                      ),
                    ),
                  ],
                  if (tips.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: 'Skincare Suggestions',
                      icon: Icons.auto_awesome_outlined,
                      iconColor: Colors.purple,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tips.map((tip) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _SuggestionItem(text: tip.toString()),
                        )).toList(),
                      ),
                    ),
                  ],
                  if (remedies.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: 'Natural Remedies',
                      icon: Icons.eco_outlined,
                      iconColor: Colors.green,
                      content: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: remedies.map((remedy) => _RemedyItem(
                          icon: Icons.spa_outlined, 
                          label: remedy.toString(), 
                          sub: 'Natural',
                        )).toList(),
                      ),
                    ),
                  ],
                  if (medications.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: 'Generic Medication Suggestions',
                      icon: Icons.medication_outlined,
                      iconColor: Colors.redAccent,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: medications.map((med) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                med.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Text(
                                'Generic composition for discussion with your doctor.',
                                style: TextStyle(fontSize: 13, color: AppTheme.textLight),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  _buildDisclaimer(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Analyze Another Photo'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultHeader(String? imagePath) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.lightBlue,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryBlue, width: 3),
              boxShadow: [
                BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.2), blurRadius: 15),
              ],
            ),
            child: ClipOval(
              child: imagePath != null
                  ? Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.person_outline, size: 60, color: AppTheme.primaryBlue),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Analysis Complete',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Scanned just now',
            style: TextStyle(color: AppTheme.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    Color iconColor = AppTheme.primaryBlue,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 0.5),
          content,
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.orange, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Disclaimer: This analysis is generated by AI and may not always be accurate. Please consult a qualified doctor for serious skin conditions.',
              style: TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _IssueItem extends StatelessWidget {
  final String text;
  const _IssueItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.brightness_1, size: 8, color: Colors.orange),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}

class _SuggestionItem extends StatelessWidget {
  final String text;
  const _SuggestionItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check, size: 16, color: Colors.purple),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}

class _RemedyItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  const _RemedyItem({required this.icon, required this.label, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.green, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(sub, style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
      ],
    );
  }
}
