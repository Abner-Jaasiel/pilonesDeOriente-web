import 'dart:ui';

import 'package:carkett/generated/l10n.dart';
import 'package:carkett/widgets/custom_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppbarSearch extends StatelessWidget {
  AppbarSearch({
    super.key,
    this.widgetZone = const SizedBox(),
    this.autofocus = false,
    this.withTitle = true,
    this.withButtons = true,
  });
  final bool autofocus;
  final bool withTitle;
  final bool withButtons;
  final FocusNode focusNode = FocusNode();
  final Widget widgetZone;
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
            child: Container(
              color:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.05),
              child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Row(
                    children: [
                      if (withTitle)
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: Text(
                              "Carkett",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                      if (!withButtons)
                        Expanded(
                                flex: 2,
                                child: CustomTextField(
                                  hintText: S.current.search,
                                  prefixIcon: Icons.search,
                                  autofocus: autofocus,
                                  height: 40,
                                  focusNode: focusNode,
                                  filled: true,
                                  onChanged: (value) {},
                                  onTapOutside: (x) {
                                    String search = "argumentsNote.searchNotes";
                                    if (search.isEmpty) {
                                      focusNode.unfocus();
                                    }
                                  },
                                ))
                            .animate()
                            .fade()
                            .slideX(curve: Curves.ease, begin: .09, end: 0),
                      if (withButtons) widgetZone,
                    ],
                  )),
            ),
          ),
        ));
  }
}
