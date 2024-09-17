

import 'package:flutter/material.dart';

class UiHelper {

  static void showLoadingDialog(BuildContext context,String title){
    AlertDialog loadingDialog = AlertDialog(
      content: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          const CircularProgressIndicator(),
         const SizedBox(height: 25,),
            Text(title),
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
       builder:(context){
      return loadingDialog;
    });
  }

  static void showAlertDialog(BuildContext context,String title,String content){
    AlertDialog alertDialog = AlertDialog(
     title: Text(title),
     content: Text(content),
     actions: [
      TextButton(onPressed: (){
        Navigator.pop(context);
      }, child:const Text("Ok"))
     ],
    );
    showDialog(context: context, builder:(context){
      return alertDialog;
    });
  }
}