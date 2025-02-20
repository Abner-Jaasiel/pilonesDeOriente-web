import 'dart:async';
import 'package:flutter/material.dart';

class MessageContainerWidget extends StatefulWidget {
  const MessageContainerWidget(
      {super.key,
      this.message = "Carkett",
      this.textButton,
      this.maxWidth = 320,
      this.rewrite = true,
      this.onChange,
      this.margin = 2,
      this.paddingIcon = 5,
      this.paddingMessage = 10});

  final String message;
  final TextButton? textButton;
  final double maxWidth;
  final bool rewrite;
  final double margin;
  final double paddingIcon;
  final double paddingMessage;
  final Function(bool)? onChange;

  @override
  State<MessageContainerWidget> createState() => _MessageContainerWidgetState();
}

class _MessageContainerWidgetState extends State<MessageContainerWidget>
    with TickerProviderStateMixin {
  String _displayedMessage = "";
  int _currentIndex = 0;
  Timer? _timer;
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 300),
    )..repeat(reverse: true);
    _startTypingEffect();
  }

  @override
  void dispose() {
    // Corrección clave: Eliminar ambos controles
    _timer?.cancel();
    _cursorController.dispose(); // ← Añadir esta línea
    super.dispose(); // ← Mantener al final
  }

  void _startTypingEffect() {
    _timer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
      if (_currentIndex < widget.message.length) {
        setState(() {
          _displayedMessage += widget.message[_currentIndex];
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
        widget.onChange?.call(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: widget.maxWidth),
      margin: EdgeInsets.all(widget.margin),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(widget.paddingIcon),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 84, 178, 209),
                  Color.fromARGB(255, 40, 81, 129)
                ],
              ),
            ),
            child:
                const Icon(Icons.all_inclusive, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(widget.paddingMessage),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade800.withOpacity(0.6),
                    Colors.grey.shade900.withOpacity(0.6)
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: _buildAnimatedText(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedText(BuildContext context) {
    return Stack(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: _displayedMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
              ),
              if (_currentIndex < widget.message.length)
                TextSpan(
                  text: '▮',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.white,
                        blurRadius: _cursorController.value * 10,
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
