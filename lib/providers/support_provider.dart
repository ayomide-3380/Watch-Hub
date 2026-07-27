import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../models/mock_data.dart';

class SupportProvider with ChangeNotifier {
  final List<ChatMessage> _messages = List.from(MockData.initialChatMessages);
  final List<FAQItem> _faqs = List.from(MockData.faqs);
  String _selectedFAQCategory = 'All';

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  String get selectedFAQCategory => _selectedFAQCategory;

  List<FAQItem> get filteredFAQs {
    if (_selectedFAQCategory == 'All') return _faqs;
    return _faqs.where((f) => f.category == _selectedFAQCategory).toList();
  }

  List<String> get faqCategories =>
      ['All', ..._faqs.map((f) => f.category).toSet()];

  void setFAQCategory(String category) {
    _selectedFAQCategory = category;
    notifyListeners();
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'user',
      message: text.trim(),
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);
    notifyListeners();

    // Auto support response logic
    _handleAutoResponse(text);
  }

  void selectQuickOption(String optionText) {
    sendMessage(optionText);
  }

  void _handleAutoResponse(String userText) {
    Future.delayed(const Duration(milliseconds: 1200), () {
      final textLower = userText.toLowerCase();
      String botReply =
          'Thank you for contacting WatchHub Concierge! An expert horologist specialist will review your inquiry shortly.';
      List<String>? options;

      if (textLower.contains('track') || textLower.contains('order')) {
        botReply =
            'You can check real-time delivery status for active orders directly in your Account -> Order History tab. Your recent order WH-9082-2026 is currently In Transit via Armored Express Courier.';
        options = ['View Order Details', 'Contact Courier', 'Main Menu'];
      } else if (textLower.contains('authentic') || textLower.contains('fake') || textLower.contains('verify')) {
        botReply =
            'Every WatchHub timepiece includes a certified digital authenticity vault record and physical master horologist inspection certificate.';
        options = ['Warranty details', 'Inspection Process', 'Main Menu'];
      } else if (textLower.contains('return') || textLower.contains('refund')) {
        botReply =
            'We offer a 14-day hassle-free return window on unworn timepieces. Would you like us to generate a complimentary insured return label?';
        options = ['Request Return Label', 'Speak to Support Specialist'];
      }

      _messages.add(ChatMessage(
        id: 'msg_bot_${DateTime.now().millisecondsSinceEpoch}',
        sender: 'support',
        message: botReply,
        timestamp: DateTime.now(),
        options: options,
      ));
      notifyListeners();
    });
  }

  void submitIssueReport({
    required String category,
    required String orderId,
    required String description,
  }) {
    _messages.add(ChatMessage(
      id: 'sys_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'system',
      message:
          'Issue Ticket Registered [#TK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}]\nCategory: $category\nOrder: $orderId\nDetails: $description',
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }
}
