import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/measurements.dart';
import '../data/brands.dart';
import '../models/product.dart';
import '../services/auth_service.dart';
import '../services/home_repository.dart';
import '../services/measurement_store.dart';
import '../services/profile_store.dart';
import '../utils/size_recommender.dart';
import '../utils/fit_labels.dart';
import '../widgets/product_image.dart';
import 'measurements_screen.dart';

/// US-020: the product page opened from "Picked for you" or a notification.
/// It shows the size we recommend, and updates when the fit preference or
/// measurements change (US-013).
class ProductScreen extends StatefulWidget {
  final Product product;

  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  HomeData? data;

  @override
  void initState() {
    super.initState();
    ProfileStore.instance.revision.addListener(_load);
    MeasurementStore.instance.revision.addListener(_load);
    _load();
  }

  Future<void> _load() async {
    final d = await HomeRepository.load(
        AuthService.instance.currentUser?.email ?? '');
    if (mounted) setState(() => data = d);
  }

  @override
  void dispose() {
    ProfileStore.instance.revision.removeListener(_load);
    MeasurementStore.instance.revision.removeListener(_load);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final brand = Brands.byId(p.brandId)?.name ?? p.brandId;
    final size = data?.sizeForProduct(p);
    final chart = SizeRecommender.charts[p.garment]!;
    return Scaffold(
      appBar: AppBar(title: Text(brand)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          ProductImage(product: p, height: 320, radius: 22),
          const SizedBox(height: 16),
          Text(brand, style: const TextStyle(color: AppColors.textSecondary)),
          Text(p.name,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy)),
          const SizedBox(height: 4),
          Text(AppStrings.price(p.priceNpr),
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 18),
          if (data != null && size == null)
            OutlinedButton.icon(
              icon: const Icon(Icons.accessibility_new),
              label: Text(AppStrings.scanToSeeSize),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => MeasurementsScreen(
                      measurements: data?.measurements ??
                          Measurements(
                              chest: 90,
                              waist: 75,
                              hip: 95,
                              shoulder: 40,
                              inseam: 80,
                              sleeve: 60,
                              takenAt: DateTime.now())))),
            ),
          if (size != null)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: AppColors.blueSoft,
                  borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Icon(Icons.verified_outlined, color: AppColors.blue),
                  const SizedBox(width: 10),
                  Text('${AppStrings.yourSize}: ',
                      style: const TextStyle(color: AppColors.navy)),
                  Text(size,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy)),
                  const Spacer(),
                  Text(AppStrings.fitLabel(data!.fit.label),
                      style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          const SizedBox(height: 18),
          Text(AppStrings.sizes,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in chart.sizes)
                ChoiceChip(
                  label: Text(s),
                  selected: s == size,
                  onSelected: (_) {},
                  selectedColor: AppColors.blue,
                  labelStyle: TextStyle(
                      color: s == size ? Colors.white : AppColors.navy),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
