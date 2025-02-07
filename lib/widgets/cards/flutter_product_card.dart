import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkett/providers/appconfig_controller.dart';
import 'package:carkett/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCard extends StatefulWidget {
  final String? id;
  final String imageUrl;
  final String? shortDescription;
  final String categoryName;
  final String productName;
  final double price;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final bool? isAvailable;
  final double borderRadius;
  final int? rating;
  final double? discountPercentage;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.categoryName,
    required this.productName,
    required this.price,
    this.onTap,
    this.onFavoritePressed,
    this.shortDescription = '',
    this.id,
    this.isAvailable = true,
    this.borderRadius = 12.0,
    this.rating,
    this.discountPercentage,
  });

  @override
  ProductCardState createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard> {
  bool _isAdded = false;
  String _currency = '\$';

  @override
  void initState() {
    super.initState();
    _currency =
        Provider.of<AppConfigController>(context, listen: false).currency;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        elevation: 4,
        color: cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Opacity(
                  opacity: 0.3,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    height: 170,
                    width: 165,
                  ).animate().blur(end: const Offset(14, 24)),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.contain,
                    height: 170,
                    width: double.infinity,
                    placeholder: (context, url) => Container(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: textColor,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isAdded = !_isAdded;
                      });
                      widget.onFavoritePressed?.call();
                    },
                    icon: Icon(
                      _isAdded
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      color: _isAdded ? Colors.red : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.categoryName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.productName,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (widget.discountPercentage != null)
                              Text(
                                '${widget.discountPercentage?.toStringAsFixed(0)}% OFF',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            Text(
                              getFormattedCurrency(widget.price, context),
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
