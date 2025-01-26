import 'dart:ui';

import 'package:carkett/models/gemini_chat_model.dart';
import 'package:carkett/models/product_model.dart';
import 'package:carkett/providers/chat_model_ai_controller.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/widgets/custom_textfield_widget.dart';
import 'package:carkett/widgets/message_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> modelAIChat(
    BuildContext context,
    TextEditingController textController,
    ProductModel? product,
    ScrollController scrollController,
    bool isNewMessage) {
  return showModalBottomSheet<void>(
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: const Color.fromARGB(86, 88, 91, 123),
    context: context,
    builder: (BuildContext context) {
      return Consumer<ChatModelAiController>(
        builder: (context, chatModel, child) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                border: Border.all(
                  color: Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: chatModel.messageAI.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Card(
                                color: const Color.fromARGB(181, 51, 102, 119)
                                    .withOpacity(0.9),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    (chatModel.messageUser[index].isNotEmpty
                                        ? chatModel.messageUser[index]
                                        : ""),
                                  ),
                                ),
                              ),
                              MessageContainerWidget(
                                onChange: (value) {
                                  Future.delayed(Duration.zero, () {
                                    if (scrollController.hasClients) {
                                      scrollController.animateTo(
                                        scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                      isNewMessage = false;
                                    }
                                  });
                                },
                                message: chatModel.messageAI[index].isNotEmpty
                                    ? chatModel.messageAI[index]
                                    : "",
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.99,
                                rewrite:
                                    index == chatModel.messageAI.length - 1 &&
                                        isNewMessage,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.4),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: textController,
                              onChanged: (value) {},
                              hintText: "Chat",
                              prefixIcon: Icons.chat,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (textController.text.isNotEmpty) {
                                chatModel.addMessageUser(textController.text);
                                APIService()
                                    .fetchGeminiResponse(textController.text,
                                        "${product!.name}  ${product.description}")
                                    .then((value) {
                                  textController.text = "";
                                  print(value);
                                  GeminiAIResponse geminiAIResponse =
                                      GeminiAIResponse.fromJson(value);

                                  String messageText = geminiAIResponse
                                      .candidates[0].content.parts[0].text;

                                  chatModel.addMessageAI(messageText);
                                  isNewMessage = true;
                                });
                              }
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
