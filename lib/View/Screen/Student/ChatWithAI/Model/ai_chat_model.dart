import 'dart:io';

class AIChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final File? image;

  AIChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.image,
  });
}
