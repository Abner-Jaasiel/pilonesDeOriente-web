import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkett/generated/l10n.dart';
import 'package:carkett/models/product_model.dart';
import 'package:carkett/models/user_model.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/utils/utils.dart';
import 'package:carkett/widgets/show_long_text_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

class ProductInfoPanelWidget extends StatelessWidget {
  const ProductInfoPanelWidget({
    super.key,
    required this.context,
    required this.product,
  });

  final BuildContext context;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    List<Icon> starRatingIcon;
    starRatingIcon = ratinginfo(product.rating);
    return LayoutBuilder(builder: (context, constrains) {
      bool sizeScreen = constrains.maxWidth > 1000;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FutureBuilder(
                  key: ValueKey(product.sellerfirebaseUid),
                  future: APIService()
                      .getUserWithFirebaseId(product.sellerfirebaseUid),
                  builder: (context, snapshotUser) {
                    if (snapshotUser.connectionState ==
                        ConnectionState.waiting) {
                      return Text("${S.current.loading}...");
                    } else if (snapshotUser.hasError) {
                      return Text('Error: ${snapshotUser.error}');
                    } else if (snapshotUser.hasData) {
                      snapshotUser.data;
                      UserModel? model = UserModel.fromJson(
                          snapshotUser.data as Map<String, dynamic>);

                      return IconButton(
                        onPressed: () {
                          GoRouter.of(context)
                              .push('/user_perfile/false/${model.firebaseUid}');
                        },
                        icon: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: model.profileImageUrl != null
                                  ? CachedNetworkImageProvider(
                                      model.profileImageUrl!)
                                  : const AssetImage(
                                      'assets/images/profileUser.jpg'),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              snapshotUser.hasData ? model.name : 'No data',
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Text('No data');
                    }
                  }),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: constrains.maxWidth * 0.9,
                child: Text(
                  product.name,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: starRatingIcon,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "L ${product.price}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: product.tags.map((tag) {
                return Chip(
                  label: Text(
                    tag,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  backgroundColor: Theme.of(context).chipTheme.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: sizeScreen ? 200 : 500,
                  minHeight: sizeScreen ? 100 : 400,
                ),
                child: Markdown(
                  key: const PageStorageKey<String>('scrollProductScreenKEY'),
                  selectable: true,
                  data: product.description,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
              TextButton(
                onPressed: () {
                  showLongTextWindow(
                      context, product.name, product.description);
                },
                child: Text(S.current.seeMore),
              ),
            ],
          ),
        ],
      );
    });
  }
}
