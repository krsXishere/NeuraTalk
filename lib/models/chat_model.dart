class ChatModel {
  String? status, message;
  bool? isSender;

  ChatModel({
    required this.status,
    required this.message,
    required this.isSender,
  });

  factory ChatModel.fromJson(Map<String, dynamic> object) {
    return ChatModel(
      status: object['status'],
      message: object['message'],
      isSender: false,
    );
  }

  factory ChatModel.fromAiJson(Map<String, dynamic> object) {
    String? content;
    try {
      // Memastikan structure choices[0].message.content
      var choices = object['message']?['choices'] ?? [];
      if (choices.isNotEmpty && choices[0]?['message']?['content'] != null) {
        content = choices[0]['message']['content'];
      }
    } catch (e) {
      content = "Error parsing AI message";
    }

    return ChatModel(
      status: object['status'],
      message: content,
      isSender: false,
    );
  }
}
