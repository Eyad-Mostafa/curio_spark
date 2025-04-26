
import 'package:curio_spark/constants/colors.dart';
import 'package:curio_spark/screens/settings.dart';
import 'package:curio_spark/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
  
  @override
  void initState() {
    super.initState();
    var box = Hive.box('profileBox');
    String oldImagePath = box.get('profileImage', defaultValue: '');
    usernameController = TextEditingController(text: box.get('name', defaultValue: ''));
    emailController = TextEditingController(text: box.get('email', defaultValue: ''));
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var box = Hive.box('profileBox');
    final themeProvider = Provider.of<ThemeProvider>(context);
    var iconColor = Theme.of(context).iconTheme.color;

    return Scaffold(
            appBar: AppBar(
          title: Text("Edit Profile"),),
        body:Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: 
                Column(
                children: [  
                  Container(
                  padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 120, height: 120,
                              child:ClipRRect(borderRadius: BorderRadius.circular(100), child: Image(image: AssetImage(tProfileImage)),)
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 35, height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: editIcon,
                                ),
                        child: Icon(
                          Icons.photo_camera, 
                          color: Colors.black,),
                      ),
                    )
                  ],
                ),
              SizedBox(height: 40,),
              ],
            ),
          ),              
                  Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                  TextFormField(
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Please enter your name";
                      }
                      return null;
                    },
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
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } 
                      else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: emailController,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: "Email",                    
                      prefixIcon: Icon(color:iconColor, Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(onPressed: (){
                      if (_formKey.currentState!.validate()){
                        box.put('name', usernameController.text);
                        box.put('email', emailController.text);
                        Navigator.pop(context);
                    }
                    },
                    child: Text("Save",),
                    ),
                  ),
                ],
                )
              )
            )
          )
        );
  }
}
