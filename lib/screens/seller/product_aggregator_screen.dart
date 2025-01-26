import 'dart:io';
import 'package:carkett/generated/l10n.dart';
import 'package:carkett/providers/location_controller.dart';
import 'package:carkett/providers/product_aggregator_controller.dart';
import 'package:carkett/screens/product_zone/product_screen.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/services/file_service.dart';
import 'package:carkett/widgets/custom_textfield_widget.dart';
import 'package:carkett/widgets/seller/categories_menu_widget.dart';
import 'package:carkett/widgets/super_progressindicator_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';

class ProductAggregatorScreen extends StatefulWidget {
  const ProductAggregatorScreen({super.key});

  @override
  _ProductAggregatorScreenState createState() =>
      _ProductAggregatorScreenState();
}

class _ProductAggregatorScreenState extends State<ProductAggregatorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _priceController =
      TextEditingController(text: "0");
  final List<String> _tags = [];

  int _categoryId = 0;

  int _currentStep = 0;

  void _addTag(String tag) {
    if (tag.isNotEmpty) {
      setState(() {
        _tags.add(tag);
      });
    }
  }

  void _addCategory(int categoryId) {
    setState(() {
      _categoryId = categoryId;
    });
  }

  void _incrementPrice() {
    setState(() {
      double currentPrice = double.tryParse(_priceController.text) ?? 0;
      _priceController.text = (currentPrice + 1).toString();
    });
  }

  void _decrementPrice() {
    setState(() {
      double currentPrice = double.tryParse(_priceController.text) ?? 0;
      if (currentPrice > 0) {
        _priceController.text = (currentPrice - 1).toString();
      }
    });
  }

  void _submitProduct() async {
    LocationController locationController =
        Provider.of<LocationController>(context, listen: false);

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final List<String> urlImage = [];

      Map<String, dynamic> data = {
        "name": _nameController.text,
        "description": _descriptionController.text,
        "seller_firebase_uid": user.uid,
        "location_latitude": locationController.locationLat,
        "location_longitude": locationController.locationLng,
        // "location_id": [_locationController.text],
        "stock": null,
        "price": double.tryParse(_priceController.text) ?? 0,
        "tags": _tags,
        "category_id": _categoryId,
        "color": ""
      };

      List<String> missingFields = [];
      if (data["name"].isEmpty) missingFields.add("Nombre");
      if (data["description"].isEmpty) missingFields.add("Descripción");
      if (data["location_latitude"] == 0) missingFields.add("Location_lat");
      if (data["location_longitude"] == 0) missingFields.add("Location_long");
      if (data["price"] == 0) missingFields.add("Precio");
      if (data["tags"].isEmpty) missingFields.add("Etiquetas");
      if (data["category_id"] == null) missingFields.add("Categoría");

      if (missingFields.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Faltan los siguientes campos: ${missingFields.join(', ')}",
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      APIService apiService = APIService();
      final Map<String, dynamic>? productResponse =
          await apiService.sendProductToServer(data);

      if (productResponse != null) {
        ProductAggregatorController productAggregatorController =
            Provider.of<ProductAggregatorController>(context, listen: false);
        final idProduct = productResponse["productId"];
        // ignore: use_build_context_synchronously
        superProgressIndicator(context);
        for (int i = 0;
            i < productAggregatorController.pickedFile.length;
            i++) {
          final String? imageUploaded = await uploadProductImageFirebase(
              productAggregatorController.pickedFile[i], idProduct);

          if (imageUploaded != null) {
            urlImage.add(imageUploaded);
          }
        }

        await apiService.sendProductToServer(
            {"urlimage": urlImage, "id": productResponse["productId"]},
            route: "/updateImage", method: "PATCH");
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        _nameController.clear();
        _descriptionController.clear();

        _priceController.clear();

        urlImage.clear();
        _tags.clear();

        setState(() {
          _currentStep--;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stepper stepper = Stepper(
      type: StepperType.horizontal,
      currentStep: _currentStep,
      onStepContinue: () {
        if (_currentStep < 1) {
          setState(() {
            _currentStep++;
          });
        } else {
          _submitProduct();
        }
      },
      onStepCancel: () {
        if (_currentStep > 0) {
          setState(() {
            _currentStep--;
          });
        }
      },
      steps: [
        Step(
          title: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.4,
            ),
            child: Text(
              S.current.productAggregator,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          content: StepOne(
            nameController: _nameController,
            priceController: _priceController,
            incrementPrice: _incrementPrice,
            decrementPrice: _decrementPrice,
          ),
        ),
        Step(
          title: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.4,
            ),
            child: Text(
              S.current.addDetails,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          content: StepTwo(
            descriptionController: _descriptionController,
            addTag: _addTag,
            addCategory: _addCategory,
            tags: _tags,
          ),
        ),
      ],
    );

    return LayoutBuilder(builder: (context, constrains) {
      bool sizeScreen = constrains.maxWidth > 1000;
      return sizeScreen
          ? Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 600, child: Scaffold(body: stepper)),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 340,
                        child: Image.asset("assets/images/smartphone.png"),
                      ),
                      const SizedBox(
                        width: 300,
                        height: 600,
                        child: ProductScreen(
                          productId: "98528a49-514d-4c76-b7d8-c32a164852a6",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : SafeArea(child: stepper);
    });
  }
}

class StepOne extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final VoidCallback incrementPrice;
  final VoidCallback decrementPrice;

  const StepOne({
    super.key,
    required this.nameController,
    required this.priceController,
    required this.incrementPrice,
    required this.decrementPrice,
  });

  @override
  Widget build(BuildContext context) {
    LocationController locationController =
        Provider.of<LocationController>(context);
    ProductAggregatorController productAggregatorController =
        Provider.of<ProductAggregatorController>(context);

    final ImagePicker picker = ImagePicker();

    Future<void> pickImages() async {
      final List<XFile> pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        productAggregatorController.pickedFile = pickedFiles;
        print(productAggregatorController.pickedFile);
      }
    }

    return Column(
      children: [
        InkWell(
          onTap: () => {pickImages()},
          child: Container(
            height: 200,
            constraints: const BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: Theme.of(context).iconTheme.color!.withOpacity(0.5)),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: productAggregatorController.pickedFile.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                productAggregatorController.pickedFile.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(
                                  File(productAggregatorController
                                      .pickedFile[index].path),
                                  height: 180,
                                  width: 180,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_a_photo),
                        const SizedBox(height: 10),
                        Text(S.current.addAPhoto),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        CustomTextField(
          controller: nameController,
          hintText: S.current.title,
          prefixIcon: Icons.title,
          filled: true,
          obscureText: false,
        ),
        const SizedBox(height: 5.0),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: priceController,
                hintText: S.current.price,
                prefixIcon: Icons.attach_money,
                filled: true,
                obscureText: false,
                keyboardType: TextInputType.number,
              ),
            ),
            IconButton(
              onPressed: decrementPrice,
              icon: const Icon(Icons.remove),
            ),
            IconButton(
              onPressed: incrementPrice,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
        InkWell(
          onTap: () async {
            await GoRouter.of(context).push("/map");
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            color: const Color.fromARGB(17, 36, 59, 88),
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.location_on),
                      ),
                      Text(locationController.locationName ??
                          S.current.location),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
/*
class StepTwo extends StatefulWidget {
  final TextEditingController descriptionController;
  final Function(String) addTag;
  final Function(int) addCategory;
  final List<String> tags;

  const StepTwo({
    super.key,
    required this.addTag,
    required this.addCategory,
    required this.descriptionController,
    required this.tags,
  });

  @override
  _StepTwoState createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {
  late TextEditingController _tagController;
  late List<String> tags;

  @override
  void initState() {
    super.initState();
    _tagController = TextEditingController();
    tags = List.from(widget.tags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 26.0),
        TextField(
          controller: widget.descriptionController,
          keyboardType: TextInputType.multiline,
          maxLines: 6,
          minLines: 4,
          decoration: InputDecoration(
            hintText: S.current.description,
            fillColor: const Color.fromARGB(17, 91, 135, 192),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            filled: true,
            contentPadding: const EdgeInsets.all(16.0),
          ),
        ),
        const SizedBox(height: 16.0),
        const Text("Add Tags: "),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagController,
                decoration: InputDecoration(
                  hintText: "Tag",
                  prefixIcon: const Icon(Icons.tag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                final tag = _tagController.text.trim();
                if (tag.isNotEmpty) {
                  setState(() {
                    tags.add(tag);
                  });
                  widget.addTag(tag);
                  _tagController.clear();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        const Text("Added Tags:"),
        Wrap(
          children: tags.map((tag) {
            return Chip(
              label: Text(tag),
              deleteIcon: const Icon(Icons.delete),
              onDeleted: () {
                setState(() {
                  tags.remove(tag);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16.0),
        const Text("Add Category: "),
        CategoriesMenuWidget(
          categories: widget.tags,
          addCategory: widget.addCategory,
        ),
      ],
    );
  }
}
*/

/*

class StepTwo extends StatefulWidget {
  final TextEditingController descriptionController;
  final Function(String) addTag;
  final Function(int) addCategory;
  final List<String> tags;

  const StepTwo({
    super.key,
    required this.addTag,
    required this.addCategory,
    required this.descriptionController,
    required this.tags,
  });

  @override
  _StepTwoState createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {
  late TextEditingController _tagController;
  late List<String> tags;

  List<Map<String, TextEditingController>> features = [];

  void _addFeatureField() {
    setState(() {
      features.add({
        "title": TextEditingController(),
        "description": TextEditingController(),
      });
    });
  }

  void _concatenateFeatures() {
    String updatedDescription = widget.descriptionController.text;

    for (var feature in features) {
      final title = feature["title"]?.text.trim() ?? "";
      final desc = feature["description"]?.text.trim() ?? "";
      if (title.isNotEmpty && desc.isNotEmpty) {
        updatedDescription = "- **$title**: $desc\n$updatedDescription";
      }
    }

    setState(() {
      widget.descriptionController.text = updatedDescription;
      features.clear(); // Clear features after concatenation
    });
  }

  @override
  void initState() {
    super.initState();
    _tagController = TextEditingController();
    tags = List.from(widget.tags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextField(
          controller: widget.descriptionController,
          keyboardType: TextInputType.multiline,
          maxLines: 6,
          minLines: 4,
          decoration: const InputDecoration(
            hintText: "Descripción del producto",
            fillColor: Color.fromARGB(17, 91, 135, 192),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            filled: true,
            contentPadding: EdgeInsets.all(16.0),
          ),
        ),
        const SizedBox(height: 16),
        const Text("Agregar característica:"),
        for (int i = 0; i < features.length; i++) ...[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: features[i]["title"],
                  decoration: const InputDecoration(
                    hintText: "Título de la característica",
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: features[i]["description"],
                  decoration: const InputDecoration(
                    hintText: "Descripción",
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    features.removeAt(i);
                  });
                },
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _addFeatureField,
              icon: const Icon(Icons.add),
              label: const Text("Agregar más"),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _concatenateFeatures,
              child: const Text("Guardar características"),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        const Text("Add Tags: "),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagController,
                decoration: InputDecoration(
                  hintText: "Tag",
                  prefixIcon: const Icon(Icons.tag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                final tag = _tagController.text.trim();
                if (tag.isNotEmpty) {
                  setState(() {
                    tags.add(tag);
                  });
                  widget.addTag(tag);
                  _tagController.clear();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        const Text("Added Tags:"),
        Wrap(
          children: tags.map((tag) {
            return Chip(
              label: Text(tag),
              deleteIcon: const Icon(Icons.delete),
              onDeleted: () {
                setState(() {
                  tags.remove(tag);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16.0),
        const Text("Add Category: "),
        CategoriesMenuWidget(
          categories: widget.tags,
          addCategory: widget.addCategory,
        ),
      ],
    );
  }
}
*/
class StepTwo extends StatefulWidget {
  final TextEditingController descriptionController;
  final Function(String) addTag;
  final Function(int) addCategory;
  final List<String> tags;

  const StepTwo({
    super.key,
    required this.addTag,
    required this.addCategory,
    required this.descriptionController,
    required this.tags,
  });

  @override
  _StepTwoState createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {
  late TextEditingController _tagController;
  late List<String> tags;
  List<Map<String, TextEditingController>> features = [];

  void _addFeatureField() {
    setState(() {
      features.add({
        "title": TextEditingController(),
        "description": TextEditingController(),
      });
    });
  }

  void _concatenateFeatures() {
    String updatedDescription = widget.descriptionController.text;

    for (var feature in features) {
      final title = feature["title"]?.text.trim() ?? "";
      final desc = feature["description"]?.text.trim() ?? "";
      if (title.isNotEmpty && desc.isNotEmpty) {
        updatedDescription = "- **$title**: $desc\n$updatedDescription";
      }
    }

    setState(() {
      widget.descriptionController.text = updatedDescription;
      features.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _tagController = TextEditingController();
    tags = List.from(widget.tags);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? Colors.white : Colors.grey[300]!,
              width: 1.5,
            ),
            color: isDarkMode ? Colors.black87 : Colors.white,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: SingleChildScrollView(
                child: MarkdownAutoPreview(
                  hintText: S.current.description,
                  minLines: 4,
                  controller: widget.descriptionController,
                  emojiConvert: true,
                  enableToolBar: true,
                  toolbarBackground: isDarkMode
                      ? Colors.grey[800]!
                      : const Color.fromARGB(255, 251, 253, 255),
                  expandableBackground: isDarkMode
                      ? Colors.grey[700]!
                      : const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text("Agregar característica:"),
        for (int i = 0; i < features.length; i++) ...[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: features[i]["title"],
                  decoration: const InputDecoration(
                    hintText: "Título de la característica",
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: features[i]["description"],
                  decoration: const InputDecoration(
                    hintText: "Descripción",
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    features.removeAt(i);
                  });
                },
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _addFeatureField,
              icon: const Icon(Icons.add),
              label: Text(S.current.add),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _concatenateFeatures,
              child: const Icon(Icons.save),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        const Text("Add Tags: "),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagController,
                decoration: InputDecoration(
                  hintText: "Tag",
                  prefixIcon: const Icon(Icons.tag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                maxLines: 1,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                final tag = _tagController.text.trim();
                if (tag.isNotEmpty) {
                  setState(() {
                    tags.add(tag);
                  });
                  widget.addTag(tag);
                  _tagController.clear();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        const Text("Added Tags:"),
        Wrap(
          children: tags.map((tag) {
            return Chip(
              label: Text(tag),
              deleteIcon: const Icon(Icons.delete),
              onDeleted: () {
                setState(() {
                  tags.remove(tag);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16.0),
        const Text("Add Category: "),
        CategoriesMenuWidget(
          categories: widget.tags,
          addCategory: widget.addCategory,
        ),
      ],
    );
  }
}
