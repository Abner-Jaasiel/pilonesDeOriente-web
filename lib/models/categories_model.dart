class CategoriesModel {
  final int categoryId;
  final String categoryName;
  final int? parentCategoryId;

  CategoriesModel({
    required this.categoryId,
    required this.categoryName,
    this.parentCategoryId,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      parentCategoryId: json['parent_category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'parent_category_id': parentCategoryId,
    };
  }

  static List<CategoriesModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CategoriesModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(
      List<CategoriesModel> categoriesList) {
    return categoriesList.map((category) => category.toJson()).toList();
  }
}
