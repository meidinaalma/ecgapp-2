import 'package:haloecg/models/user_model.dart';
import 'package:haloecg/service/ApiService.dart';
import 'package:haloecg/widget/FadeAnimation.dart';
import 'package:haloecg/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:haloecg/utils/const.dart';
import 'package:haloecg/utils/text_style.dart';
import 'package:haloecg/widget/my_button.dart';
import 'package:haloecg/widget/opaque_imageHome.dart';
import 'package:haloecg/pages/SignUp.dart';
import 'package:haloecg/pages/HomePasien.dart';
import 'package:haloecg/global_var.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haloecg/widget/pilihan_signUp.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { offline, online }

class _LoginState extends State<Login> {
  Loading _load;
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  final email = TextEditingController();
  final pass = TextEditingController();
  final _key = new GlobalKey<FormState>();
  check() async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      _load.show();
      UserModel pasienModel = await ApiService().login(email.text, pass.text);
      _load.hide();
      if (pasienModel.value == '1') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) {
            return HomePasien(user: pasienModel);
          }),
        );
      } else {
        Fluttertoast.showToast(msg: "login gagal");
      }
    }
  }

  Future<void> pilihan_signup() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, //user must tap a button!
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.fromLTRB(50, 250, 50, 250),
          color: Colors.white,
          child: PilihanSignUp(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _load = Loading(context: context);
    return Scaffold(
      backgroundColor: Constants.lightYellow,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 300,
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
                                  child: Text(
                                    "Login",
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
              height: 100,
              color: Colors.orangeAccent,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
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
                          ],
                        ),
                        child: Form(
                          key: _key,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: email,
                                  validator: (email) {
                                    if (email.isEmpty) {
                                      return "masukkan Email";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  controller: pass,
                                  validator: (pass) {
                                    if (pass.isEmpty) {
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
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        check();
                      },
                      child: FadeAnimation(
                        1.9,
                        MyButton(text: "Login"),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        pilihan_signup();
                      },
                      child: FadeAnimation(
                        2,
                        Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                color: Color.fromRGBO(49, 39, 79, .6)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
