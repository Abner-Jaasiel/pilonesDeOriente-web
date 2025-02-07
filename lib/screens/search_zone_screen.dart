import 'package:carkett/generated/l10n.dart';
import 'package:carkett/models/search_model.dart';
import 'package:carkett/providers/search_filter_controller.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/widgets/custom_appbar_widget.dart';
import 'package:carkett/widgets/custom_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../widgets/cards/product_card.dart';
import 'package:carkett/models/categories_model.dart';

class SearchZoneScreen extends StatelessWidget {
  const SearchZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SearchFilterController searchFilterController =
        Provider.of<SearchFilterController>(context);

    APIService apiService = APIService();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: CustomAppbarWidget(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: S.current.search,
                        prefixIcon: Icons.search,
                        autofocus: true,
                        height: 40,
                        filled: true,
                        onChanged: (value) {
                          searchFilterController.updateName(value);
                        },
                        onTapOutside: (x) {
                          String search = "argumentsNote.searchNotes";
                          if (search.isEmpty) {}
                        },
                      ),
                    ),
                    if (searchFilterController.categoryName.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Chip(
                          label: Text(searchFilterController.categoryName),
                          onDeleted: () {
                            searchFilterController.clearCategory();
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: apiService.getFilteredProducts({
                "tags": searchFilterController.tags,
                "category_id": searchFilterController.categoryId,
                "seller_firebase_uid": searchFilterController.seller,
                "name": searchFilterController.name,
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  List<dynamic> jsonList = snapshot.data as List<dynamic>;
                  SearchModel data = SearchModel.fromJson(jsonList);

                  return ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.devices),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.kitchen),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.checkroom),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.health_and_safety),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.directions_car),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      if (searchFilterController.name.isEmpty)
                        FutureBuilder(
                          future: APIService().fetchCategories(15),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.data == null) {
                              return const Center(
                                  child: Text('No data available.'));
                            }

                            List<CategoriesModel> categoriesList =
                                CategoriesModel.fromJsonList(snapshot.data!);

                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 35, right: 15),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: categoriesList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      const Divider(),
                                      ListTile(
                                        onTap: () {
                                          searchFilterController.categoryId =
                                              categoriesList[index].categoryId;
                                          searchFilterController.categoryName =
                                              categoriesList[index]
                                                  .categoryName;
                                        },
                                        title: Text(
                                            categoriesList[index].categoryName),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.products.length,
                        itemBuilder: (context, index) {
                          final product = data.products[index];
                          return ProductCard(data: product)
                              .animate()
                              .fadeIn(duration: 400.ms, curve: Curves.easeIn)
                              .moveX(begin: 30, end: 0);
                        },
                      ),
                    ],
                  );
                } else {
                  return const Center(
                      child: Text('No se encontraron productos.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
