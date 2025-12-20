import 'package:flutter/material.dart';
import '../../common/layout/common_spacer.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final a = context.accent;
    final sp = context.spacing;
    final t = context.text;

    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(sp.lg),
        child: Column(
          crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
          children: [
            Text(
              "SubstanceCheck Privacy Policy",
              style: t.heading3.copyWith(fontWeight: text.bodyBold.fontWeight),
            ),
            CommonSpacer.vertical(sp.xs),
            Text(
              "Last updated: 28 November 2025",
              style: t.body.copyWith(color: a.primary),
            ),
            CommonSpacer.vertical(sp.lg),
            _section(
              context,
              title: "1. Data We Collect",
              body: '''
We only collect the data required for the app to function.
''',
            ),
            _subsection(
              context,
              title: "1.1 Account Information",
              bulletPoints: [
                "Email address",
                "UUID (anonymous internal identifier)",
              ],
              note:
                  "These are provided when you create an account using Supabase Authentication.",
            ),
            _subsection(
              context,
              title: "1.2 User-Entered Data (Sensitive)",
              description:
                  "You may choose to enter any of the following sensitive data:",
              bulletPoints: [
                "Substance use history (drug name, dose, time, effects)",
                "Cravings and triggers",
                "Reflections and coping strategies",
                "Daily check-ins (mood, emotions, notes)",
                "Notes, metadata, and optional personal reflections",
              ],
            ),
            _subsection(
              context,
              title: "1.3 App Diagnostics & Error Logs",
              description: "To improve app stability, we collect:",
              bulletPoints: [
                "App version",
                "Device type & OS",
                "Screen/page where error occurred",
                "Error message & stack trace",
                "Additional debugging data",
              ],
              note:
                  "These logs may be linked to your account UUID to help diagnose issues affecting your device.",
            ),
            _divider(context),
            _section(
              context,
              title: "We Do NOT Collect",
              bulletPoints: [
                "IP addresses",
                "Location data (unless you manually enter it)",
                "Advertising IDs",
                "Background tracking",
              ],
            ),
            _divider(context),
            _section(
              context,
              title: "2. How Your Data Is Used",
              bulletPoints: [
                "Providing core app functionality (blood levels, tolerance models, charts)",
                "Saving your history and progress",
                "Improving stability through error logs",
                "Syncing data across devices via your account",
              ],
              note:
                  "We never sell your data, share it with advertisers, or use it for profiling.",
            ),
            _divider(context),
            _section(
              context,
              title: "3. Legal Basis Under GDPR",
              body: '''
Your data is processed under:

✔ Consent (GDPR Art. 6(1)(a) + Art. 9(2)(a))  
✔ Legitimate Interest (GDPR Art. 6(1)(f))  

You can withdraw consent at any time by deleting your account.
''',
            ),
            _divider(context),
            _section(
              context,
              title: "4. Who Can Access Your Data",
              body: '''
Only:

• You  
• The app administrator (for debugging)  

All data is protected through:

✓ Supabase Authentication  
✓ Row-Level Security (RLS)  
✓ Encrypted connections (TLS)  
✓ Isolated UUID-based keys  
''',
            ),
            _divider(context),
            _section(
              context,
              title: "5. Data Retention",
              body: '''
Your data is kept as long as your account remains active.

When you delete your account:

✔ All personal data  
✔ All sensitive entries  
✔ All logs  
are permanently deleted.
''',
            ),
            _divider(context),
            _section(
              context,
              title: "6. Your Rights Under GDPR",
              bulletPoints: [
                "Access your data",
                "Correct your data",
                "Download/export your data",
                "Delete your data (Right to be Forgotten)",
                "Withdraw consent",
                "Restrict processing",
                "Object to processing",
                "File a complaint with a Data Protection Authority",
              ],
            ),
            _divider(context),
            _section(
              context,
              title: "7. Children's Privacy",
              body:
                  "This app is not intended for individuals under 18. We do not knowingly collect data from minors.",
            ),
            _divider(context),
            _section(
              context,
              title: "8. Data Security",
              bulletPoints: [
                "Supabase Postgres with RLS",
                "Encrypted communication (HTTPS/TLS)",
                "UUID-based pseudonymization",
                "Restricted admin access",
                "Secure password hashing via Supabase Auth",
              ],
            ),
            _divider(context),
            _section(
              context,
              title: "9. International Data Transfers",
              body:
                  "Your data may be stored in the EU or GDPR-compliant regions. Supabase provides GDPR-compliant DPAs.",
            ),
            _divider(context),
            _section(
              context,
              title: "10. Changes to This Policy",
              body:
                  "We may update this policy occasionally. Major changes will be announced in the app.",
            ),
            _divider(context),
            _section(
              context,
              title: "11. Contact",
              body: '''
Email: fquaaden@gmail.com  
App Owner: Falco Quaaden  
Location: Netherlands / EU
''',
            ),
            CommonSpacer.vertical(sp.xl2),
          ],
        ),
      ),
    );
  }

  Widget _section(
    BuildContext context, {
    required String title,
    String? body,
    List<String>? bulletPoints,
    String? note,
  }) {
    final t = context.text;
    final text = context.text;
    final sp = context.spacing;
    final a = context.accent;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          title,
          style: t.heading4.copyWith(fontWeight: text.bodyBold.fontWeight),
        ),
        if (body != null) ...[
          CommonSpacer.vertical(sp.xs),
          Text(body, style: t.body),
        ],
        if (bulletPoints != null) ...[
          CommonSpacer.vertical(sp.sm),
          ...bulletPoints.map(
            (b) => Padding(
              padding: EdgeInsets.only(bottom: sp.xs),
              child: Text("• $b", style: t.body),
            ),
          ),
        ],
        if (note != null) ...[
          CommonSpacer.vertical(sp.sm),
          Text(note, style: t.caption.copyWith(color: a.primary)),
        ],
        CommonSpacer.vertical(sp.lg),
      ],
    );
  }

  Widget _subsection(
    BuildContext context, {
    required String title,
    String? description,
    List<String>? bulletPoints,
    String? note,
  }) {
    final sp = context.spacing;
    return Padding(
      padding: EdgeInsets.only(left: sp.sm),
      child: _section(
        context,
        title: title,
        body: description,
        bulletPoints: bulletPoints,
        note: note,
      ),
    );
  }

  Widget _divider(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    return Divider(
      height: sp.xl,
      thickness: context.borders.thin,
      color: c.border,
    );
  }
}
