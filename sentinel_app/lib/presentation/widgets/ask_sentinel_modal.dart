import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/network/api_client.dart';

class AskSentinelModal extends StatefulWidget {
  final String? initialQuery;

  const AskSentinelModal({super.key, this.initialQuery});

  @override
  State<AskSentinelModal> createState() => _AskSentinelModalState();
}

class _AskSentinelModalState extends State<AskSentinelModal> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  bool _isListening = false;
  List<String> _suggestedChips = [
    "What's happening around me?",
    "Is anything affecting my route?",
    "Is Patia safe tonight?",
    "Show verified sources",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _controller.text = widget.initialQuery!;
      _sendMessage(widget.initialQuery!);
    } else {
      _messages.add({
        "sender": "sentinel",
        "text": "Hello Mahi! I am Sentinel's Grounded Assistant. Ask me anything about local safety, road advisories, weather, or verified public records."
      });
    }
  }

  void _sendMessage(String query) async {
    final text = query.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": text});
      _isLoading = true;
    });
    _controller.clear();

    try {
      final res = await apiClient.queryAssistant(query: text);
      if (mounted) {
        setState(() {
          _messages.add({
            "sender": "sentinel",
            "text": res["answer"] ?? "No updates found for this query."
          });
          if (res["suggested_questions"] != null) {
            _suggestedChips = List<String>.from(res["suggested_questions"]);
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _messages.add({
            "sender": "sentinel",
            "text": "Currently operating in offline cached mode. Northern Bhubaneswar is generally calm with 1 drainage repair on Patia Mart Road."
          });
          _isLoading = false;
        });
      }
    }
  }

  void _toggleVoice() {
    setState(() {
      _isListening = !_isListening;
    });
    if (_isListening) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _isListening) {
          setState(() {
            _isListening = false;
          });
          _sendMessage("What's happening around KIIT Campus?");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF07141C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.borderGlow, width: 1.5)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        children: [
          // Drag handle & title
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textDisabled,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cyan.withValues(alpha: 0.15),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: AppColors.cyan, size: 18),
              ),
              const SizedBox(width: 8),
              Text("Ask Sentinel", style: AppTypography.headlineMedium),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(color: AppColors.border, height: 16),

          // Chat history
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["sender"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.78,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.cyanDark : AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
                        bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(0),
                      ),
                      border: Border.all(
                        color: isUser ? AppColors.cyan : AppColors.borderLight,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isUser ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.cyan),
                  ),
                  const SizedBox(width: 8),
                  Text("Synthesizing verified intelligence...", style: AppTypography.bodySmall),
                ],
              ),
            ),

          // Suggested Chips
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _suggestedChips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _sendMessage(_suggestedChips[index]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.borderLight, width: 0.8),
                    ),
                    child: Text(
                      _suggestedChips[index],
                      style: AppTypography.bodySmall.copyWith(color: AppColors.cyan),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Input Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: _sendMessage,
                  decoration: InputDecoration(
                    hintText: _isListening ? "Listening..." : "Ask Sentinel anything...",
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: _isListening ? AppColors.cyan : AppColors.textMuted,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _toggleVoice,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isListening ? AppColors.criticalRed : AppColors.surfaceElevated,
                    shape: BoxShape.circle,
                    border: Border.all(color: _isListening ? AppColors.criticalRed : AppColors.cyan, width: 1.5),
                  ),
                  child: Icon(
                    _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                    color: _isListening ? Colors.white : AppColors.cyan,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _sendMessage(_controller.text),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: AppColors.cyan,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: AppColors.background,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
