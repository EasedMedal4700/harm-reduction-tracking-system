import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "SubstanceCheck Privacy Policy",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),
            Text(
              "Last updated: 28 November 2025",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 24),

            _section(
              theme,
              title: "1. Data We Collect",
              body: '''
We only collect the data required for the app to function.
''',
            ),

            _subsection(
              theme,
              title: "1.1 Account Information",
              bulletPoints: [
                "Email address",
                "UUID (anonymous internal identifier)",
              ],
              note:
                  "These are provided when you create an account using Supabase Authentication.",
            ),

            _subsection(
              theme,
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
              theme,
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

            _divider(),
            _section(
              theme,
              title: "We Do NOT Collect",
              bulletPoints: [
                "IP addresses",
                "Location data (unless you manually enter it)",
                "Advertising IDs",
                "Background tracking",
              ],
            ),

            _divider(),
            _section(
              theme,
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

            _divider(),
            _section(
              theme,
              title: "3. Legal Basis Under GDPR",
              body: '''
Your data is processed under:

✔ Consent (GDPR Art. 6(1)(a) + Art. 9(2)(a))  
✔ Legitimate Interest (GDPR Art. 6(1)(f))  

You can withdraw consent at any time by deleting your account.
''',
            ),

            _divider(),
            _section(
              theme,
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

            _divider(),
            _section(
              theme,
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

            _divider(),
            _section(
              theme,
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

            _divider(),
            _section(
              theme,
              title: "7. Children's Privacy",
              body:
                  "This app is not intended for individuals under 18. We do not knowingly collect data from minors.",
            ),

            _divider(),
            _section(
              theme,
              title: "8. Data Security",
              bulletPoints: [
                "Supabase Postgres with RLS",
                "Encrypted communication (HTTPS/TLS)",
                "UUID-based pseudonymization",
                "Restricted admin access",
                "Secure password hashing via Supabase Auth",
              ],
            ),

            _divider(),
            _section(
              theme,
              title: "9. International Data Transfers",
              body:
                  "Your data may be stored in the EU or GDPR-compliant regions. Supabase provides GDPR-compliant DPAs.",
            ),

            _divider(),
            _section(
              theme,
              title: "10. Changes to This Policy",
              body:
                  "We may update this policy occasionally. Major changes will be announced in the app.",
            ),

            _divider(),
            _section(
              theme,
              title: "11. Contact",
              body: '''
Email: fquaaden@gmail.com  
App Owner: Falco Quaaden  
Location: Netherlands / EU
''',
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _section(
    ThemeData theme, {
    required String title,
    String? body,
    List<String>? bulletPoints,
    String? note,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (body != null) ...[
          const SizedBox(height: 8),
          Text(body, style: theme.textTheme.bodyMedium),
        ],
        if (bulletPoints != null) ...[
          const SizedBox(height: 12),
          ...bulletPoints.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text("• $b", style: theme.textTheme.bodyMedium),
              )),
        ],
        if (note != null) ...[
          const SizedBox(height: 12),
          Text(
            note,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _subsection(
    ThemeData theme, {
    required String title,
    String? description,
    List<String>? bulletPoints,
    String? note,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: _section(
        theme,
        title: title,
        body: description,
        bulletPoints: bulletPoints,
        note: note,
      ),
    );
  }

  Widget _divider() => const Divider(height: 32, thickness: 1);
}
