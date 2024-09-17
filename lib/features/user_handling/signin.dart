
// ignore_for_file: use_build_context_synchronously

import 'package:chatter_box/core/models/UserModal.dart';
import 'package:chatter_box/features/HomePage.dart';
import 'package:chatter_box/features/user_handling/signup.dart';
import 'package:chatter_box/helper/UiHelper.dart';
import 'package:chatter_box/helper/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';


class SignIn extends StatefulWidget {

  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

 final TextEditingController _passwordController = TextEditingController();
 final  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    void login(String email,String password) async{
    UserCredential? credential;
   
    UiHelper.showLoadingDialog(context, "loading...");

    try{
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword
      (email:email,password: password);
    } on FirebaseAuthException catch(ex){
      Navigator.pop(context);
      UiHelper.showAlertDialog(context,"An error occured",ex.code.toString());
     
    }

    if(credential != null){
      String uid= credential.user!.uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance.
      collection('users').doc(uid).get();
      UserModel? userModel = UserModel.fromMap(userData.data() as
      Map<String, dynamic>);
      // go to home page
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
      HomePage(userModel: userModel, firebaseUser: credential!.user)));
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Form is valid, processing data...')),);
    }
  }
    
   void  checkValues(){
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    bool isValidate =_formKey.currentState!.validate();
    if(!isValidate){
    return ;
    }

    else{
      login(email,password);
    }
  }
    return GestureDetector(
       onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title:const Text('Chat App'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  SizedBox(
                    height: 240,
                    width: 500,
                    child: Image.asset("assets/images/login_image.jpeg",
                    ),
                  ),
                 const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       Column(
                        crossAxisAlignment:CrossAxisAlignment.start,
                        children: [
                          Text("Login",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Text("Login to continue the app",style: TextStyle(fontSize: 15),),
                        ],
                      ),
                    ],
                  ),
                
                CustomTextField(hintText: 'Enter your Email', labelText: 'Email', toHide: false, iconData: FeatherIcons.mail, controller: _emailController), 
                CustomTextField(hintText: 'Enter your Password', labelText: 'Password', toHide: true, iconData: FeatherIcons.eyeOff, controller: _passwordController), 
                
                const  SizedBox(height: 20,),
                  
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width-20,
                      child: ElevatedButton(
                        onPressed: (){
                          checkValues();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Login',style:TextStyle(color: Colors.white,fontSize: 20),),
                      ),
                    ),
                  ),
                const SizedBox(height: 20,),
            
                const  Row(
                    children: [
                      Expanded(child: Divider(
                        thickness: 2,
                      )),
                      Text("   or   ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                     Expanded(child: Divider(
                      thickness: 2,
                     )),
                    ],
                  ),
                 const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ",style:TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                      InkWell(child: const Text("New User",style: TextStyle(color: Colors.blue),),
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUP()));
                      },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}