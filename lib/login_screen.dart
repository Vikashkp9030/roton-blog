import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roton_task/HomeScreen.dart';
import 'package:roton_task/signup_screen.dart';
import '../models/ui_helper.dart';

class EmailLogInPage extends StatefulWidget {
  const EmailLogInPage({Key? key}) : super(key: key);
  @override
  State<EmailLogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<EmailLogInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if(email == '' || password == '' ){
      UIHelper.showAlertDialod(context, 'Incomplete Data', 'please fill all the field!');

    }else{
      logIn(email, password);
    }
  }
  void logIn(String email,String password) async{
    UserCredential? credetial;
    UIHelper.showLoadingDialog(context, 'Logging In...');
    try{
      credetial = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(ex){
      Navigator.pop(context);
      UIHelper.showAlertDialod(context,'An error occurred', ex.message.toString());
    }
    if(credetial != null){
      Get.to(const HomeScreen());
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
                  const SizedBox(height: 20,),
                  CupertinoButton(
                    onPressed:checkValues,
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Text('Log In'),
                  )

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
            'Don\'t have an account?',
            style: TextStyle(
              fontSize: 16,
            ), ),
          CupertinoButton(
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
              ),
            ),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context){
                      return const EmailSignUpPage();
                    },
                  )
              );
            },
          ),
        ],
      ),
    );
  }
}


