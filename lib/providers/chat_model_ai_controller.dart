import 'package:flutter/material.dart';

class ChatModelAiController extends ChangeNotifier {
  List<String> _messageAI = [];
  List<String> _messageUser = [];

  List<String> get messageAI => List.unmodifiable(_messageAI);

  set messageAI(List<String> messages) {
    _messageAI = messages;
  }

  List<String> get messageUser => List.unmodifiable(_messageUser);

  set messageUser(List<String> messages) {
    _messageUser = messages;
  }

  void addMessageAI(String message) {
    _messageAI.add(message);
    notifyListeners();
  }

  void addMessageUser(String message) {
    _messageUser.add(message);
    notifyListeners();
  }
}
