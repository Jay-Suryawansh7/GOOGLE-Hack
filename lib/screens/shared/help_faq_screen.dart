import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/navigation_extensions.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.safePop('/citizen-home'),
        ),
        title: const Text('Help & FAQ'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        children: [
          _buildFaqItem(
            'How do I report an issue?',
            'Tap the + button on the home feed, describe the issue, select severity, and submit.',
          ),
          _buildFaqItem(
            'How does the trust score work?',
            'Your trust score increases as you report and resolve issues accurately. Higher scores unlock more features.',
          ),
          _buildFaqItem(
            'Can I edit my report?',
            'No, but you can add updates or mark it as resolved if the issue is fixed.',
          ),
          _buildFaqItem(
            'How do I become a volunteer?',
            'Select Volunteer during onboarding and complete the KYC verification process.',
          ),
          _buildFaqItem(
            'Is my data safe?',
            'Yes, we use encryption and follow strict privacy guidelines to protect your information.',
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(answer),
        ),
      ],
    );
  }
}
