import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tubes_so_chat/common/constant.dart';
import 'package:tubes_so_chat/providers/chat_provider.dart';
import 'package:tubes_so_chat/widget/custom_text_form_field_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkColor,
        title: Text(
          "NeuraTalk",
          style: primaryTextStyle.copyWith(
            fontSize: 14,
            fontWeight: bold,
          ),
        ),
        actions: [
          SizedBox(
            height: 50,
            width: 50,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  return IconButton(
                    tooltip: "Mode AI",
                    padding: const EdgeInsets.all(5),
                    onPressed: () {
                      chatProvider.setUseAi(!chatProvider.isUseAi);
                    },
                    icon: chatProvider.isUseAi
                        ? Image.asset("assets/png/ai-filled.png")
                        : Image.asset("assets/png/ai-outlined.png"),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/jpg/background.jpg",
              fit: BoxFit.cover,
            ),
            Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return chatProvider.chats.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: Scrollbar(
                          controller: chatProvider.scrollController,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            controller: chatProvider.scrollController,
                            itemCount: chatProvider.chats.length,
                            itemBuilder: (context, index) {
                              final data = chatProvider.chats[index];

                              return BubbleSpecialThree(
                                text: data?.message ?? "null",
                                color: data?.isSender == true
                                    ? primaryColor
                                    : darkColor,
                                tail: true,
                                isSender: data?.isSender ?? false,
                                textStyle: primaryTextStyle,
                              );
                            },
                          ),
                        ),
                      )
                    : Center(
                        child: Container(
                          height: height(context) * 0.2,
                          width: width(context) * 0.7,
                          decoration: BoxDecoration(
                            color: darkColor,
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                          ),
                          child: Center(
                            child: Text(
                              "Mulai obrolan sekarang!\nGunakan mode AI untuk keperluan tertentu.",
                              style: primaryTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.maxFinite,
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: CustomTextFormFieldWidget(
                          hintText: "Ketik pesan ...",
                          controller: chatController,
                          type: TextInputType.text,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Consumer<ChatProvider>(
                        builder: (context, chatProvider, child) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(width(context) * 0.2, 40),
                              backgroundColor: chatProvider.isLoading
                                  ? darkColor
                                  : primaryColor,
                            ),
                            onPressed: () async {
                              if (await chatProvider.chat(
                                isSend: true,
                                messageToSend: chatController.text,
                              )) {
                                chatController.clear();
                              }
                            },
                            child: chatProvider.isLoading
                                ? LoadingIndicator(
                                    colors: [
                                      primaryColor,
                                      white,
                                    ],
                                    indicatorType: Indicator.ballPulse,
                                  )
                                : Icon(
                                    Icons.send,
                                    color: white,
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
