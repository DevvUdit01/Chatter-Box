
import 'dart:io';
import 'package:chatter_box/core/models/UserModal.dart';
import 'package:chatter_box/features/HomePage.dart';
import 'package:chatter_box/helper/UiHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const CompleteProfile({super.key,required this.userModel,required this.firebaseUser});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  TextEditingController fullnameController = TextEditingController();
  File? imageFile;

  void checkValues() {
    String fullname = fullnameController.text.trim();

    if (fullname.isEmpty || imageFile == null) {
      UiHelper.showAlertDialog(context, "Incomplete Data", "Please fill all the fields and upload a profile picture");
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    try {
      UiHelper.showLoadingDialog(context, "Uploading image...");

      // Ensure imageFile is not null before attempting upload
      if (imageFile == null) {
        throw Exception("No image selected");
      }
     
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("profilepictures")
          .child(widget.userModel.uid.toString())
          .putFile(imageFile!);

      TaskSnapshot snapshot = await uploadTask;

      String imageUrl = await snapshot.ref.getDownloadURL();
      String fullname = fullnameController.text.trim();

      widget.userModel.fullname = fullname;
      widget.userModel.profilepic = imageUrl;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userModel.uid)
          .set(widget.userModel.toMap())
          .then((value) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userModel: widget.userModel,
              firebaseUser: widget.firebaseUser,
            ),
          ),
        );
      });
    } catch (e) {
      Navigator.pop(context);  // Close the loading dialog
      UiHelper.showAlertDialog(context, "Error", "An error occurred while uploading data: ${e.toString()}");
    }
  }

  void selectImage(ImageSource source) async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        cropImage(pickedFile);
      } else {
        UiHelper.showAlertDialog(context, "No Image Selected", "Please select an image to upload.");
      }
    } catch (e) {
      UiHelper.showAlertDialog(context, "Error", "An error occurred while selecting image: ${e.toString()}");
    }
  }

  void cropImage(XFile file) async {
    try {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20,
      );

      if (croppedImage != null) {
        setState(() {
          imageFile = File(croppedImage.path);
        });
      } else {
        UiHelper.showAlertDialog(context, "Cropping Cancelled", "Image cropping was cancelled.");
      }
    } catch (e) {
      UiHelper.showAlertDialog(context, "Error", "An error occurred while cropping the image: ${e.toString()}");
    }
  }

  void showPhotoOption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Upload Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                title: const Text('Select From Gallery'),
                leading: const Icon(Icons.photo_album),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                title: const Text('Take a Photo'),
                leading: const Icon(Icons.camera_alt),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              CupertinoButton(
                onPressed: () {
                  showPhotoOption();
                },
                padding: const EdgeInsets.all(0),
                child: CircleAvatar(
                  backgroundImage: (imageFile != null) ? FileImage(imageFile!) : null,
                  radius: 60,
                  child: (imageFile == null) ? const Icon(Icons.person, size: 60) : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: fullnameController,
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  labelText: 'Full Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                onPressed: () {
                  checkValues();
                },
                color: Theme.of(context).colorScheme.secondary,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
