import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

class _SupportMessage {
  final String text;
  final bool isMe; // false = Admin
  final DateTime timestamp;
  final bool seen;
  final String messageType; // 'text'

  const _SupportMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.seen = false,
    this.messageType = 'text',
  });
}

// ---------------------------------------------------------------------------
// HelpSupportScreen
// ---------------------------------------------------------------------------

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollCtrl = ScrollController();

  // Poolmate colour tokens
  static const Color _primary = Color(0xFF2B80FF);
  static const Color _grey50 = Color(0xFFFFFFFF);
  static const Color _grey100 = Color(0xFFF6F8F9);
  static const Color _grey200 = Color(0xFFE0E7EB);
  static const Color _grey600 = Color(0xFF7691A3);
  static const Color _grey700 = Color(0xFF485D6B);
  static const Color _grey800 = Color(0xFF1F282E);
  static const Color _grey900 = Color(0xFF0A0D0F);

  final List<_SupportMessage> _chatMessages = [
    _SupportMessage(
      text: 'Hello! Welcome to swiftree Support. How can we help you today?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      seen: true,
    ),
    _SupportMessage(
      text: 'Hi, I placed an order 40 minutes ago and it hasn\'t arrived yet.',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
      seen: true,
    ),
    _SupportMessage(
      text: 'I\'m sorry to hear that. Could you please share your order ID so we can look into it right away?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
      seen: true,
    ),
    _SupportMessage(
      text: 'It\'s #YND-20043',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
      seen: true,
    ),
    _SupportMessage(
      text: 'Thank you! I can see your order is on the way — your rider is about 5 minutes away. We\'ve also applied a ₵5 voucher to your account for the delay. Sorry for the inconvenience!',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      seen: false,
    ),
  ];

  final List<Map<String, String>> _faqs = [
    {
      'q': 'How do I track my order?',
      'a': 'You can track your order in real-time from the Orders tab. Tap on any active order to see the live tracking map and rider details.',
    },
    {
      'q': 'How do I cancel an order?',
      'a': 'You can cancel an order within 2 minutes of placing it. Go to Orders → tap the order → tap Cancel Order. After that window, please contact our support team.',
    },
    {
      'q': 'What payment methods are accepted?',
      'a': 'We accept MTN Mobile Money, Vodafone Cash, AirtelTigo Money, and Cash on Delivery. More payment options are coming soon.',
    },
    {
      'q': 'My order is late. What do I do?',
      'a': 'If your order is taking longer than the estimated time, please check the live tracking first. If the issue persists, use the chat button on the tracking screen to message your rider directly.',
    },
    {
      'q': 'How do I change my delivery address?',
      'a': 'You can update your address before the order is confirmed. Go to Cart → tap your address → select a saved address or add a new one.',
    },
    {
      'q': 'How do I become a swiftree rider?',
      'a': 'We are always looking for reliable riders! Visit swiftree.com/riders or send an email to riders@swiftree.com with your details.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _messageController.dispose();
    _chatScrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _chatMessages.add(_SupportMessage(
        text: text,
        isMe: true,
        timestamp: DateTime.now(),
        seen: false,
      ));
      _messageController.clear();
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollCtrl.hasClients) {
        _chatScrollCtrl.animateTo(
          _chatScrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _grey100,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: _grey50,
        centerTitle: false,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.chevron_left_outlined, color: _grey900, size: 28),
        ),
        title: Text(
          'Help & Support',
          style: AppFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _grey800,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Column(
            children: [
              Container(height: 4, color: _grey200),
              TabBar(
                controller: _tabController,
                indicatorColor: _primary,
                labelColor: _primary,
                unselectedLabelColor: _grey600,
                labelStyle: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                unselectedLabelStyle: AppFonts.inter(fontSize: 13),
                tabs: const [
                  Tab(text: 'Chat'),
                  Tab(text: 'FAQs'),
                  Tab(text: 'Contact'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatTab(context),
          _buildFaqTab(),
          _buildContactTab(),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Tab 1 — Live Chat (Poolmate HelpSupportScreen style)
  // -------------------------------------------------------------------------

  Widget _buildChatTab(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _chatScrollCtrl,
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                return _chatItemView(
                  context: context,
                  data: _chatMessages[index],
                );
              },
            ),
          ),
          _buildChatInputBar(context),
        ],
      ),
    );
  }

  /// Poolmate's `chatItemView` method — exact layout
  Widget _chatItemView({
    required BuildContext context,
    required _SupportMessage data,
  }) {
    final bool isMe = data.isMe;
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: isMe
          ? Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Message bubble
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: const BoxDecoration(
                          color: _primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Text(
                          data.text,
                          softWrap: true,
                          style: AppFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      // User mini avatar
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE5F0FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: _primary, size: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatTime(data.timestamp),
                        style: AppFonts.inter(fontSize: 12, color: _grey800),
                      ),
                      Text(
                        data.seen ? '✓✓' : '✓',
                        style: TextStyle(
                          fontSize: 10,
                          color: data.seen ? const Color(0xFF69A5FF) : _grey800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Admin message bubble
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.grey.shade300,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Text(
                        data.text,
                        softWrap: true,
                        style: AppFonts.inter(
                          color: _grey800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin',
                      style: AppFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: _grey800,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _formatTime(data.timestamp),
                      style: AppFonts.inter(fontSize: 12, color: _grey800),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  /// Poolmate-style input bar with camera + text + send
  Widget _buildChatInputBar(BuildContext context) {
    return Container(
      color: _grey50,
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: TextField(
            style: AppFonts.inter(color: _grey800, fontSize: 14),
            textInputAction: TextInputAction.send,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: _messageController,
            onSubmitted: (_) => _sendMessage(),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 10),
              filled: true,
              fillColor: _grey100,
              disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: const BorderSide(color: _grey100, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: const BorderSide(color: _primary, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: const BorderSide(color: _grey100, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: const BorderSide(color: _grey100, width: 1),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: const BorderSide(color: _grey100, width: 1),
              ),
              suffixIcon: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send_rounded, color: _grey800),
              ),
              prefixIcon: IconButton(
                onPressed: () => _showMediaPicker(context),
                icon: const Icon(Icons.camera_alt, color: _grey800),
              ),
              hintText: 'Start typing ...',
              hintStyle: AppFonts.inter(color: _grey700, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }

  void _showMediaPicker(BuildContext context) {
    final action = CupertinoActionSheet(
      message: Text(
        'Send Media',
        style: AppFonts.inter(fontWeight: FontWeight.w600, fontSize: 12, color: _grey800),
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Choose image from gallery'),
        ),
        CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Choose video from gallery'),
        ),
        CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Take a Photo'),
        ),
        CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Record video'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  // -------------------------------------------------------------------------
  // Tab 2 — FAQs
  // -------------------------------------------------------------------------

  Widget _buildFaqTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard(),
        const SizedBox(height: 20),
        Text(
          'Frequently Asked Questions',
          style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: _grey50,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: _faqs.asMap().entries.map((entry) {
                final idx = entry.key;
                final faq = entry.value;
                return Column(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        backgroundColor: _grey50,
                        collapsedBackgroundColor: _grey50,
                        iconColor: _primary,
                        collapsedIconColor: _primary,
                        title: Text(
                          faq['q']!,
                          style: AppFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        children: [
                          Text(
                            faq['a']!,
                            style: AppFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF64748B),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (idx < _faqs.length - 1)
                      const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0xFFF1F5F9)),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0068FF), Color(0xFF004FCC)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.headset_mic_outlined, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            'Frequently Asked Questions',
            style: AppFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'Find answers to common questions about swiftree',
            style: AppFonts.inter(fontSize: 13, color: Colors.white.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Tab 3 — Contact
  // -------------------------------------------------------------------------

  Widget _buildContactTab() {
    final contacts = [
      _ContactItem(
        icon: Icons.chat_bubble_outline,
        label: 'WhatsApp',
        subtitle: 'Chat with us',
        iconBg: const Color(0xFFDCFCE7),
        iconColor: const Color(0xFF16A34A),
        onTap: () => _launch('https://wa.me/233550000000'),
      ),
      _ContactItem(
        icon: Icons.mail_outline,
        label: 'Email',
        subtitle: 'support@swiftree.com',
        iconBg: const Color(0xFFEFF5FF),
        iconColor: _primary,
        onTap: () => _launch('mailto:support@swiftree.com'),
      ),
      _ContactItem(
        icon: Icons.phone_outlined,
        label: 'Call',
        subtitle: '+233 55 000 0000',
        iconBg: const Color(0xFFFFF7ED),
        iconColor: const Color(0xFFF97316),
        onTap: () => _launch('tel:+233550000000'),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2B80FF), Color(0xFF1C58B2)],
            ),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.support_agent, color: Colors.white, size: 22),
              ),
              const SizedBox(height: 14),
              Text(
                'Contact Support',
                style: AppFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'Our team is available 24/7 to help you',
                style: AppFonts.inter(fontSize: 13, color: Colors.white.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Get in Touch',
          style: AppFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),
        ...contacts.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildContactCard(c),
            )),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildContactCard(_ContactItem item) {
    return Container(
      decoration: BoxDecoration(
        color: _grey50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: item.iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: AppFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: AppFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF94A3B8), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal data class
// ---------------------------------------------------------------------------

class _ContactItem {
  const _ContactItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;
}
