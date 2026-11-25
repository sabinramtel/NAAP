import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/measurements.dart';
import '../services/auth_service.dart';
import '../services/connectivity_check.dart';
import '../services/home_repository.dart';
import '../services/measurement_store.dart';
import '../services/profile_store.dart';
import '../widgets/offline_banner.dart';
import '../widgets/product_card.dart';
import '../widgets/size_profile_card.dart';
import '../widgets/skeleton_box.dart';
import '../widgets/start_scan_card.dart';
import 'measurements_screen.dart';
import 'product_screen.dart';

/// The Home tab.
/// US-017: size card, or a scan card before any measurements; placeholders while loading.
/// US-020: "Picked for you" row.
/// US-022: content from the phone first, offline banner, pull to refresh.
class HomeScreen extends StatefulWidget {
  final ScrollController? scrollController;
  final VoidCallback? onOpenTryOn;

  const HomeScreen({super.key, this.scrollController, this.onOpenTryOn});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeData? data;
  bool offline = false;

  String get email => AuthService.instance.currentUser?.email ?? '';

  @override
  void initState() {
    super.initState();
    ProfileStore.instance.revision.addListener(_load);
    MeasurementStore.instance.revision.addListener(_load);
    _load();
  }

  Future<void> _load() async {
    final online = ConnectivityCheck.isOnline().then((on) {
      if (mounted) setState(() => offline = !on);
    });
    final d = await HomeRepository.load(email);
    if (mounted) setState(() => data = d);
    await online;
  }

  @override
  void dispose() {
    ProfileStore.instance.revision.removeListener(_load);
    MeasurementStore.instance.revision.removeListener(_load);
    super.dispose();
  }

  void _openScan() => Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => MeasurementsScreen(
          measurements: data?.measurements ??
              Measurements(
                  chest: 90,
                  waist: 75,
                  hip: 95,
                  shoulder: 40,
                  inseam: 80,
                  sleeve: 60,
                  takenAt: DateTime.now()))));

  Widget _sizeSection() {
    final d = data;
    if (d == null) return const SkeletonBox(height: 170, radius: 22);
    final m = d.measurements;
    if (m == null) return StartScanCard(onStart: _openScan);
    return SizeProfileCard(
      data: d,
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => MeasurementsScreen(measurements: m))),
    );
  }

  Widget _picksSection() {
    final d = data;
    const rowHeight = 250.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            d == null || d.hasStyles
                ? AppStrings.pickedForYou
                : AppStrings.popularNow,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.navy)),
        const SizedBox(height: 10),
        SizedBox(
          height: rowHeight,
          child: d == null
              ? ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, __) => const SkeletonBox(
                      width: ProductCard.width, height: rowHeight),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: d.picks.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final product = d.picks[i];
                    return ProductCard(
                      product: product,
                      recommendedSize: d.sizeForProduct(product),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProductScreen(product: product))),
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final name =
        data?.profile?.name ?? AuthService.instance.currentUser?.name ?? '';
    final firstName = name.trim().split(' ').first;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.hi(firstName),
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          controller: widget.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            if (offline) ...[const OfflineBanner(), const SizedBox(height: 12)],
            _sizeSection(),
            const SizedBox(height: 18),
            _picksSection(),
          ],
        ),
      ),
    );
  }
}
