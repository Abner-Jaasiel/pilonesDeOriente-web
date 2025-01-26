import 'package:carkett/generated/l10n.dart';
import 'package:carkett/models/products_carrusel_model.dart';
import 'package:carkett/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.data});

  final ProductCarruselModel data;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: InkWell(
        onTap: () {
          GoRouter.of(context).push("/product/${data.id}");
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipPath(
              clipper: CustomCardClipper(),
              child: Container(
                width: double.infinity,
                height: 218,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(59, 138, 138, 138),
                ),
              ),
            ),
            ClipPath(
              clipper: CustomCardClipper(),
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 120,
                        child: Image.network(
                          data.urlImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(data.rating.toString(),
                                          style: const TextStyle(fontSize: 14)),
                                      const SizedBox(height: 5),
                                      const Text('(10)',
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                  Text('L ${data.price}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const Text('Entrega el mar, 22 de oct',
                                  style: TextStyle(fontSize: 12)),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  await APIService().sendProductToServer(
                                    {"productId": data.id, "quantity": 1},
                                    route: "/cart",
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
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
                                                  child:
                                                      Text(S.current.viewCart))
                                            ],
                                          )));
                                },
                                child: Text(S.current.addToCart),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    const double x = 15;
    path.moveTo(x, 0);
    path.lineTo(0, x);
    path.lineTo(0, size.height - x);
    path.lineTo(x, size.height);

    path.lineTo(size.width - x, size.height);
    path.lineTo(size.width, size.height - x);
    path.lineTo(size.width, x);
    path.lineTo(size.width - x, 0);

    path.lineTo(x, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
