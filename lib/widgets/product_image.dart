import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/size_recommender.dart';
import 'skeleton_box.dart';

/// US-022: a product photo that never leaves a blank gap.
/// While a network photo loads, a placeholder block shows in its place.
/// Until the shop has real photos, a coloured tile with an icon is drawn.
class ProductImage extends StatelessWidget {
  final Product product;
  final double height;
  final double radius;

  const ProductImage(
      {super.key,
      required this.product,
      required this.height,
      this.radius = 16});

  IconData get _icon {
    switch (product.garment) {
      case Garment.top:
        return Icons.checkroom;
      case Garment.jeans:
        return Icons.straighten;
      case Garment.dress:
        return Icons.woman;
    }
  }

  Widget _tile() {
    final color = Color(product.colorValue);
    final light = color.computeLuminance() > 0.5;
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(radius)),
      child: Center(
          child: Icon(_icon,
              size: height * 0.35,
              color: light ? Colors.black45 : Colors.white70)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = product.imageUrl;
    if (url == null) return _tile();
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        // Decode at the size we draw, not the full photo: less memory per card.
        cacheHeight: (height * MediaQuery.of(context).devicePixelRatio).round(),
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : SkeletonBox(height: height, radius: radius),
        errorBuilder: (_, __, ___) => _tile(),
      ),
    );
  }
}
