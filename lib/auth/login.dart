import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:police/auth/login.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> ff = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isHidden = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: ff,
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      height: 200,
                      width: 200,
                      child: Image.asset(
                        "images/pp.jpeg",
                        height: 60,
                        width: 60,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(70),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "الشرطة الفلسطينية",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 5, 102, 181),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "palestinian police",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 5, 102, 181),
                      ),
                    ),
                  ),
                  Container(height: 40),
                  Center(
                    child: Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(height: 10),

                  Container(height: 40),

                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "الحقل فارغ";
                      }
                    },
                    controller: email,
                    decoration: InputDecoration(
                      hintText: "البريد الاكتروني",
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),

                  Container(height: 20),

                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "الحقل فارغ";
                      }
                    },
                    controller: password,
                    obscureText: _isHidden,

                    decoration: InputDecoration(
                      hintText: " كلمة المرور",
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 10,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isHidden ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isHidden = !_isHidden;
                          });
                        },
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  Container(height: 40),
                ],
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(20),
                ),
                onPressed: () async {
                  if (ff.currentState!.validate()) {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );
                      Navigator.pushReplacementNamed(context, 'home');
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-credential') {
                        print(
                          '------------------------Wrong password provided for that user. ${e.code}',
                        );
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'خطأ',
                          desc:
                              'البريد الإلكتروني غير موجوداو كلمة المرور خاطئة',
                        ).show();
                      } else if (e.code == 'too-many-requests') {
                        print(
                          '------------------------Wrong password provided for that user. ${e.code}',
                        );
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'خطأ',
                          desc: 'كلمة المرور خاطئة',
                        ).show();
                      }
                    }
                  }
                },
                child: Text("تسجيل الدخول"),
                color: Color.fromARGB(255, 5, 102, 181),
                textColor: Colors.white,
              ),

              Container(height: 20),

              MaterialButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'signup'),
                color: Colors.white,
                child: Text(
                  "لا تملك حسابا؟",
                  style: TextStyle(color: Color.fromARGB(255, 5, 102, 181)),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    title: 'Error',
                    desc: 'No user found for that email.',
                  ).show();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
