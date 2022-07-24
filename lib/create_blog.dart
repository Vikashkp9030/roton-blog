import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roton_task/services/crud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:image_cropper/image_cropper.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descTextEditingController = TextEditingController();
  TextEditingController authorTextEditingController = TextEditingController();
   CrudMethods crudMethods =CrudMethods();

  File? imageFile;

  bool _isLoading = false;

  void selectImage(ImageSource source) async{
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if(pickedFile!=null){
      croImage(pickedFile);
    }
  }
  void croImage(XFile file) async{
    File? cropedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 15,
    );
    if(cropedImage!=null){
      setState(() {
        imageFile = cropedImage;
      });
    }
  }

  void showPhotoOptions(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text('Upload Profile Picture!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: (){
                Navigator.pop(context);
                selectImage(ImageSource.gallery);
              },
              leading: const Icon(Icons.photo_album),
              title: const Text('Select from gallery'),
            ),
            ListTile(
              onTap: (){
                Navigator.pop(context);
                selectImage(ImageSource.camera);
              },
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
            ),
          ],
        ),
      );
    }
    );
  }


  Future<void> uploadBlog() async {
    if (imageFile != null) {

      setState(() {
        _isLoading = true;
      });
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");

      final UploadTask task = firebaseStorageRef.putFile(imageFile!);

      var imageUrl;
      await task.whenComplete(() async {
        try {
          imageUrl = await firebaseStorageRef.getDownloadURL();
        } catch (onError) {
          print("Error");
        }

        print(imageUrl);
      });

      // print(downloadUrl);

      Map<String, dynamic> blogData = {
        "imgUrl": imageUrl,
        "author": authorTextEditingController.text,
        "title": titleTextEditingController.text,
        "desc": descTextEditingController.text
      };

      crudMethods.addData(blogData).then((value) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      });

      // upload the blog info
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              "Flutter Blog",
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
               uploadBlog();
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.file_upload)),
          )
        ],
      ),
      body:_isLoading
          ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ) :Container(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  showPhotoOptions();
                },
                child: (imageFile != null) ? Container(
                       margin: const EdgeInsets.symmetric(horizontal: 16),
                       height: 150,
                       width: MediaQuery.of(context).size.width,
                       child: ClipRRect(
                           borderRadius: BorderRadius.circular(6),
                           child: Image.file(imageFile!,fit: BoxFit.cover,)),
                    ) : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 170,
                      decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(6)),
                      width: MediaQuery.of(context).size.width,
                      child: const Icon(
                     Icons.add_a_photo,
                     color: Colors.black45,
                  ),
                )),
            const SizedBox(
              height: 8,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: titleTextEditingController,
                    decoration: InputDecoration(hintText: "enter title"),
                  ),
                  TextField(
                    controller: descTextEditingController,
                    decoration: InputDecoration(hintText: "enter desc"),
                  ),
                  TextField(
                    controller: authorTextEditingController,
                    decoration:
                    InputDecoration(hintText: "enter author name"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
