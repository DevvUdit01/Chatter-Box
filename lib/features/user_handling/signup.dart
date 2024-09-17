
// ignore_for_file: use_build_context_synchronously

import 'package:chatter_box/core/models/UserModal.dart';
import 'package:chatter_box/features/completeProfile.dart';
import 'package:chatter_box/features/user_handling/signin.dart';
import 'package:chatter_box/helper/UiHelper.dart';
import 'package:chatter_box/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// ignore: must_be_immutable
class SignUP extends StatelessWidget{
  SignUP({super.key});
    final _formKey=GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController(); 
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _cpasswordController = TextEditingController();

    void checkValues(BuildContext context){
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String cpassword = _cpasswordController.text.trim();
      bool isValidate = _formKey.currentState!.validate();
      
      if(!isValidate){
        return ;
      }
      else if(password != cpassword){
       UiHelper.showAlertDialog(context,"Password Mismatch","passwords do not match! " );
      }
      else{
        signup(email, password,context);
      }

    }

    void signup(String email,String password,BuildContext context) async {
    UserCredential? credential;
    UiHelper.showLoadingDialog(context,"Creating new account..");
     try{
          credential = await FirebaseAuth.instance.
          createUserWithEmailAndPassword(email: email, password: password);
     } on FirebaseAuthException catch(ex){
       Navigator.pop(context);
       UiHelper.showAlertDialog(context,"An error occured",ex.code.toString());
     }
     if(credential!=null){
     // Navigator.pop(context);
      String uid =credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilepic: "",
      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value){
      ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('New User Created!, processing data...')),);
         Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>
        CompleteProfile(userModel: newUser, firebaseUser: credential!.user!),
        ));
      });
      }
    
    }

  @override
  Widget build(BuildContext context){
    return GestureDetector(
       onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("SignUp page"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
              child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 SizedBox(
                  height: 240,
                  width: 500,
                  child: Image.asset("assets/images/Signup.jpeg")),
                  const Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 5),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Text("Register",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                     ],
                   ),
                 ),
                 const Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 5),
                     child: Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Enter your personal information",style: TextStyle(fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),             
                 CustomTextField(hintText: 'Enter your Email', labelText: 'Email', toHide: false, iconData: FeatherIcons.mail, controller: _emailController), 
                 CustomTextField(hintText: 'Enter your Password', labelText: 'Password', toHide: true, iconData: FeatherIcons.eyeOff, controller: _passwordController), 
                 CustomTextField(hintText: 'Enter your Conform password', labelText: 'Conform password', toHide: true, iconData: FeatherIcons.eyeOff, controller: _cpasswordController), 
                
                 const SizedBox(height: 20,),
                 Center(
                 child: SizedBox(
                   height: 50,
                   width: MediaQuery.of(context).size.width-80,
                   child: ElevatedButton(
                     onPressed: (){
                    checkValues(context);
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.blue,
                     ),
                     child: const Text('Register',style:TextStyle(color: Colors.white,fontSize: 20),),
                   ),
                 ),
               ),
               
                   const  Padding(
                   padding:  EdgeInsets.all(8.0),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Divider(thickness: 2,)),
                      Text("   or   ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                     Expanded(child: Divider(thickness: 2,)),
                    ],
                  ),
            
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ",style:TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                    InkWell(child: const Text("Login",style: TextStyle(color: Colors.blue),),
                    onTap: (){
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignIn()));
                    },
                    ),
                  ],
                ),
                const SizedBox(height: 10,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}