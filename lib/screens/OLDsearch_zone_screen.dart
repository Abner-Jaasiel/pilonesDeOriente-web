/*import 'package:carkett/models/categories_model.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/widgets/appbar_search.dart';
import 'package:flutter/material.dart';
import 'package:carkett/screens/search_zone_screen.dart';

class OLDSearchZoneScreen extends StatelessWidget {
  const OLDSearchZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppbarSearch(
          autofocus: true,
          withTitle: false,
          withButtons: false,
        ),
      ),
      body: FutureBuilder(
          future: APIService().fetchCategories(15),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null) {
              return const Center(child: Text('No data available.'));
            }

            List<CategoriesModel> categoriesList =
                CategoriesModel.fromJsonList(snapshot.data!);

            return ListView(
              children: [
                // Categorías de filtros
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                // Filtros de búsqueda
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar productos',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          String searchText = searchController.text;
                          if (searchText.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchZoneScreen(
                                  searchText: searchText,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 35, right: 15),
                      child: Column(
                        children: [
                          const Divider(),
                          ListTile(
                            onTap: () {},
                            title: Text(categoriesList[index].categoryName),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }),
    );
  }
}
*/