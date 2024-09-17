
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final bool toHide;
  final IconData iconData;
  final TextEditingController controller;
    const CustomTextField({super.key, 
     required this.hintText,
     required this.labelText,
     required this.toHide,
     required this.iconData,
     required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isPassword=true;

  void initstate(){
    super.initState();
    isPassword = widget.toHide;
  }
  @override
  Widget build(BuildContext context) {
      return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
       obscureText: widget.toHide?isPassword:widget.toHide,
       decoration: InputDecoration(
         suffixIcon: widget.toHide?IconButton(onPressed: (){
           setState(() {
            isPassword = !isPassword;
          });
         },
          icon: Icon(isPassword?
         (widget.iconData):(FeatherIcons.eye))):Icon(widget.iconData),
         hintText: widget.hintText,
         hintStyle:const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),
         labelText: widget.labelText,
         labelStyle:const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),
         border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
       ),
       controller: widget.controller,
       validator: (value) {
       if (value!.isEmpty) {
         return 'Please enter ${widget.labelText}';
       }
      return null;
       },
                      
      ),
    );
  }
}


   //classpath "com.google.gms:google-services:4.4.1" 



   //id "com.google.gms.google-services"
    // implementation(platform("com.google.firebase:firebase-bom:32.7.3"))
    // implementation "com.google.firebase:firebase-analytics"
