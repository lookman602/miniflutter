import 'package:firebasedemo/screens/authen.dart';
import 'package:firebasedemo/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class Login extends StatefulWidget {
  final String title;
  const Login({Key key, this.title}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 150.0,
        title: Text("Login"),
        
      ),
body: Container(
      decoration: BoxDecoration(
            // color: Color.fromRGBO(15, 76, 129, 1),
            gradient: LinearGradient(
              colors: [ 
                Colors.redAccent,
                Colors.yellow[300],
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top:300),),
                  GoogleSignInButton(
                    onPressed: () => signInwithGoogle().then((value){
                      if(value!=null){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Homepage(),),
                        (route) => false);
                      }
                    }), 
                    ), 
                ],
              ),
            ],
          ),
        ),
      );
  }
}