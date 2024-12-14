import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_so_chat/pages/chat_page.dart';
import 'package:tubes_so_chat/providers/chat_provider.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          darkTheme: ThemeData.dark(
            useMaterial3: true,
          ),
          theme: ThemeData.dark(
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const ChatPage(),
        );
      }),
    );
  }
}
