import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:milanproject/agora/firebaseDB/auth.dart';
import 'package:milanproject/agora/screen/forgotPassword.dart';
import 'package:milanproject/agora/screen/regScreen.dart';
import 'package:milanproject/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  bool passwordVisible = false;
  var submitted = false;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool boolEmail = false;
  bool boolPass = false;

  void _submit() async {
    setState(() {
      submitted = true;
    });
    final pass = _passController.text.toString().trim();
    final email = _emailController.text.toString().trim();
    var user = await loginFirebase(email, pass);
    switch (user) {
      case -1:
        invalidPass();
        setState(() {
          submitted = false;
        });
        break;
      case -2:
      case -3:
        invalidEmail();
        setState(() {
          submitted = false;
        });
        break;
      case 1:
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('login', true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(setEmail);
    _passController.addListener(setPass);
  }

  void setEmail() {
    if (_emailController.text.toString().trim() == '') {
      setState(() {
        boolEmail = false;
      });
    } else
      setState(() {
        boolEmail = true;
      });
  }

  void setPass() {
    print(_passController.text.toString().trim());
    if (_passController.text.toString().trim() == '') {
      setState(() {
        boolPass = false;
      });
    } else
      setState(() {
        boolPass = true;
      });
  }

  void invalidEmail() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[800],
              ),
              height: 190,
              child: Column(
                children: [
                  Container(
                    height: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Text(
                            'Incorrect Email',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 25, top: 15),
                          child: Text(
                            "The email you entered doesn't appear to belong to an account. Please check your email and try again",
                            style: TextStyle(color: Colors.white60),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 0,
                    height: 0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Try Again',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void invalidPass() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[800],
              ),
              height: 170,
              child: Column(
                children: [
                  Container(
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Text(
                            'Incorrect Password',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 25, top: 15),
                          child: Text(
                            'The password you entered is incorrect. Please try again.',
                            style: TextStyle(color: Colors.white60),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 0,
                    height: 0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Try Again',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 45,
              child: Column(
                children: [
                  SafeArea(
                    child: ListTile(
                      contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios_rounded),
                        color: Colors.amber,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 40.0),
                          child: Image.asset(
                            'assets/images/lightlogo.png',
                            height: 330.0,
                            width: 330.0,
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 5.0,
                              ),
                              child: TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(color: Colors.black),
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  hintText: 'Email Address',
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 5.0,
                              ),
                              child: TextField(
                                onChanged: (text) {
                                  if (text.length == 0) {
                                    boolPass = false;
                                  } else
                                    boolPass = true;
                                },
                                controller: _passController,
                                obscureText: !passwordVisible,
                                style: TextStyle(color: Colors.black),
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: passwordVisible
                                          ? Colors.amber
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: GestureDetector(
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPasswordScreen()));
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                onPressed:
                                    (boolPass == true && boolEmail == true)
                                        ? _submit
                                        : null,
                                color: Colors.amber,
                                disabledColor: Colors.amber[800],
                                disabledTextColor: Colors.white60,
                                textColor: Colors.white,
                                padding: EdgeInsets.all(15.0),
                                child: submitted
                                    ? SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Text(
                                        'Log In',
                                        style: TextStyle(fontSize: 13.0),
                                      ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            dontHaveAccount(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(context,
            //           MaterialPageRoute(builder: (context) => RegScreen()));
            // },
            //   child: Container(
            //     height: 40,
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: <Widget>[
            //         Divider(
            //           color: Colors.white,
            //           height: 0,
            //         ),
            //         SizedBox(height: 15),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: <Widget>[
            //             Text(
            //               "Don't have an account? ",
            //               style: TextStyle(color: Colors.amber, fontSize: 11),
            //             ),
            //             Text(
            //               'Sign Up.',
            //               style: TextStyle(
            //                   color: Colors.amber,
            //                   fontSize: 11,
            //                   fontWeight: FontWeight.bold),
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget dontHaveAccount() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Don\'t have account?  ',
          style: TextStyle(color: Colors.black, fontSize: 14),
          children: <TextSpan>[
            TextSpan(
              text: 'Sign Up.',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegScreen()));
                },
            ),
          ],
        ),
      ),
    );
  }
}
