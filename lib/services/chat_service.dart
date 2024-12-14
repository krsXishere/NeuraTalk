import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:tubes_so_chat/common/constant.dart';
import 'package:tubes_so_chat/models/chat_model.dart';
import 'package:web_socket_channel/io.dart';

class ChatService {
  IOWebSocketChannel? _channel;

  IOWebSocketChannel createChannel(String address) {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return _channel = IOWebSocketChannel.connect(
      Uri.parse(address),
      customClient: client,
    );
  }

  Future<void> chat(
    void Function(ChatModel?) onData, {
    bool? isSend,
    String? messageToSend,
  }) async {
    try {
      if (_channel == null) {
        createChannel(baseAPIURL());
      } else {
        await closeChannel();
        createChannel(baseAPIURL());
      }

      if (isSend == true) {
        _channel?.sink.add(messageToSend);
      }

      _channel?.stream.listen((message) {
        var data = jsonDecode(message);
        log("message: $data");

        if(messageToSend!.contains("use_ai")) {
          ChatModel? chatModel = ChatModel.fromAiJson(data);
          onData(chatModel);
        } else {
          ChatModel? chatModel = ChatModel.fromJson(data);
          onData(chatModel);
        }
      }, onError: (e) {
        closeChannel();
        log("Error: $e");
        Exception("$e");
      }, onDone: () {
        closeChannel();
      });
    } catch (e) {
      log("Error: $e");
      throw Exception("$e");
    }
  }

  closeChannel() {
    _channel?.sink.close();
    _channel = null;
  }
}
