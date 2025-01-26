import 'package:carkett/models/categories_model.dart';
import 'package:carkett/services/api_service.dart';
import 'package:flutter/material.dart';

class CategoriesMenuWidget extends StatefulWidget {
  final List<String> categories;
  final Function(int) addCategory;

  const CategoriesMenuWidget({
    super.key,
    required this.categories,
    required this.addCategory,
  });

  @override
  _CategoriesMenuWidgetState createState() => _CategoriesMenuWidgetState();
}

class _CategoriesMenuWidgetState extends State<CategoriesMenuWidget> {
  late List<CategoriesModel> categoriesList = [];

  Future<void> loadCategories() async {
    final data =
        await APIService().fetchCategories(100, withSubcategories: true);
    //setState(() {
    categoriesList = CategoriesModel.fromJsonList(data);
    // });
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  List<CategoriesModel> getParentCategories() {
    return categoriesList.where((cat) => cat.parentCategoryId == null).toList();
  }

  List<CategoriesModel> getSubCategories(int parentId) {
    return categoriesList
        .where((cat) => cat.parentCategoryId == parentId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return categoriesList.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: ExpansionPanelList.radio(
              children:
                  getParentCategories().map<ExpansionPanelRadio>((parent) {
                final subCategories = getSubCategories(parent.categoryId);
                return ExpansionPanelRadio(
                  value: parent.categoryId,
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      title: Text(parent.categoryName),
                    );
                  },
                  body: subCategories.isEmpty
                      ? const ListTile(title: Text("No subcategories"))
                      : Column(
                          children: subCategories.map((sub) {
                            return ListTile(
                              title: Text(sub.categoryName),
                              onTap: () {
                                widget.addCategory(sub.categoryId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Selected: ${sub.categoryName}')));
                              },
                            );
                          }).toList(),
                        ),
                );
              }).toList(),
            ),
          );
  }
}
