import 'dart:convert';
import 'package:haloecg/models/user_model.dart';
import 'package:haloecg/service/ApiService.dart';
import 'package:haloecg/widget/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:haloecg/utils/const.dart';
import 'package:haloecg/utils/text_style.dart';
import 'package:haloecg/widget/opaque_imageHome.dart';
import 'package:haloecg/pages/Login.dart';
import 'package:haloecg/pages/page_isi_profile.dart';
import 'package:haloecg/pages/page_Isi_profil_Dokter.dart';
import 'package:haloecg/widget/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  final int role;

  const SignUp({Key key, this.role}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

final usernameController = TextEditingController();
final emailController = TextEditingController();
final passwordController = TextEditingController();
final confirmController = TextEditingController();

class _SignUpState extends State<SignUp> {
  bool _secureText = true;
  String link = "http://www.komputer-its.com/haloecg/";
  final _key = new GlobalKey<FormState>();
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      print("lengkapi profil anda");
    }
  }

  signup_() async {
    //_load.show();
    if (usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmController.text.isNotEmpty) {
      widget.role == 0
          ? Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => IsiProfil(
                  email: emailController.text,
                  username: usernameController.text,
                  password: passwordController.text,
                ),
              ),
            )
          : Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PageIsiProfileDokter(
                  username: usernameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                ),
              ),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.lightYellow,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 250,
              child: Stack(
                children: <Widget>[
                  Container(
                    //flex: 4,
                    child: Stack(
                      children: <Widget>[
                        OpaqueImageHome(
                          imageUrl: "assets/images/kardiologi.jpg",
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: widget.role == 0
                                      ? Text(
                                          "Sign Up Patient",
                                          textAlign: TextAlign.left,
                                          style: headingTextStyle,
                                        )
                                      : Text(
                                          "Sign Up Doctor",
                                          textAlign: TextAlign.left,
                                          style: headingTextStyle,
                                        ),
                                ),
                                //MyInfo(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              color: Colors.orangeAccent,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                      1.7,
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(196, 135, 198, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              )
                            ]),
                        child: Form(
                          key: _key,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextFormField(
                                  validator: (usernameController) {
                                    if (usernameController.isEmpty) {
                                      return "masukkan username";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Username",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  controller: emailController,
                                  validator: (emailController) {
                                    if (emailController.isEmpty) {
                                      return "masukkan email";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                    controller: passwordController,
                                    validator: (passwordController) {
                                      if (passwordController.isEmpty) {
                                        return "masukkan password";
                                      } else {
                                        return null;
                                      }
                                    },
                                    obscureText: _secureText,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      suffixIcon: IconButton(
                                        onPressed: showHide,
                                        icon: Icon(_secureText
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  controller: confirmController,
                                  validator: (confirmController) {
                                    if (confirmController.isEmpty) {
                                      return "masukkan konfirmasi password";
                                    } else {
                                      return null;
                                    }
                                  },
                                  obscureText: _secureText,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Konfirmasi Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    suffixIcon: IconButton(
                                      onPressed: showHide,
                                      icon: Icon(_secureText
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      check();
                      signup_();
                    },
                    child: FadeAnimation(
                      1.9,
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 60),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.deepOrange
                            //Color.fromRGBO(49, 39, 79, 1),
                            ),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    child: FadeAnimation(
                      2,
                      Center(
                        child: Text(
                          "Back",
                          style:
                              TextStyle(color: Color.fromRGBO(49, 39, 79, .6)),
                        ),
                      ),
                    ),
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
