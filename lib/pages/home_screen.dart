import 'dart:async';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:imagepicker/pages/login_screen.dart';
import 'package:imagepicker/pages/uploaded_images.dart';
import 'package:uuid/uuid.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? finalImage;
 String? uploadPercantage;


  void selectImage() async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      File fileImage = File(selectedImage.path);

      setState(() {
        finalImage = fileImage;
      });
    }
  }



  uploadImage() async {
    if (finalImage != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("Images")
          .child(Uuid().v1())
          .putFile(finalImage!);

     StreamSubscription streamSubscription =   uploadTask.snapshotEvents.listen((event) {

          final percantage = event.bytesTransferred/event.totalBytes*100;
           uploadPercantage = percantage.toStringAsFixed(2);

        });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      streamSubscription.cancel();

      FirebaseFirestore.instance
          .collection("SendImages")
          .add({"finalImage": downloadUrl});
    }
    setState(() {
      finalImage = null;

    });




    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ImageUpload Successfully"),));
    Fluttertoast.showToast(msg: "ImageUpload Successfully",gravity: ToastGravity.TOP,backgroundColor: Colors.redAccent,fontSize: 18,textColor: Colors.white);

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "HomeScreen",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
        ),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Center(
            child: Column(
              children: [
                Container(
                  child: CircleAvatar(
                    backgroundImage:
                        (finalImage != null) ? FileImage(finalImage!) : null,
                    backgroundColor: Colors.transparent,
                    radius: 100,
                  ),
                ),


                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      selectImage();
                    },
                    child: Text(
                      "Select Image",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                (finalImage?.path != null)
                    ? Text(finalImage!.path.toUpperCase())
                    : Text("no image selected"),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.redAccent)),
                    onPressed: () {
                      uploadImage();
                    },
                    child: Text("Upload Image",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(80, 50))),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadedImages()));
                    },
                    child: Text(
                      "Uploaded Images",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
