class ChatMessage {
  final String id;
  final String sender; // 'user', 'support', 'system'
  final String message;
  final DateTime timestamp;
  final List<String>? options; // Quick reply suggestions

  ChatMessage({
    required this.id,
    required this.sender,
    required this.message,
    required this.timestamp,
    this.options,
  });
}

class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}
