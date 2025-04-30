import 'dart:io';
import 'package:curio_spark/constants/colors.dart';
import 'package:curio_spark/model/profile.dart';
import 'package:curio_spark/services/hive/profile_hive_service.dart';
import 'package:curio_spark/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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

  final profile = ProfileHiveService.getProfile();


  @override
void initState() {
  super.initState();
  // Access the already opened box instead of opening it again
  var box = Hive.box<Profile>('profiles');

  // Get the first profile from the box (or default values if it's empty)
  var profile = box.isNotEmpty ? box.getAt(0) : null;

  if (profile != null) {
    _currentImagePath = profile.image;
    usernameController = TextEditingController(text: profile.name);
    emailController = TextEditingController(text: profile.email);
  } else {
    // Set default values if no profile exists
    _currentImagePath = null;
    usernameController = TextEditingController(text: '');
    emailController = TextEditingController(text: '');
  }
}


  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var iconColor = Theme.of(context).iconTheme.color;

    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
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
                                      : Image.asset(
                                          'assets/images/default.png')),
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
                                child: Icon(Icons.photo_camera,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                TextFormField(
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter your name"
                      : null,
                  controller: usernameController,
                  obscureText: false,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(color: iconColor, Icons.person),
                  ),
                  keyboardType: TextInputType.text,
                ),
                Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter your email';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: emailController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(color: iconColor, Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final profile = Profile(
                          name: usernameController.text,
                          email: emailController.text,
                          image: _currentImagePath,
                        );

                        await ProfileHiveService.saveProfile(profile);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Save"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
