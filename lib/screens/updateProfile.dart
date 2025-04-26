
import 'package:curio_spark/constants/colors.dart';
import 'package:curio_spark/screens/settings.dart';
import 'package:curio_spark/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const List<String> list = ["Male", "Female"];

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});
  
  TextEditingController usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
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
                        Navigator.pop(context);
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingsScreen(
                        // userName: usernameController.text,
                     // ))).then((value)=>usernameController.clear());
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

class DropdownBtn extends StatefulWidget {
  const DropdownBtn({super.key});

  @override
  State<DropdownBtn> createState() => _DropdownBtnState();
}

class _DropdownBtnState extends State<DropdownBtn> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
  ),
    child:  DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      elevation: 16,
      style: Theme.of(context).textTheme.bodyLarge, 
      underline: Container(height: 2,),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items:
          list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
      )
    );
  }
}


