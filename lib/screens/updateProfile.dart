
import 'package:curio_spark/constants/colors.dart';
import 'package:curio_spark/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});
  
  TextEditingController usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    var iconColor = isDark? dIColor: lIColor;

    return Scaffold(
            appBar: AppBar(
          title: Text("Edit Profile", style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          )),
        actions: [IconButton(
          onPressed: () => themeProvider.toggleTheme(), 
          icon: Icon(isDark? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          )],
        ),
        body:Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                  color: tPrimary,
                                ),
                        child: Icon(
                          LineAwesomeIcons.camera, 
                          color: Colors.black,),
                      ),
                    )
                  ],
                ),
              SizedBox(height: 40,),
              ],
            ),
          ),              
                  /////////////////userName//////////////
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
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: tFColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color:tFColor,
                        )
                      ),
                      labelText: "Username",
                      labelStyle: TextStyle(fontSize: 14,color:tFColor),
                      prefixIcon: Icon(color: iconColor, Icons.person),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  // SizedBox(height: 20,),

                  //////////////////email///////////////////
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

                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: tFColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color:tFColor,
                        )
                      ),
                      labelText: "Email",
                      labelStyle: TextStyle(fontSize: 14,color:tFColor),
                      prefixIcon: Icon(color: iconColor, Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  // SizedBox(height: 20,),

                  /////////////////password/////////////////////
                  Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                      return 'Password must be longer than 6 characters';
                      }
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return 'Uppercase letter is missing';
                      }
                      if (!value.contains(RegExp(r'[a-z]'))) {
                      return 'Lowercase letter is missing';
                      }
                      if (!value.contains(RegExp(r'[0-9]'))) {
                      return 'Digit is missing';
                      }
                      if (!value.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
                      return 'Special character is missing';
                      }
                      return null;
                    },

                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "password",
                      labelStyle: TextStyle(fontSize: 14,color:tFColor),
                      prefixIcon: Icon(color: iconColor, Icons.lock),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: tFColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color:tFColor,
                        )
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),

                  Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(onPressed: (){
                      if (_formKey.currentState!.validate()){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateProfileScreen(
                        // userName: usernameController.text,
                      ))).then((value)=>usernameController.clear());
                    }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgButton, side: BorderSide.none, shape: StadiumBorder(),
                      ),
                    child: Text("Edit",
                    style: TextStyle(
                      color: tBColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                    ///////////////we need change fontFamily/////////////
                    ),
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

