import 'dart:async';
import 'package:flutter/material.dart';

class MessageContainerWidget extends StatefulWidget {
  const MessageContainerWidget({
    super.key,
    this.message = "Carkett",
    this.textButton,
    this.maxWidth = 320,
    this.rewrite = true,
    this.onChange,
  });

  final String message;
  final TextButton? textButton;
  final double maxWidth;
  final bool rewrite;
  final Function(bool)? onChange;

  @override
  State<MessageContainerWidget> createState() => _MessageContainerWidgetState();
}

class _MessageContainerWidgetState extends State<MessageContainerWidget> {
  String _displayedMessage = "";
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTypingEffect();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

        if (widget.onChange != null) {
          widget.onChange!(true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: widget.maxWidth),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
            bottomLeft: Radius.circular(17),
            bottomRight: Radius.circular(17),
            topRight: Radius.circular(17),
          ),
        ),
        child: RichText(
          text: TextSpan(
            children: [
              if (widget.rewrite)
                TextSpan(
                  text: _displayedMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              if (!widget.rewrite)
                TextSpan(
                  text: widget.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              if (_displayedMessage.length == widget.message.length)
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: widget.textButton ?? const SizedBox(),
                ),
            ],
          ),
          maxLines: 20,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
