import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkett/models/user_model.dart';
import 'package:carkett/providers/appbar_controller.dart';
import 'package:carkett/providers/home_controller.dart';
import 'package:carkett/utils/utils.dart';
import 'package:carkett/widgets/cards/slider_widget.dart';
import 'package:carkett/widgets/custom_appbar_widget.dart';
import 'package:carkett/widgets/home_screen_widgets/product_carousels_zone_list_widget.dart';
import 'package:carkett/widgets/home_screen_widgets/top_image_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final bucketGlobal = PageStorageBucket();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset >= 200 &&
          Provider.of<AppbarController>(context, listen: false).withButtons) {
        Provider.of<AppbarController>(context, listen: false).withButtons =
            false;
      } else if (_scrollController.offset < 200 &&
          !Provider.of<AppbarController>(context, listen: false).withButtons) {
        Provider.of<AppbarController>(context, listen: false).withButtons =
            true;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> valuesWidget = [];

    List<String> valuesUrl = [
      'https://upload.wikimedia.org/wikipedia/commons/e/e4/AVANT-P870DMG-GAMING-LAPTOP.png',
    ];
    const List<String> urlImage = [
      'https://img.freepik.com/vector-premium/compras-linea_2307-76.jpg',
      'https://static.gopro.com/assets/blta2b8522e5372af40/bltb87db85f4ea39435/65e9d435f6198c0ef706c844/H12-product-finder-banner-768-2x.png',
      'https://hiraoka.com.pe/media/mageplaza/blog/post/a/m/amd-ryzen-intel-core-cual-es-el-mejor-procesador_1.jpg'
    ];

    for (int i = 0; i < valuesUrl.length; i++) {
      valuesWidget.add(
        Image.network(valuesUrl[i]),
      );
    }
    User? user = FirebaseAuth.instance.currentUser;
    return user == null
        ? Scaffold(
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: CustomAppbarWidget(
                  widgetZone: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            GoRouter.of(context).push('/login');
                          },
                          icon: const Icon(Icons.login)),
                      const SizedBox(width: 5),
                      const SizedBox(width: 22),
                    ],
                  ),
                )),
            body: ZoneProductWidget(
                scrollController: _scrollController,
                focusNode: focusNode,
                urlImage: urlImage,
                valuesWidget: valuesWidget),
          )
        : FutureBuilder(
            future: loadUserFromPreferences(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data == null) {
                return const Center(child: Text('No userdata available.'));
              }

              UserModel data = snapshot.data as UserModel;

              return Scaffold(
                extendBodyBehindAppBar: true,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(60.0),
                    child: CustomAppbarWidget(
                      onTapSearch: () {
                        GoRouter.of(context).push('/searchzone');
                      },
                      widgetZone: Row(
                        children: [
                          const Icon(Icons.location_history),
                          const SizedBox(width: 5),
                          Text(
                            data.name.length > 10
                                ? "${data.name.substring(0, 10)}..."
                                : data.name,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 22),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                const Color.fromARGB(110, 121, 121, 121),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.grey[300],
                              child: InkWell(
                                onTap: () {
                                  context.push(
                                    '/user_perfile',
                                    extra: {'isMy': true},
                                  );
                                },
                                child: ClipOval(
                                  child: data.profileImageUrl != null &&
                                          data.profileImageUrl!.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: data.profileImageUrl!,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                          width: 180,
                                          height: 180,
                                        )
                                      : Image.asset(
                                          "assets/images/profileUser.jpg",
                                          fit: BoxFit.cover,
                                          width: 180,
                                          height: 180,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                body: ZoneProductWidget(
                    scrollController: _scrollController,
                    focusNode: focusNode,
                    urlImage: urlImage,
                    valuesWidget: valuesWidget),
              );
            });
  }
}

class ZoneProductWidget extends StatelessWidget {
  const ZoneProductWidget({
    super.key,
    required ScrollController scrollController,
    required this.focusNode,
    required this.urlImage,
    required this.valuesWidget,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final FocusNode focusNode;
  final List<String> urlImage;
  final List<Widget> valuesWidget;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageStorage(
        bucket: bucketGlobal,
        child: SingleChildScrollView(
          key: const PageStorageKey('home'),
          controller: _scrollController,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  TopImage(focusNode: focusNode, urlImage: urlImage),
                  Transform.translate(
                    offset: const Offset(0, -50),
                    child: Transform.translate(
                      offset: const Offset(0, -60),
                      child: AvatarImagePngArrowWidget(
                        valuesWidget: valuesWidget,
                        urlImage: urlImage,
                      ),
                    ),
                  ),
                  PageStorage(
                      bucket: bucketGlobal,
                      child: const ProductCarouselsZoneListWidget()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AvatarImagePngArrowWidget extends StatelessWidget {
  const AvatarImagePngArrowWidget({
    super.key,
    required this.valuesWidget,
    required this.urlImage,
  });

  final List<Widget> valuesWidget;
  final List<String> urlImage;

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Provider.of<HomeController>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            homeController.imageIndex =
                (homeController.imageIndex < urlImage.length &&
                        homeController.imageIndex > 0)
                    ? homeController.imageIndex - 1
                    : urlImage.length - 1;
          },
          child: Container(
            width: 50,
            height: 80,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 190,
          height: 180,
          child: CardSlider(
            cards: valuesWidget,
            bottomOffset: .0008,
            itemDotWidth: 14,
            itemDotOffset: 0.15,
            itemDot: (itemDotWidth) {
              return Container(
                margin: const EdgeInsets.all(5),
                width: 8 + itemDotWidth,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF33a000),
                ),
              );
            },
          ),
        ),
        GestureDetector(
          onTap: () async {
            homeController.imageIndex =
                (homeController.imageIndex + 1 < urlImage.length)
                    ? homeController.imageIndex + 1
                    : 0;
          },
          child: Container(
            width: 50,
            height: 80,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
                child: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).iconTheme.color,
            )),
          ),
        ),
      ],
    );
  }
}
