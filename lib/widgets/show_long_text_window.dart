import 'package:carkett/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void showLongTextWindow(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      const double maxHeight = 900;
      const double maxWidth = 800;
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          constraints: const BoxConstraints(maxWidth: 1000),
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Container(
                constraints: const BoxConstraints(maxWidth: maxWidth),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  title,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: maxHeight,
                        maxWidth: maxWidth,
                      ),
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Markdown(data: content)),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(S.current.close),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
