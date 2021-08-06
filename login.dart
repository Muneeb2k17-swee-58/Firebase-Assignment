import 'package:card/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  // ignore: override_on_non_overriding_member
  final bool _hidden = true;

  get arguments => null;
  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void login() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;
      final String email = emailController.text;
      final String password = passwordController.text;

      try {
        final UserCredential user = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        final DocumentSnapshot snapshot =
            await db.collection('users').doc(user.user!.uid).get();

        // ignore: unused_local_variable
        final data = snapshot.data();
        Navigator.of(context).pushNamed("/home", arguments: data);
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('${e}'),
              );
            });
        // print(e);
      }
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Login'),
          backgroundColor: Colors.blueGrey[800],
        ),
        body: SafeArea(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // ignore: prefer_const_constructors
          Image(
            // ignore: prefer_const_constructors
            image: NetworkImage(
              'https://i2.wp.com/blog.viral-launch.com/wp-content/uploads/2018/08/2000px-Apple_logo_black.svg_.png?fit=2000%2C2000&ssl=1',
            ),
            height: 100,
            width: 200,
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Username or Email',
                hintText: 'Enter Your Email or Username'),
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Password',
                hintText: 'Enter Your Password'),
            obscureText: _hidden,
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: login,
            child: const Text('Login'),
            style: ElevatedButton.styleFrom(
              primary: Colors.teal,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            child: Text('Dont have an account?'),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    // ignore: prefer_const_constructors
                    MaterialPageRoute(builder: (context) => Register()));
              },
              child: const Text('Signup'),
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
              )),
        ])));
  }
}
