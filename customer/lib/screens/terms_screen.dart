import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Terms & Privacy',
          style: AppFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF0068FF),
              indicatorWeight: 2.5,
              labelColor: const Color(0xFF0068FF),
              unselectedLabelColor: const Color(0xFF64748B),
              labelStyle: AppFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'Terms of Service'),
                Tab(text: 'Privacy Policy'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTermsTab(),
          _buildPrivacyTab(),
        ],
      ),
    );
  }

  // ── Terms of Service ─────────────────────────────────────────────────────

  Widget _buildTermsTab() {
    const sections = [
      _Section(
        title: '1. Acceptance of Terms',
        body:
            'By downloading, accessing, or using the swiftree application, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our services. These terms constitute a legally binding agreement between you and swiftree Technologies Ltd.',
      ),
      _Section(
        title: '2. Use of Service',
        body:
            'swiftree grants you a limited, non-exclusive, non-transferable licence to use our platform for personal, non-commercial purposes. You must be at least 18 years old to create an account. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
      ),
      _Section(
        title: '3. Orders and Delivery',
        body:
            'When you place an order through swiftree, you enter into a direct agreement with the vendor or service provider. swiftree acts as an intermediary platform connecting customers, vendors, and riders. Delivery time estimates may vary due to traffic, weather, or vendor preparation times. We strive to provide accurate estimates but cannot guarantee exact delivery windows.',
      ),
      _Section(
        title: '4. Payment',
        body:
            'All payments made through swiftree are processed securely via our certified payment partners. We accept MTN Mobile Money, Vodafone Cash, AirtelTigo Money, and cash on delivery where available. Prices displayed include applicable taxes and fees. By completing a purchase, you authorise swiftree to charge your selected payment method for the total order amount.',
      ),
      _Section(
        title: '5. Cancellation Policy',
        body:
            'Orders may be cancelled free of charge within 2 minutes of placement. After this window, cancellations are subject to a fee depending on order preparation status. Once an order has been picked up by a rider, cancellation may not be possible. Refunds for eligible cancellations are processed within 3–5 business days to the original payment method.',
      ),
      _Section(
        title: '6. Intellectual Property',
        body:
            'All content, branding, logos, trademarks, and software associated with swiftree are the intellectual property of swiftree Technologies Ltd. and its licensors. You may not reproduce, distribute, modify, or create derivative works without our prior written consent. User-generated content remains your property; however, you grant swiftree a worldwide, royalty-free licence to use it in connection with our services.',
      ),
      _Section(
        title: '7. Limitation of Liability',
        body:
            'To the maximum extent permitted by applicable law, swiftree shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of the platform. Our total liability for any claim shall not exceed the amount you paid for the specific transaction giving rise to the claim.',
      ),
      _Section(
        title: '8. Changes to Terms',
        body:
            'swiftree reserves the right to modify these Terms of Service at any time. We will notify you of significant changes via the app or email at least 14 days before they take effect. Your continued use of the platform after changes are published constitutes your acceptance of the updated terms. We encourage you to review these terms periodically.',
      ),
    ];

    return _buildScrollView(sections);
  }

  // ── Privacy Policy ───────────────────────────────────────────────────────

  Widget _buildPrivacyTab() {
    const sections = [
      _Section(
        title: '1. Information We Collect',
        body:
            'We collect information you provide directly, such as your name, phone number, email address, delivery addresses, and payment details. We also collect data automatically when you use our services, including order history, app usage patterns, device identifiers, and location data when you grant permission.',
      ),
      _Section(
        title: '2. How We Use Your Information',
        body:
            'Your information is used to process and fulfil orders, personalise your in-app experience, send order status updates and relevant promotional communications, improve our platform, detect and prevent fraud, and comply with legal obligations. Aggregated, anonymised data may be used for analytics and business insights.',
      ),
      _Section(
        title: '3. Information Sharing',
        body:
            'We share your information with vendors and riders only to the extent necessary to fulfil your orders, and with payment processors to complete transactions. We do not sell your personal data. We may share information with trusted service providers under strict confidentiality agreements who help us operate and improve our platform.',
      ),
      _Section(
        title: '4. Data Security',
        body:
            'We implement industry-standard security measures including TLS encryption in transit, encrypted storage at rest, and regular security audits. Access to personal data is restricted to authorised personnel on a need-to-know basis. While we take every reasonable precaution, no method of internet transmission is 100% secure. Please keep your account credentials confidential.',
      ),
      _Section(
        title: '5. Cookies and Tracking',
        body:
            'We use cookies and similar tracking technologies to maintain sessions, remember your preferences, and understand how users interact with our app. You can manage cookie preferences through your device or browser settings, though disabling certain cookies may affect the availability or functionality of some features.',
      ),
      _Section(
        title: '6. Your Rights',
        body:
            'You have the right to access, correct, or delete your personal data at any time from the Profile section of the app. You may also request a portable copy of your data or object to certain types of processing. To exercise any of these rights, contact us at privacy@swiftree.com. We aim to respond within 30 days.',
      ),
      _Section(
        title: '7. Contact Us',
        body:
            'If you have questions or concerns about this Privacy Policy or our data practices, please contact our Data Protection team at privacy@swiftree.com. You may also write to swiftree Technologies Ltd., Accra, Nigeria. We take all privacy concerns seriously and will respond as promptly as possible.',
      ),
    ];

    return _buildScrollView(sections);
  }

  // ── Shared layout ────────────────────────────────────────────────────────

  Widget _buildScrollView(List<_Section> sections) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...sections.asMap().entries.map((entry) {
            final idx = entry.key;
            final section = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: AppFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  section.body,
                  style: AppFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                    height: 1.6,
                  ),
                ),
                if (idx < sections.length - 1) ...[
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFE2E8F0), height: 1),
                  const SizedBox(height: 20),
                ],
              ],
            );
          }),
          const SizedBox(height: 36),
          Center(
            child: Text(
              'Last updated: January 2025',
              style: AppFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Internal data class ────────────────────────────────────────────────────

class _Section {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;
}
