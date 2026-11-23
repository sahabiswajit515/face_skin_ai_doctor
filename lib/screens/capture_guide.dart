import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CaptureGuide extends StatelessWidget {
  const CaptureGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Guide'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'How to Capture a Good Face Photo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'For the most accurate AI skin analysis, please follow these simple steps.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 40),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.8,
                children: [
                  _buildStepCard(
                    icon: Icons.wb_sunny_outlined,
                    step: '1',
                    title: 'Natural Light',
                    desc: 'Avoid harsh shadows or dark rooms.',
                    color: Colors.orange.shade50,
                    iconColor: Colors.orange,
                  ),
                  _buildStepCard(
                    icon: Icons.center_focus_strong_outlined,
                    step: '2',
                    title: 'Capture Close-up',
                    desc: 'Keep camera 6-10 inches from face.',
                    color: Colors.blue.shade50,
                    iconColor: Colors.blue,
                  ),
                  _buildStepCard(
                    icon: Icons.auto_fix_off_outlined,
                    step: '3',
                    title: 'Avoid Filters',
                    desc: 'Ensure skin texture is natural.',
                    color: Colors.purple.shade50,
                    iconColor: Colors.purple,
                  ),
                  _buildStepCard(
                    icon: Icons.face_outlined,
                    step: '4',
                    title: 'Face Visible',
                    desc: 'Remove glasses or pull hair back.',
                    color: Colors.green.shade50,
                    iconColor: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _buildQuickTips(),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Got It', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required IconData icon,
    required String step,
    required String title,
    required String desc,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.lightBlue),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: AppTheme.primaryBlue,
                child: Text(
                  step,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppTheme.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTips() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates_outlined, color: AppTheme.primaryBlue),
              SizedBox(width: 8),
              Text(
                'Quick Tips',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 16),
          _TipItem(text: 'Hold your phone steady for clarity'),
          SizedBox(height: 8),
          _TipItem(text: 'Clean your camera lens before shooting'),
          SizedBox(height: 8),
          _TipItem(text: 'Maintain a neutral facial expression'),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;
  const _TipItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline, size: 20, color: AppTheme.primaryBlue),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
