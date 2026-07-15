import 'dart:async';
import 'package:flutter/material.dart';
import 'package:swiftree/core/theme/app_fonts.dart';

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

class _ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final bool seen;

  const _ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.seen = false,
  });
}

// ---------------------------------------------------------------------------
// ChatScreen
// ---------------------------------------------------------------------------

class ChatScreen extends StatefulWidget {
  final String riderName;
  final String orderId;
  final String? avatarUrl;
  final bool isSupport;

  const ChatScreen({
    super.key,
    this.riderName = 'Kwame A.',
    this.orderId = '',
    this.avatarUrl,
    this.isSupport = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool _isTyping = false;

  // Poolmate primary colour
  static const Color _primary = Color(0xFF2B80FF);
  static const Color _grey50 = Color(0xFFFFFFFF);
  static const Color _grey100 = Color(0xFFF6F8F9);
  static const Color _grey200 = Color(0xFFE0E7EB);
  static const Color _grey600 = Color(0xFF7691A3);
  static const Color _grey800 = Color(0xFF1F282E);
  static const Color _grey900 = Color(0xFF0A0D0F);

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: "Hi! I've picked up your order. On my way to you now 🛵",
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
      seen: true,
    ),
    _ChatMessage(
      text: 'Great! How long will it take?',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
      seen: true,
    ),
    _ChatMessage(
      text: 'About 10–15 minutes depending on traffic. The gate is open right?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
      seen: true,
    ),
    _ChatMessage(
      text: "Yes, the gate is open. Just call when you're close",
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      seen: true,
    ),
    _ChatMessage(
      text: "Will do! I'll call when I'm 2 minutes away 👍",
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      seen: false,
    ),
  ];

  // Animated dot controllers
  late final List<AnimationController> _dotControllers;
  late final List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    _dotControllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      )..repeat(reverse: true),
    );
    _dotAnimations = _dotControllers
        .asMap()
        .entries
        .map((e) => CurvedAnimation(
              parent: e.value,
              curve: Interval(e.key * 0.2, 1.0, curve: Curves.easeInOut),
            ))
        .toList();

    // Stagger dot starts
    for (int i = 0; i < _dotControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) _dotControllers[i].repeat(reverse: true);
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    for (final c in _dotControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Actions
  // -------------------------------------------------------------------------

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isMe: true,
        timestamp: DateTime.now(),
        seen: false,
      ));
      _msgCtrl.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isTyping = false);
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
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
        backgroundColor: _grey50,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.chevron_left_outlined, color: _grey900, size: 28),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            // Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: widget.avatarUrl != null
                  ? Image.network(
                      widget.avatarUrl!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _defaultAvatar(),
                    )
                  : _defaultAvatar(),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.riderName,
                  style: AppFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _grey800,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF19FFA3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Online',
                      style: AppFonts.inter(fontSize: 11, color: _grey600),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined, color: _primary),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(height: 4, color: _grey200),
        ),
      ),
      body: Column(
        children: [
          // Order ID banner
          if (widget.orderId.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFE5F0FF),
              child: Text(
                'Order ${widget.orderId}',
                style: AppFonts.inter(
                  fontSize: 13,
                  color: _primary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _buildTypingIndicator();
                }
                final msg = _messages[index];
                return _buildChatBubble(msg);
              },
            ),
          ),

          // Input bar
          _buildInputBar(),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Default avatar
  // -------------------------------------------------------------------------

  Widget _defaultAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFFE5F0FF),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: _primary, size: 22),
    );
  }

  // -------------------------------------------------------------------------
  // Chat bubble — exact Poolmate corner radius & color logic
  // -------------------------------------------------------------------------

  Widget _buildChatBubble(_ChatMessage msg) {
    return Container(
      padding: EdgeInsets.only(
        left: msg.isMe ? 80 : 10,
        right: msg.isMe ? 10 : 80,
        top: 6,
        bottom: 6,
      ),
      child: _chatBubbles(msg.isMe, msg),
    );
  }

  Widget _chatBubbles(bool isMe, _ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 260),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    // Poolmate: isMe → grey200, !isMe → primary300
                    color: isMe ? _grey200 : _primary,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10),
                      bottomLeft: Radius.circular(isMe ? 10 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 10),
                    ),
                  ),
                  child: Text(
                    msg.text,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: AppFonts.inter(
                      fontSize: 14,
                      color: isMe ? _grey800 : _grey50,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(msg.timestamp),
                      style: AppFonts.inter(fontSize: 11, color: _grey600),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Text(
                        msg.seen ? '✓✓' : '✓',
                        style: TextStyle(
                          fontSize: 10,
                          color: msg.seen ? _primary : _grey600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Typing indicator with animated dots
  // -------------------------------------------------------------------------

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 12, top: 6),
      child: Row(
        children: [
          _defaultAvatar(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _grey50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _dotAnimations[i],
                  builder: (context, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Transform.translate(
                        offset: Offset(0, -4 * _dotAnimations[i].value),
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: _grey600,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Input bar — Poolmate style
  // -------------------------------------------------------------------------

  Widget _buildInputBar() {
    return Container(
      color: _grey50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                controller: _msgCtrl,
                focusNode: _focusNode,
                textAlign: TextAlign.start,
                maxLines: 1,
                textInputAction: TextInputAction.send,
                onFieldSubmitted: (_) => _send(),
                style: AppFonts.inter(
                  fontSize: 14,
                  color: _grey800,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: _grey100,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: const BorderSide(color: _grey100, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: _primary, width: 1),
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
                  hintText: 'Type Message',
                  hintStyle: AppFonts.inter(fontSize: 14, color: _grey600, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: _send,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: _primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
