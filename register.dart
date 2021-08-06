import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    final bool _hidden = true;

    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController cpasswordController = TextEditingController();

    void register() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;
      final String username = usernameController.text;
      final String email = emailController.text;
      final String password = passwordController.text;
      final String cpassword = cpasswordController.text;

      try {
        final UserCredential user = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        db
            .collection('users')
            .doc(user.user!.uid)
            .set({'email': email, 'username': username});
        print('user is registered');
      } catch (e) {
        print('error');
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Register Here'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              const Image(
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
                controller: usernameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Username',
                    hintText: 'Enter Your Username'),
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
                    labelText: 'Email',
                    hintText: 'Enter Your Email'),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: passwordController,
                obscureText: _hidden,
                decoration: InputDecoration(
                    focusColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Password',
                    hintText: 'Enter Your Password'),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: cpasswordController,
                obscureText: _hidden,
                decoration: InputDecoration(
                    focusColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Confirm Password',
                    hintText: 'Confirm Your Password'),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: register,
                child: const Text('Register'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                child: Text('Already have an account'),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        // ignore: prefer_const_constructors
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
