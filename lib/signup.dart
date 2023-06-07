import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ults/New_Routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ults/error.dart';
class sign_up extends StatefulWidget {
  const sign_up({Key? key}) : super(key: key);

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  final _formkey = GlobalKey<FormState>();
  String _name="";
  String email="";
  String password="";
  String number="";
  FirebaseAuth _auth = FirebaseAuth.instance;
  movetoLogin(BuildContext context) async {
    if(_formkey.currentState !=null ) {
      await Future.delayed(Duration(seconds: 1));

      Navigator.pushNamed(context, Routes.Login);

    }
  }

  bool changeButton=false;

  Future<void> movetoHome(BuildContext context) async {
    if (_formkey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      changeButton = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Navigator.pushNamed(context, Routes.Ver);
    } catch (error) {
      // Handle the error here
      errorMessage().loadError(error.toString());
    } finally {
      setState(() {
        changeButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: () async{
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
            appBar: AppBar(    title: Text("Sign Up"),centerTitle: true ,automaticallyImplyLeading: false),
            body: SingleChildScrollView(
              child: Column(

                children: [
                  Form(
                    key:_formkey,
                      child: Column(
                    children: [
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.name,

                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.drive_file_rename_outline),
                            hintText:"i.e Faizan Zia",
                            labelText: "Enter Your Name",
                          ),
                          validator:(value){
                            if(value!.isEmpty)
                              {
                                return "Enter The name you have not Enter Any";
                              }
                            else
                              {
                                return null;
                              }
                          } ,
                          onChanged: (value){
                              _name=value;
                            setState(() {

                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,

                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.alternate_email_rounded),
                            hintText:"i.e xyz@gmail.com",
                            labelText: "Enter Your Email",
                          ),
                          validator:(value){
                            if(value!.isEmpty)
                            {
                              return "Enter The Your Email ";
                            }
                            else if(EmailValidator.validate(value)==false)
                            {
                              return "Email is not right";
                            }
                            else
                            {
                              return null;
                            }
                          } ,
                          onChanged: (value){
                            email=value;
                            setState(() {

                            });
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          maxLength: 7,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            hintText:"i.e xxxxxxxx",
                            labelText: "Enter Your Password",
                          ),
                          validator:(value){
                            if(value!.isEmpty)
                            {
                              return "Enter The Password ";
                            }
                            else if(value!.length<7)
                              {
                                return "Length is short";
                              }
                            else
                            {
                              return null;
                            }
                          } ,
                          onChanged: (value){
                            password=value;
                            setState(() {

                            });
                          },
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                           maxLength: 12,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.numbers_outlined),
                            hintText:"030x-xxxxxxx",
                            labelText: "Enter Your Number",
                          ),
                          validator:(value){
                            if(value!.isEmpty)
                            {
                              return "Enter The Number ";
                            }
                            else if(value.length<11)
                            {
                              return "Length of the number is not right";
                            }
                            else
                            {
                              return null;
                            }
                          } ,
                          onChanged: (value){
                            number=value;
                            setState(() {

                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Text("Already Have an Account"),
                          TextButton(onPressed:()=> movetoLogin(context) , child: Text("Login ",style: TextStyle( decoration: TextDecoration.underline,), ))
                        ],
                      ),
                      SizedBox(height: 10),

                      InkWell(
                        mouseCursor: SystemMouseCursors.click,
                        onTap:() => movetoHome(context),


                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: changeButton ? 50:150,
                          height: 50,
                          alignment: Alignment.center,
                          child: changeButton ? Icon(Icons.done,color: Colors.white,):Text("Sign up",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(changeButton ? 60:8),
                          ),
                        ),
                      )


                    ],
                  )
                  )

                ],
              ),
            ),

          ),
      );
  }


}
