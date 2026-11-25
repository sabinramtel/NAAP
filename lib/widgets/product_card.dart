import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../data/brands.dart';
import '../models/product.dart';
import 'product_image.dart';

/// US-020: one card in "Picked for you": photo, brand, price and the size we
/// recommend for this user. [recommendedSize] is null before a body scan.
class ProductCard extends StatelessWidget {
  final Product product;
  final String? recommendedSize;
  final VoidCallback onTap;

  const ProductCard(
      {super.key,
      required this.product,
      required this.recommendedSize,
      required this.onTap});

  static const double width = 150;

  @override
  Widget build(BuildContext context) {
    final brand = Brands.byId(product.brandId)?.name ?? product.brandId;
    return SizedBox(
      width: width,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ProductImage(product: product, height: 170),
                if (recommendedSize != null)
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: AppColors.navy,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        '${AppStrings.yourSize}: $recommendedSize',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(brand,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: AppColors.navy)),
            Text(product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text(AppStrings.price(product.priceNpr),
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
