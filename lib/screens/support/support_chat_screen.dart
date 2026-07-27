import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/support_provider.dart';
import '../../theme/app_theme.dart';
import 'faq_screen.dart';
import 'report_issue_screen.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final supportProvider = Provider.of<SupportProvider>(context);
    final messages = supportProvider.messages;
    final timeFormat = DateFormat('hh:mm a');

    _scrollToBottom();

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.goldAccent,
              child: Icon(Icons.headset_mic, color: AppTheme.obsidianBlack, size: 18),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WATCHHUB CONCIERGE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    CircleAvatar(radius: 3, backgroundColor: AppTheme.successGreen),
                    SizedBox(width: 4),
                    Text('Horology Specialists Online', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppTheme.goldAccent),
            tooltip: 'Browse FAQs',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.report_problem_outlined, color: AppTheme.goldAccent),
            tooltip: 'Report Issue',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportIssueScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg.sender == 'user';
                final isSystem = msg.sender == 'system';

                if (isSystem) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.goldAccent.withOpacity(0.4)),
                    ),
                    child: Text(
                      msg.message,
                      style: const TextStyle(color: AppTheme.goldAccent, fontSize: 12, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isUser) ...[
                            const CircleAvatar(
                              radius: 12,
                              backgroundColor: AppTheme.goldAccent,
                              child: Icon(Icons.watch, size: 12, color: AppTheme.obsidianBlack),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isUser ? AppTheme.goldAccent : AppTheme.cardBg,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isUser ? 16 : 4),
                                bottomRight: Radius.circular(isUser ? 4 : 16),
                              ),
                              border: Border.all(
                                color: isUser ? AppTheme.goldAccent : AppTheme.cardBorder,
                              ),
                            ),
                            child: Text(
                              msg.message,
                              style: TextStyle(
                                color: isUser ? AppTheme.obsidianBlack : AppTheme.textPrimary,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeFormat.format(msg.timestamp),
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 10),
                      ),

                      // Quick Reply Option Buttons if present
                      if (msg.options != null && msg.options!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 32),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: msg.options!.map((opt) {
                              return ActionChip(
                                backgroundColor: AppTheme.darkCharcoal,
                                side: const BorderSide(color: AppTheme.goldAccent),
                                label: Text(opt, style: const TextStyle(color: AppTheme.goldAccent, fontSize: 11)),
                                onPressed: () {
                                  if (opt == 'Browse FAQs') {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQScreen()));
                                  } else {
                                    supportProvider.selectQuickOption(opt);
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppTheme.darkCharcoal,
              border: Border(top: BorderSide(color: AppTheme.cardBorder)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Ask our horology concierge...',
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onSubmitted: (val) {
                        supportProvider.sendMessage(val);
                        _msgController.clear();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppTheme.goldAccent,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: AppTheme.obsidianBlack, size: 20),
                      onPressed: () {
                        supportProvider.sendMessage(_msgController.text);
                        _msgController.clear();
                      },
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
}
