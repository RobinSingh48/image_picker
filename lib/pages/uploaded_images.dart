

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imagepicker/pages/fullsize_images.dart';

class UploadedImages extends StatefulWidget {
  const UploadedImages({Key? key}) : super(key: key);

  @override
  State<UploadedImages> createState() => _UploadedImagesState();
}

class _UploadedImagesState extends State<UploadedImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Uploaded Images",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.white),),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            Center(
              child: Text("Click on Image for FullScreen Mode",style: TextStyle(backgroundColor: Colors.redAccent,fontWeight: FontWeight.bold,color: Colors.white,),),
            ),
            StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("SendImages").snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }else if(snapshot.connectionState == ConnectionState.active){
                if(snapshot.hasData || snapshot.data!=null){
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 350),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String,dynamic> userData = snapshot.data!.docs[index].data() as Map<String,dynamic>;


                        return Card(
                          child: IconButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>FullSizeImages(userData: userData)));
                            },
                            icon: Image(image: NetworkImage(userData["finalImage"]),),
                          )
                        );
                      },
                    ),
                  );
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ]
        ),
      ),
    );
  }
}
