import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:roton_task/login_screen.dart';
import 'package:roton_task/create_blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roton_task/update.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Blog App"),
          actions: [
              IconButton(onPressed: ()async{
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context){
              return const EmailLogInPage();
              }
             )
             );
            },
            icon:const Icon(Icons.logout))
           ],
           ),
           body:SingleChildScrollView(
            child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('blogs').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasData){
                    final snap = snapshot.data!.docs;
                    return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snap.length,
                        itemBuilder: (context , index){
                          return Container(
                            margin: const EdgeInsets.only(bottom: 24, right: 16, left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  child: Image.network(
                                    snap[index]['imgUrl'],
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                    height: 200,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snap[index]['title']
                                         ,
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                        const SizedBox(height: 2),
                                        SizedBox(
                                          width:250,
                                          child: Text(
                                              '${snap[index]['desc']}',
                                               style: const TextStyle(fontSize: 14),
                                            ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'by-${snap[index]['author']}',
                                          style: const TextStyle(fontSize: 14,color: Colors.black54),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                            onPressed: () async{
                                              var collectionReference = FirebaseFirestore.instance.collection('blogs');
                                              await collectionReference.doc('${snap[index].id}').delete();
                                              setState((){});
                                            },
                                            icon:const Icon(Icons.delete)
                                        ),
                                        IconButton(
                                            onPressed: ()async{
                                              var collectionReference = FirebaseFirestore.instance.collection('blogs');
                                              Get.to(UpdateBlog(snap[index] , collectionReference));
                                            },
                                            icon:const Icon(Icons.edit_note)
                                        ),
                                      ],
                                    ),
                                  ],
                                ),


                              ],
                            ),
                          );
                        }
                    );
                  }else{
                    return SizedBox();
                  }
                },
              ),
            ],
            )
        ),
        floatingActionButton: Container(
           padding: const EdgeInsets.only(left: 30,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CupertinoButton(
                onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateBlog()));
                   },
                  color: Theme.of(context).colorScheme.secondary,
                  child: const Text('Create Blog',style: TextStyle(fontSize: 21),),
                ),
              ],
            ),
          ),
      ),
    );
  }
}

