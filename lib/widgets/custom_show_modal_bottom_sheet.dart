import 'dart:ui';

import 'package:carkett/generated/l10n.dart';
import 'package:carkett/widgets/custom_textfield_widget.dart';
import 'package:flutter/material.dart';

customShowModalBottomSheet(BuildContext context, VoidCallback metho,
    TextEditingController textController, String buttonText) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CustomTextField(
                filled: true,
                autofocus: true,
                controller: textController,
                hintText: S.current.value,
                prefixIcon: Icons.mode_edit_outline_outlined,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: metho,
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      );
    },
  );
}

customShowModalBottomSheetDropdown(
    {required BuildContext context,
    required void Function(String? value) metho,
    required TextEditingController textController,
    required String textInput,
    List<DropdownMenuItem<String>>? itemsDropdown,
    required List<Widget> items}) {
  showModalBottomSheet(
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Container(
        constraints: const BoxConstraints(maxWidth: 520),
        padding: EdgeInsets.only(
          right: 20,
          left: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: 300,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (items.isNotEmpty) ...items,
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(17, 255, 255, 255),
                  borderRadius: BorderRadius.circular(35.0),
                ),
                child: DropdownButton<String>(
                  underline: Container(),
                  items: itemsDropdown,
                  hint: Text(
                    textInput,
                  ),
                  onChanged: (value) {
                    metho(value);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/*
customShowModalBottomSheetDropdown(
    {required BuildContext context,
    required void Function(String? value) metho,
    required TextEditingController textController,
    required String textInput,
    List<DropdownMenuItem<String>>? itemsDropdown,
    required List<Widget> items}) {
  showModalBottomSheet(
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: 300,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (items.isNotEmpty) ...items,
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(17, 255, 255, 255),
                  borderRadius: BorderRadius.circular(35.0),
                ),
                child: DropdownButton<String>(
                  underline: Container(),
                  items: itemsDropdown,
                  hint: Text(
                    textInput,
                  ),
                  onChanged: (value) {
                    metho(value);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
*/
customShowModalBottomListItem(
    {required BuildContext context,
    required String title,
    required List<Widget> items,
    double height = 300,
    EdgeInsets padding = const EdgeInsets.all(16.0),
    showDragHandle = false}) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    showDragHandle: showDragHandle,
    context: context,
    builder: (BuildContext context) {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height,
              width: double.infinity,
              padding: padding,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[...items],
              ),
            ),
          ),
        ],
      );
    },
  );
}
