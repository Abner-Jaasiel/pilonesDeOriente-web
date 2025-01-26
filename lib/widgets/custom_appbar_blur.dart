import 'dart:ui';

import 'package:carkett/providers/route_manager_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBarBlur extends StatelessWidget {
  const CustomAppBarBlur({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    /* final routeManager =
        Provider.of<RouteManagerController>(context, listen: false);*/

    return AppBar(
      /*  leading: routeManager.previousRoute != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => routeManager.goBack(context),
            )
          : null,*/
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(title ?? 'Carkett'),
      /* flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title ?? 'Carkett',
              ),
            ),
          ),
        ),
      ),*/
    );
  }
}
