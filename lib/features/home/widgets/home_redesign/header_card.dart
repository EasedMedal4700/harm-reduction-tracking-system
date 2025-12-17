import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

/// Modular Header Card component
/// Professional medical dashboard style
class HeaderCard extends StatelessWidget {
  final String userName;
  final String greeting;
  final VoidCallback onProfileTap;
  final String? profileImageUrl;

  const HeaderCard({
    required this.userName,
    required this.greeting,
    required this.onProfileTap,
    this.profileImageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final acc = context.accent;
    // sp unused
    // sh unused

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: TextStyle(
                fontSize: 14,
                color: c.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: c.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onProfileTap,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: acc.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: acc.primary.withValues(alpha: 0.1),
              backgroundImage: profileImageUrl != null 
                  ? NetworkImage(profileImageUrl!)
                  : null,
              child: profileImageUrl == null
                  ? Icon(Icons.person, color: acc.primary)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
