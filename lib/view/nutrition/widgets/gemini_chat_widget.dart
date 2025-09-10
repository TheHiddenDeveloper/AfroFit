// lib/view/nutrition/widgets/gemini_chat_widget.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fitnessapp/services/gemini_service.dart';
import 'package:fitnessapp/utils/app_colors.dart';

class GeminiChatWidget extends StatefulWidget {
  const GeminiChatWidget({super.key});

  @override
  State<GeminiChatWidget> createState() => _GeminiChatWidgetState();
}

class _GeminiChatWidgetState extends State<GeminiChatWidget>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GeminiService _geminiService = GeminiService();

  final List<_ChatMessage> _messages = [];
  bool _loading = false;
  late AnimationController _typingController;

  // System prompt for Ghanaian fitness coach persona
  final String _systemPrompt = """
You are Kwame, a professional Ghanaian fitness coach and certified nutritionist based in Accra. You have over 10 years of experience helping people achieve their fitness and nutrition goals. You understand both international nutrition principles and local Ghanaian foods and eating habits.

Your personality traits:
- Warm, encouraging, and motivational
- Uses occasional Ghanaian expressions naturally (like "charley", "masa", "eii")
- Knowledgeable about local foods like banku, kenkey, fufu, kontomire, palm nut soup, etc.
- Practical and realistic advice
- Always positive and supportive

Your expertise includes:
- Creating meal plans with local Ghanaian ingredients
- Understanding how to balance traditional foods with modern nutrition
- Portion control and healthy cooking methods
- Exercise nutrition and timing
- Weight management strategies
- Cultural sensitivity around food and body image

Always:
- Give practical, actionable advice
- Suggest local alternatives when possible
- Be encouraging and positive
- Keep responses conversational and friendly
- Ask follow-up questions to better help the user

Format your responses clearly without using markdown symbols like *, **, #, etc. Instead, use natural emphasis through sentence structure and spacing.
""";

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Add welcome message from Kwame
    _messages.add(_ChatMessage(
      text:
          "Akwaaba! 👋 I'm Kwame, your personal fitness coach and nutritionist from Accra.\n\nI'm here to help you with your fitness journey, whether it's meal planning with our local foods, understanding nutrition, or getting tips on healthy eating habits.\n\nCharley, what can I help you with today?",
      isUser: false,
      timestamp: DateTime.now(),
      isWelcome: true,
    ));
  }

  @override
  void dispose() {
    _typingController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _askGemini() async {
    final query = _controller.text.trim();
    if (query.isEmpty || _loading) return;

    setState(() {
      _messages.add(_ChatMessage(
        text: query,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _messages.add(_ChatMessage(
        text: "",
        isUser: false,
        timestamp: DateTime.now(),
        isStreaming: true,
      ));
      _loading = true;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      // Combine system prompt with user query
      final fullQuery = "$_systemPrompt\n\nUser question: $query";

      await for (final chunk
          in _geminiService.streamNutritionAdvice(fullQuery)) {
        if (mounted) {
          setState(() {
            final cleanChunk = _cleanTextFormatting(chunk);
            _messages.last = _ChatMessage(
              text: _messages.last.text + cleanChunk,
              isUser: false,
              timestamp: _messages.last.timestamp,
              isStreaming: true,
            );
          });
          _scrollToBottom();
        }
      }

      // Mark streaming as complete
      if (mounted) {
        setState(() {
          _messages.last = _ChatMessage(
            text: _messages.last.text,
            isUser: false,
            timestamp: _messages.last.timestamp,
            isStreaming: false,
          );
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.last = _ChatMessage(
            text:
                "Sorry charley, I encountered an issue. Please try asking your question again.",
            isUser: false,
            timestamp: _messages.last.timestamp,
            isError: true,
          );
          _loading = false;
        });
      }
    }
  }

  // Clean text formatting to remove markdown symbols
  String _cleanTextFormatting(String text) {
    return text
        // Remove markdown bold/italic
        .replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1')
        .replaceAll(RegExp(r'\*(.*?)\*'), r'$1')
        .replaceAll(RegExp(r'__(.*?)__'), r'$1')
        .replaceAll(RegExp(r'_(.*?)_'), r'$1')
        // Remove markdown headers
        .replaceAll(RegExp(r'^#{1,6}\s*(.*)$', multiLine: true), r'$1')
        // Clean up bullet points
        .replaceAll(RegExp(r'^[\s]*[-\*\+]\s*', multiLine: true), '• ')
        // Clean up numbered lists
        .replaceAll(RegExp(r'^\d+\.\s*', multiLine: true), '• ')
        // Remove markdown code blocks
        .replaceAll(RegExp(r'```[\s\S]*?```'), '')
        .replaceAll(RegExp(r'`([^`]*)`'), r'$1')
        // Clean up extra whitespace
        .replaceAll(RegExp(r'\n\s*\n\s*\n'), '\n\n')
        .trim();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.secondaryG,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.psychology_outlined,
              color: AppColors.whiteColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.lightGrayColor,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.primaryColor1.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Kwame is thinking",
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                _buildDot(0),
                const SizedBox(width: 3),
                _buildDot(1),
                const SizedBox(width: 3),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _typingController,
      builder: (context, child) {
        final value = _typingController.value;
        final opacity =
            (1.0 + math.sin((value * 2 * math.pi) + (index * math.pi / 3))) / 2;
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.primaryColor1.withOpacity(opacity * 0.8),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Simple chat header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.primaryG,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.psychology_outlined,
                    color: AppColors.whiteColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Coach Kwame",
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Ready to help with nutrition & fitness",
                        style: TextStyle(
                          color: AppColors.grayColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_loading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_loading && index == _messages.length) {
                  return _buildTypingIndicator();
                }

                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // Simple input field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightGrayColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText:
                            'Ask Kwame about nutrition, local foods, fitness...',
                        hintStyle: TextStyle(
                          color: AppColors.midGrayColor,
                          fontSize: 14,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onSubmitted: (_) => _askGemini(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _loading
                      ? Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.midGrayColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppColors.primaryG,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.send_rounded,
                              color: AppColors.whiteColor,
                              size: 18,
                            ),
                            onPressed:
                                _controller.text.trim().isNotEmpty && !_loading
                                    ? _askGemini
                                    : null,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!msg.isUser) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: msg.isError
                      ? [Colors.red.shade400, Colors.red.shade600]
                      : AppColors.secondaryG,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                msg.isError ? Icons.error_outline : Icons.psychology_outlined,
                color: AppColors.whiteColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                gradient: msg.isUser
                    ? LinearGradient(
                        colors: AppColors.primaryG,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: msg.isUser
                    ? null
                    : msg.isError
                        ? Colors.red.shade50
                        : msg.isWelcome
                            ? Colors.green.shade50
                            : AppColors.lightGrayColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(msg.isUser ? 20 : 4),
                  bottomRight: Radius.circular(msg.isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: msg.isUser
                        ? AppColors.primaryColor1.withOpacity(0.3)
                        : AppColors.blackColor.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: TextStyle(
                      color: msg.isUser
                          ? AppColors.whiteColor
                          : msg.isError
                              ? Colors.red.shade700
                              : AppColors.blackColor,
                      fontSize: 15,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (msg.isStreaming) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          msg.isUser
                              ? AppColors.whiteColor
                              : AppColors.primaryColor1,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (msg.isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.grayColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.person_outline,
                color: AppColors.whiteColor,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isWelcome;
  final bool isError;
  final bool isStreaming;

  _ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isWelcome = false,
    this.isError = false,
    this.isStreaming = false,
  });
}
