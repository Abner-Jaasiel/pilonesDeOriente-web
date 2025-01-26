import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkett/generated/l10n.dart';
import 'package:carkett/models/product_model.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/widgets/custom_appbar_blur.dart';
import 'package:carkett/widgets/home_screen_widgets/product_carousels_zone_list_widget.dart';
import 'package:carkett/widgets/modals/model_ai_chat.dart';
import 'package:carkett/widgets/product_screen/Presentation_images_widget.dart';
import 'package:carkett/widgets/product_screen/comments_product_widget.dart';
import 'package:carkett/widgets/product_screen/product_info_panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

final bucketGlobal = PageStorageBucket();

class ProductScreen extends StatefulWidget {
  const ProductScreen(
      {super.key, required this.productId, this.previewDataExample});

  final String productId;
  final Future<Map<String, dynamic>>? previewDataExample;

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Future<Map<String, dynamic>>? data;
  ProductModel? product;
  bool isNewMessage = false;
  late ScrollController _scrollController;
  late TextEditingController textController;
  bool isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    textController = TextEditingController();

    data = widget.previewDataExample ??
        APIService().fetchProduct(widget.productId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          onPressed: () {
            modelAIChat(context, textController, product, _scrollController,
                isNewMessage);
          },
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                width: 2.0),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Icon(
            Icons.all_inclusive_rounded,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: !kIsWeb
          ? const PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: CustomAppBarBlur(),
            )
          : null,
      body: PageStorage(
        bucket: bucketGlobal,
        child: Column(
          children: [
            PageStorage(
              bucket: bucketGlobal,
              child: Expanded(
                child: product == null
                    ? FutureBuilder<Map<String, dynamic>>(
                        future: data,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            product = ProductModel.fromJson(snapshot.data!);
                            return buildProductContent(product!);
                          } else {
                            return Center(child: Text(S.current.noData));
                          }
                        },
                      )
                    : buildProductContent(product!),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                width: MediaQuery.of(context).size.width,
                constraints: const BoxConstraints(maxWidth: 600),
                child: ElevatedButton(
                  onPressed: isAddingToCart
                      ? null
                      : () async {
                          setState(() {
                            isAddingToCart = true;
                          });
                          await APIService().sendProductToServer(
                            {"productId": widget.productId, "quantity": 1},
                            route: "/cart",
                          );
                          setState(() {
                            isAddingToCart = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withBlue(35)
                                  .withGreen(35)
                                  .withRed(35),
                              elevation: 4,
                              content: Row(
                                children: [
                                  Text(S.current.productAddedToCart,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  TextButton(
                                      onPressed: () {
                                        GoRouter.of(context)
                                            .push("/shopping_cart");
                                      },
                                      child: Text(S.current.viewCart))
                                ],
                              )));
                        },
                  child: isAddingToCart
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(S.current.addToCart),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//& PRINCIPAL ProductScreen:
  Widget buildProductContent(ProductModel product) {
    final Column column0 = Column(
      children: [
        if (kIsWeb)
          const PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: CustomAppBarBlur(),
          ),
        //? Imagenes widgets:
        SafeArea(
          child: PresentationImagesWidget(
              imageUrl: product.urlImage, urlImage3d: product.url3dObject),
        ),
      ],
    );

    final Column column1 = Column(
      children: [
        //? producto widget:
        Container(
          margin:
              const EdgeInsets.only(left: 16, right: 16, top: !kIsWeb ? 30 : 0),
          child: ProductInfoPanelWidget(
            context: context,
            product: product,
          ),
        ),
      ],
    );
    final Column conten0 = Column(
      children: [
        //? Comentarios widget:
        CommentsProductWidget(product: product),

        //? Categorias widget:

        const SizedBox(height: 70),
        const Divider(),
        Text(S.current.productsOfTheCategory,
            style: Theme.of(context).textTheme.titleLarge),
        const Divider(),
        const SizedBox(height: 30),
        ProductCarouselListWithCategoryWidget(
          categoryId: product.categoryId,
        ),
        const SizedBox(height: 20),

        //? Seller widget:
        Stack(
          children: [
            CachedNetworkImage(
              imageUrl:
                  "https://m.media-amazon.com/images/S/aplus-media-library-service-media/d0e1fc49-ce5b-45ec-a787-08652228d94c.__CR0,0,1464,600_PT0_SX1464_V1___.jpg",
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ProductCarouselListWithSellerWidget(
                  seller: product.sellerfirebaseUid,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    final List<Map<String, String>> faqItems = [
      {
        'question': S.current.faqDeliveryTime,
        'answer': S.current.faqDeliveryTimeAnswer,
      },
      {
        'question': S.current.faqWarranty,
        'answer': S.current.faqWarrantyAnswer,
      },
      {
        'question': S.current.faqPackageContents,
        'answer': S.current.faqPackageContentsAnswer,
      },
    ];
    final Widget faqPanelList = Column(
      children: [
        const SizedBox(height: 50),
        const Divider(),
        Text(S.current.mostCommonQuestions,
            style: Theme.of(context).textTheme.titleLarge),
        const Divider(),
        const SizedBox(height: 30),
        ExpansionPanelList.radio(
          elevation: 2,
          expandedHeaderPadding: const EdgeInsets.all(20),
          children: List.generate(
            faqItems.length,
            (index) {
              final Map<String, String> item = faqItems[index];
              return ExpansionPanelRadio(
                value: index,
                headerBuilder: (context, isExpanded) {
                  return Container(
                    height: 90.0,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? Theme.of(context)
                              .scaffoldBackgroundColor
                              .withBlue(35)
                              .withGreen(35)
                              .withRed(35)
                          : Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Text(
                        item['question'] ?? 'Unknown Question',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    item['answer'] ?? 'Unknown Answer',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );

    return PageStorage(
      bucket: bucketGlobal,
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: LayoutBuilder(builder: (context, constrains) {
            bool sizeScreen = constrains.maxWidth > 1000;

            return sizeScreen
                ? Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: column0,
                          ),
                          const SizedBox(width: 60),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                const SizedBox(height: 200),
                                column1,
                              ],
                            ),
                          ),
                        ],
                      ),
                      conten0,
                      faqPanelList,
                      const SizedBox(height: 100)
                    ],
                  )
                : Column(
                    children: [
                      column0,
                      column1,
                      conten0,
                      faqPanelList,
                      const SizedBox(height: 100)
                    ],
                  );
          }),
        ),
      ),
    );
  }
}
