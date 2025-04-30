import 'dart:io';

import 'package:curio_spark/services/hive/profile_hive_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'package:curio_spark/constants/colors.dart';
import 'package:curio_spark/model/profile.dart';
import 'package:curio_spark/widgets/theme.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  final _formKey = GlobalKey<FormState>();

  File? _newImage;
  String? _currentImagePath;

  @override
  void initState() {
    super.initState();
    final profile = ProfileHiveService.getProfile();
    _currentImagePath = profile?.image;
    usernameController = TextEditingController(text: profile?.name ?? '');
    emailController = TextEditingController(text: profile?.email ?? '');
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Image Source"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text("Camera"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text("Gallery"),
          ),
        ],
      ),
    );

    if (source == null) return;

    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        _newImage = savedImage;
        _currentImagePath = savedImage.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedProfile = Profile(
      name: usernameController.text,
      email: emailController.text,
      image: _currentImagePath,
    );

    await ProfileHiveService.saveProfile(updatedProfile);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final iconColor = Theme.of(context).iconTheme.color;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildProfileImageSection(),
                const SizedBox(height: 40),
                _buildUsernameField(iconColor),
                const SizedBox(height: 10),
                _buildEmailField(iconColor),
                const SizedBox(height: 20),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: _newImage != null
                      ? Image.file(_newImage!, fit: BoxFit.cover)
                      : (_currentImagePath != null
                          ? Image.file(File(_currentImagePath!),
                              fit: BoxFit.cover)
                          : Image.asset('assets/images/icon/default.png')),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: editIcon,
                    ),
                    child: const Icon(Icons.photo_camera, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameField(Color? iconColor) {
    return TextFormField(
      controller: usernameController,
      validator: (value) =>
          value == null || value.isEmpty ? "Enter your name" : null,
      decoration: InputDecoration(
        labelText: "Username",
        prefixIcon: Icon(Icons.person, color: iconColor),
        hintStyle: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildEmailField(Color? iconColor) {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter your email';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        prefixIcon: Icon(Icons.email, color: iconColor),
        hintStyle: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: 200,
      height: 40,
      child: ElevatedButton(
        onPressed: _saveProfile,
        child: const Text("Save"),
      ),
    );
  }
}
