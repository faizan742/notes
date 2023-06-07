import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/VERFICATION_Screen.dart';
import 'ults/New_Routes.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ults/error.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  var isChecked = false;
  String _email = "";
  String _password="";
  bool  loading = false;
  FirebaseAuth _auth =  FirebaseAuth.instance;

  var isEmailverfication =false;
  movetoHome(BuildContext context) async
  {
    setState(() {
        loading = true;
    });
    if(_formkey.currentState !=null ) {
      if (_formkey.currentState!.validate()) {
        _auth.signInWithEmailAndPassword(email: _email, password: _password).then((value) {
          //await Future.delayed(Duration(seconds: 1));
          Navigator.pushNamed(context, Routes.home);
          setState(() {
            loading = false;
          });
        }).onError((error, stackTrace){
          errorMessage().loadError(error.toString());
          setState(() {
            loading = false;
          });
        });


      }
    }
  }
  movetoSign_up(BuildContext context) async
  {
    if(_formkey.currentState !=null ) {

        await Future.delayed(Duration(seconds: 1));
        Navigator.pushNamed(context, Routes.Sign);

    }
  }
  @override
  void initState() {
    isEmailverfication=_auth.currentUser!.emailVerified;
    super.initState();
  }
  @override
  Widget build(BuildContext context) => isEmailverfication==true ? V_Screen() : WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },
      child: Center(

            child: Container(
              height: 500,
              child: Card(
                shadowColor: Colors.amber,
                color: Colors.blueGrey,
                borderOnForeground: true,
                child: Form(

                  key: _formkey,
                  child: Column(

                    children: [
                           const Center (
                             child: Text("Login ",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                           ),
                      SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Gave Email",
                            labelText:"Enter Your Email Here" ,
                            prefixIcon: Icon(Icons.alternate_email_rounded),

                          ),
                          validator:(value){
                            if(value!.isEmpty || EmailValidator.validate(value)==false)
                            {
                              return "Plz Enter the Valid Email";
                            }
                            else
                            {
                              return null;
                            }

                          },
                          onChanged: (value){
                            _email=value;
                            setState(() {});
                          },


                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText:true,
                          decoration: const InputDecoration(
                            hintText: "Enter Password",
                            labelText:"Enter Your Password" ,
                            prefixIcon: Icon(Icons.password),

                          ),
                          validator:(value){
                            if(value!.isEmpty )
                            {
                              return "Plz Enter the  Password";
                            }
                            else
                            {
                              return null;
                            }

                          },
                          onChanged: (value){
                            _password=value;
                            setState(() {});
                          },


                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [

                          Checkbox(value: isChecked, onChanged:(bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          }
                          ),
                          Text("Remember me"),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                        crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                        children: [
                          ElevatedButton( style: ElevatedButton.styleFrom(foregroundColor: Colors.white,
                              backgroundColor: Colors.green,minimumSize: Size(150,40) ,shape:  RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                              onPressed:()=> movetoHome(context), child: loading == false ? Text("Login"): Center(
                              child: CircularProgressIndicator(strokeWidth: 2,color: Colors.yellow),
                            ),),
                          SizedBox(width: 10),
                          ElevatedButton( style: ElevatedButton.styleFrom(foregroundColor: Colors.white,
                              backgroundColor: Colors.green,minimumSize: Size(150,40),shape:  RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),),
                              onPressed:()=>movetoSign_up(context), child: Text("Sign in"))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

