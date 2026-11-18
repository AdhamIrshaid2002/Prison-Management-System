import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:police/auth/signup.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> ff = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
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
                      " انشاء حساب",
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
                    controller: username,
                    decoration: InputDecoration(
                      hintText: "اسم المستخدم ",
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
                    controller: email,
                    decoration: InputDecoration(
                      hintText: " البريد الاكتروني ",
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
                          .createUserWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );
                      Navigator.pushReplacementNamed(context, 'home');
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'خطأ',
                          desc: ' كلمة المرور المقدمة ضعيفة للغاية',
                        ).show();
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'خطأ',
                          desc: ' الحساب موجود بالفعل لهذا البريد الإلكتروني.',
                        ).show();
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                },

                child: Text("انشاء حساب"),
                color: Color.fromARGB(255, 5, 102, 181),
                textColor: Colors.white,
              ),

              Container(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
