import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';

class PresentationImagesWidget extends StatelessWidget {
  const PresentationImagesWidget(
      {super.key, required this.imageUrl, this.urlImage3d});

  final List<String> imageUrl;
  final List<String>? urlImage3d;

  @override
  Widget build(BuildContext context) {
    final double widthImage = MediaQuery.of(context).size.width;
    return Column(
      children: [
        ImagesAndArrowButtonsWidget(urlImage: imageUrl, widthImage: widthImage)
            .animate()
            .fadeIn()
            .scale()
            .move(delay: 300.ms, duration: 600.ms),
        const SizedBox(height: 10),
        ImagesForSelectWidget(
          urlImage: imageUrl,
          urlImage3d: urlImage3d,
        ),
      ],
    );
  }
}

class ImagesForSelectWidget extends StatelessWidget {
  const ImagesForSelectWidget(
      {super.key, required this.urlImage, this.urlImage3d});

  final List<String> urlImage;
  final List<String>? urlImage3d;

  @override
  Widget build(BuildContext context) {
    int i3d = 0;
    List<Widget> listObj3d = [];
    Widget obj3dButton = const Row();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: urlImage.length,
          itemBuilder: (context, index) {
            final Container buttonImage = Container(
              margin: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                imageUrl: urlImage[index],
                width: 50,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            );

            if (urlImage3d != null) {
              if (urlImage3d!.length > i3d) {
                final int objIndex = i3d;
                listObj3d.add(SizedBox(
                  width: 60,
                  height: 60,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(40, 142, 142, 142),
                      ),
                    ),
                    onPressed: () {
                      print("$i3d $index, $urlImage3d");
                      GoRouter.of(context).push('/object_3d_with_camera',
                          extra: urlImage3d![objIndex]);
                    },
                    label: const Icon(
                      Icons.view_in_ar_rounded,
                      size: 15,
                    ),
                  ),
                ));
                i3d++;
              }
            }

            if (index == urlImage.length - 1) {
              obj3dButton = Row(children: listObj3d);
            }

            return Row(
              children: [
                buttonImage,
                if (index == urlImage.length - 1) obj3dButton
              ],
            );
          },
        ),
      ),
    );
  }
}

class ImagesAndArrowButtonsWidget extends StatefulWidget {
  const ImagesAndArrowButtonsWidget({
    super.key,
    required this.urlImage,
    required this.widthImage,
  });

  final List<String> urlImage;
  final double widthImage;

  @override
  State<ImagesAndArrowButtonsWidget> createState() =>
      _ImagesAndArrowButtonsWidgetState();
}

class _ImagesAndArrowButtonsWidgetState
    extends State<ImagesAndArrowButtonsWidget> {
  int numImage = 0;
  int direction = 1;
  double accumulatedScroll = 0.0;

  void forwardImageMethod() {
    setState(() {
      direction = 1;
      numImage = (numImage + 1 < widget.urlImage.length) ? numImage + 1 : 0;
    });
  }

  void backImageMethod() {
    setState(() {
      direction = -1;
      numImage = (numImage > 0) ? numImage - 1 : widget.urlImage.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double sizeButton = 28.0;
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 900,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: Offset(direction.toDouble(), 0.0),
                    end: Offset.zero,
                  ).animate(animation);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                child: Stack(
                  key: ValueKey<int>(numImage),
                  children: [
                    Center(
                      child: Container(
                        width: constraints.maxWidth,
                        height: constraints.maxWidth,
                        constraints: const BoxConstraints(
                          maxWidth: 500,
                          maxHeight: 500,
                        ),
                        child: Opacity(
                          opacity: 0.9,
                          child: CachedNetworkImage(
                            imageUrl: widget.urlImage[numImage],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const SizedBox(
                                width: 30,
                                height: 30,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.pacman,
                                )),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ).animate().blur(end: const Offset(24, 44)),
                        ),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          const double swipeThreshold = 60.0;

                          accumulatedScroll += details.delta.dx;

                          if (accumulatedScroll > swipeThreshold) {
                            backImageMethod();
                            accumulatedScroll = 0.0;
                          }

                          if (accumulatedScroll < -swipeThreshold) {
                            forwardImageMethod();
                            accumulatedScroll = 0.0;
                          }
                        },
                        onTap: () {
                          context.push(
                            '/image_viewer',
                            extra: {
                              'imageUrls': widget.urlImage,
                              'initialIndex': numImage,
                            },
                          );
                        },
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxWidth,
                          child: CachedNetworkImage(
                            imageUrl: widget.urlImage[numImage],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                bottom: (constraints.maxWidth / 6) - sizeButton,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RawMaterialButton(
                      onPressed: () {
                        backImageMethod();
                      },
                      elevation: 2.0,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: sizeButton,
                      ),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        forwardImageMethod();
                      },
                      elevation: 2.0,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: sizeButton,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
