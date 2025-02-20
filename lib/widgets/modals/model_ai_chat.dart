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
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return Consumer<ChatModelAiController>(
        builder: (context, chatModel, child) {
          void sendMessage() {
            if (textController.text.isNotEmpty) {
              chatModel.addMessageUser(textController.text);
              APIService()
                  .fetchGeminiResponse(textController.text,
                      "NAME: ${product!.name}, DESCRIPTION: ${product.description}, PRICE: ${product.price}, COMMENTS: ${product.comments}")
                  .then((value) {
                textController.text = "";
                print(value);
                GeminiAIResponse geminiAIResponse =
                    GeminiAIResponse.fromJson(value);

                String messageText =
                    geminiAIResponse.candidates[0].content.parts[0].text;

                chatModel.addMessageAI(messageText);
                isNewMessage = true;
              });
            }
          }

          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6)
                    ],
                  ),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30))),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 12,
                  right: 12,
                  top: 20,
                ),
                child: Column(
                  children: [
                    // Encabezado con icono de IA
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 84, 178, 209),
                                Color.fromARGB(255, 40, 81, 129)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.all_inclusive,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 10),
                        Text('Carkett IA',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: chatModel.messageAI.length,
                        shrinkWrap: true,
                        separatorBuilder: (_, __) => const SizedBox(height: 15),
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment:
                                chatModel.messageUser[index].isNotEmpty
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              // Mensaje del usuario
                              if (chatModel.messageUser[index].isNotEmpty)
                                _UserMessageBubble(
                                    message: chatModel.messageUser[index]),

                              // Respuesta de la IA
                              MessageContainerWidget(
                                margin: 2,
                                onChange: (value) {
                                  if (scrollController.hasClients) {
                                    scrollController.animateTo(
                                      scrollController.position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                message: chatModel.messageAI[index].isNotEmpty
                                    ? chatModel.messageAI[index]
                                    : "",
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.85,
                                rewrite:
                                    index == chatModel.messageAI.length - 1 &&
                                        isNewMessage,
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    // Área de entrada de texto
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: textController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Escribe tu mensaje...",
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7)),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                              ),
                              onSubmitted: (_) => sendMessage(),
                            ),
                          ),
                          InkWell(
                            onTap: sendMessage,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 84, 178, 209),
                                    Color.fromARGB(255, 40, 81, 129)
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.send_rounded,
                                  color: Colors.white, size: 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
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

// Burbuja de mensaje del usuario
class _UserMessageBubble extends StatelessWidget {
  final String message;

  const _UserMessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1),
        borderRadius: BorderRadius.circular(20).copyWith(
          topRight: Radius.zero,
        ),
      ),
      child: Text(message,
          style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
