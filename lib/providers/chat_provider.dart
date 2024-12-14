import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tubes_so_chat/models/chat_model.dart';
import 'package:tubes_so_chat/services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final _chatService = ChatService();
  ChatModel? _chatModel;
  ChatModel? get chatModel => _chatModel;
  final List<ChatModel?> _chats = [];
  List<ChatModel?> get chats => _chats;
  bool _isUseAi = false;
  bool get isUseAi => _isUseAi;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    if (!isLoading) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  setUseAi(bool value) {
    _isUseAi = value;
    notifyListeners();
  }

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> chat({
    bool? isSend,
    String? messageToSend,
  }) async {
    try {
      if (isSend == true && messageToSend != null) {
        setLoading(true);
        _chats.add(
          ChatModel(
            status: "success",
            message: messageToSend,
            isSender: true,
          ),
        );
        scrollToBottom();
      }

      await _chatService.chat(
        (data) {
          if (data != null) {
            _chatModel = data;
            _chats.add(_chatModel);
            setLoading(false);
            scrollToBottom();

            notifyListeners();
          }
        },
        isSend: isSend,
        messageToSend:
            _isUseAi == true ? "$messageToSend use_ai" : messageToSend,
      );
      scrollToBottom();

      return true;
    } catch (e) {
      setLoading(false);
      scrollToBottom();
      log("Error: $e");
      Exception("$e");

      return false;
    }
  }

  void closeChat() {
    try {
      _chatService.closeChannel();
    } catch (e) {
      log("Error: $e");
      Exception("$e");
    }
  }
}
