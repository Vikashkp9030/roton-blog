import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/ui_helper.dart';
import '../models/user_model.dart';
import 'HomeScreen.dart';
import 'login_screen.dart';


class EmailSignUpPage extends StatefulWidget {
  const EmailSignUpPage({Key? key}) : super(key: key);



  @override
  State<EmailSignUpPage> createState() => _EmailSignUpPage();
}

class _EmailSignUpPage extends State<EmailSignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  void checkValue(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();
    if(email == '' || password=='' || cPassword==''){
      UIHelper.showAlertDialod(context, 'Incomplete Data', 'please fills all the fields!');
    }else if(password!=cPassword){
      UIHelper.showAlertDialod(context, 'Password Mismatch', 'Passwords do not match!');
    }else{
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async{
    UserCredential? credential;
    UIHelper.showLoadingDialog(context, 'Create a new account');
    try{
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(ex){
      Navigator.pop(context);
      UIHelper.showAlertDialod(context, 'An error accrued', ex.code.toString());
    }
    if(credential!=null){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context){
            return HomeScreen();

      }))
     ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Roton consultancies',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),   Text(
                    'pvt ltd',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        labelText: 'Email Address'
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Password'
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: cPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Confirm Password'
                    ),
                  ),
                  const SizedBox(height: 20,),
                  CupertinoButton(
                    onPressed: checkValue,
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Text('Sign Up'),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Already have an account?',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          CupertinoButton(
            child: Text(
              'Sign In',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
              ),
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}


