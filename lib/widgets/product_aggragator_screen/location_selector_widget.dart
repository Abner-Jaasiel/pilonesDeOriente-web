import 'package:flutter/material.dart';

listBottomSheet(
    {required BuildContext context,
    required List<Widget> childrens,
    String title = ""}) {
  return showModalBottomSheet<void>(
    showDragHandle: true,
    useSafeArea: true,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              itemCount: childrens.length,
              itemBuilder: (context, index) {
                return childrens[index];
              },
            ),
          );
        },
      );
    },
  );
}
