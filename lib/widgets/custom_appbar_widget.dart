import 'dart:ui';

import 'package:carkett/generated/l10n.dart';
import 'package:carkett/providers/appbar_controller.dart';
import 'package:carkett/services/auth_firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'custom_textfield_widget.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomAppbarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  CustomAppbarWidget({
    super.key,
    this.widgetZone = const SizedBox(),
    this.autofocus = false,
    this.withTitle = true,
    this.onTapSearch,
  });
  final bool autofocus;
  final bool withTitle;
  final Function()? onTapSearch;

  final FocusNode focusNode = FocusNode();
  final Widget widgetZone;

  @override
  Widget build(BuildContext context) {
    final bool withButtons = Provider.of<AppbarController>(context).withButtons;

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
                title: FutureBuilder(
                    future: AuthFirebaseService().getUid(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      return Row(
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
                                    child: CustomButtonSearch(
                                      hintText: S.current.search,
                                      prefixIcon: Icons.search,
                                      autofocus: autofocus,
                                      height: 40,
                                      focusNode: focusNode,
                                      filled: true,
                                      onTap: onTapSearch ??
                                          () {
                                            GoRouter.of(context)
                                                .push('/searchzone');
                                          },

                                      // onChanged: (value) {},
                                      onTapOutside: (x) {
                                        String search =
                                            "argumentsNote.searchNotes";
                                        if (search.isEmpty) {
                                          focusNode.unfocus();
                                        }
                                      },
                                    ))
                                .animate()
                                .fade()
                                .slideX(curve: Curves.ease, begin: .09, end: 0),
                          if (withButtons) widgetZone,
                          if (snapshot.data == null)
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.login)),
                        ],
                      );
                    }),
              ),
            ),
          ),
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
