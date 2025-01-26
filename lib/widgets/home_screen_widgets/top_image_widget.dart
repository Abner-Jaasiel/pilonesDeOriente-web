import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkett/providers/home_controller.dart';
import 'package:carkett/widgets/custom_buttom_textfield_widget.dart';
import 'package:carkett/widgets/message_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:carkett/generated/l10n.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TopImage extends StatelessWidget {
  const TopImage({
    super.key,
    required this.focusNode,
    required this.urlImage,
  });

  final FocusNode focusNode;
  final List<String> urlImage;

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Provider.of<HomeController>(context);
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: urlImage[homeController.imageIndex],
          fit: BoxFit.cover,
          width: double.infinity,
          height: 340,
        )
            .animate()
            .slide(
              begin: const Offset(-1, 0),
              end: Offset.zero,
              duration: 600.ms,
            )
            .fadeIn(duration: 600.ms),
        Positioned(
          top: 16,
          left: 10,
          child: CustomPaint(
            child: Stack(
              children: [
                Positioned(
                  left: 5,
                  top: 4,
                  child: Icon(
                    Icons.auto_awesome_sharp,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                MessageContainerWidget(
                  message: "Quieres ver las ofertas de hoy? ",
                  textButton: TextButton(
                    onPressed: () async {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      "Click",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4),
                  Colors.transparent
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: 150,
          child: Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomButtonTextfieldWidget(
                hintText: S.current.search,
                prefixIcon: Icons.search,
                onTap: () {
                  GoRouter.of(context).push('/searchzone');
                },
                height: 40,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              )),
        ),
      ],
    );
  }
}
