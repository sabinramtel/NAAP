import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/profile_store.dart';
import '../utils/profile_helpers.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import 'height_screen.dart';

/// US-011: name, date of birth (18+) and an optional photo.
/// With [editing] true it is opened from Home and simply goes back after saving.
class ProfileSetupScreen extends StatefulWidget {
  final bool editing;

  const ProfileSetupScreen({super.key, this.editing = false});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  UserProfile? saved;
  DateTime? birthDate;
  String? photoPath;
  String? dateError;
  bool loading = false;

  String get email => AuthService.instance.currentUser?.email ?? '';

  @override
  void initState() {
    super.initState();
    nameController.text = AuthService.instance.currentUser?.name ?? '';
    _load();
  }

  Future<void> _load() async {
    final p = await ProfileStore.instance.load(email);
    if (!mounted || p == null) return;
    setState(() {
      saved = p;
      if (p.name.isNotEmpty) nameController.text = p.name;
      birthDate = p.birthDate;
      photoPath = p.photoPath;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
      helpText: AppStrings.dateOfBirth,
    );
    if (picked == null) return;
    setState(() {
      birthDate = picked;
      dateError = ProfileHelpers.isOldEnough(picked, now) ? null : AppStrings.underAge;
    });
  }

  /// The picker shrinks the photo to 512 px wide, so we never store a 12 MB camera file.
  Future<void> _pickPhoto() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 512, imageQuality: 85);
      if (file == null || !mounted) return;
      setState(() => photoPath = file.path);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Could not open your photos. You can add one later.')));
    }
  }

  Future<void> _continue() async {
    final nameOk = formKey.currentState!.validate();
    final now = DateTime.now();
    setState(() {
      if (birthDate == null) {
        dateError = 'Pick your date of birth.';
      } else if (!ProfileHelpers.isOldEnough(birthDate!, now)) {
        dateError = AppStrings.underAge;
      } else {
        dateError = null;
      }
    });
    if (!nameOk || dateError != null) return;

    setState(() => loading = true);
    final base = saved ?? UserProfile(name: nameController.text.trim());
    final profile = base.copyWith(
      name: nameController.text.trim(),
      birthDate: birthDate,
      photoPath: photoPath,
    );
    await ProfileStore.instance.save(email, profile);
    if (!mounted) return;
    setState(() => loading = false);

    if (widget.editing) {
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HeightScreen()));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath != null && File(photoPath!).existsSync();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.editing,
        title: widget.editing ? const Text('Edit profile') : const Text('Step 1 of 2'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(AppStrings.aboutYou,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: _pickPhoto,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: AppColors.blueSoft,
                          backgroundImage: hasPhoto ? FileImage(File(photoPath!)) : null,
                          child: hasPhoto
                              ? null
                              : Text(
                                  ProfileHelpers.initials(nameController.text),
                                  style: const TextStyle(
                                      fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.blue),
                                ),
                        ),
                        const SizedBox(height: 8),
                        const Text(AppStrings.addPhoto, style: TextStyle(color: AppColors.blue)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AppTextField(
                  controller: nameController,
                  label: AppStrings.fullName,
                  icon: Icons.person_outline,
                  validator: Validators.name,
                  onChanged: (_) => setState(() {}), // keeps the initials in step with the name
                ),
                const SizedBox(height: 14),
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: AppStrings.dateOfBirth,
                      errorText: dateError,
                      errorMaxLines: 2,
                      prefixIcon: const Icon(Icons.cake_outlined, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.card,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Text(
                      birthDate == null ? 'Tap to choose' : ProfileHelpers.formatDate(birthDate!),
                      style: TextStyle(
                          color: birthDate == null ? AppColors.textSecondary : AppColors.textPrimary,
                          fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // US-011: Continue only becomes active once a name and a date are filled in.
                PrimaryButton(
                  label: widget.editing ? AppStrings.save : AppStrings.continueText,
                  loading: loading,
                  onPressed: nameController.text.trim().isNotEmpty && birthDate != null ? _continue : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
