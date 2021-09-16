import 'dart:convert';
import 'dart:io';
import 'package:ecommerce_app/Screens/userlogin.dart';
import 'package:ecommerce_app/const/otherconst.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app/const/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';




class UserRegistration extends StatefulWidget {
  final userMobile;

  UserRegistration({Key key, this.userMobile}) : super(key: key);

  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  List allData = [];
  var retrievedName = "",optResp;
  String name = "",email = "",mobile= "";
  final signUpKey = GlobalKey<FormState>();
  var userDetails;
  bool autoValidate = false;
  var mobileController = TextEditingController();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  final userExist = '';

  bool flag= false;


  void _onLoading() {
    AlertDialog alertDialog = AlertDialog(
      content: new Row(
        children: <Widget>[
          new CircularProgressIndicator(),
          SizedBox(width: 30,),
          new Text("Registering.. Please Wait !"),
        ],
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=> alertDialog,
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
      userRegister();
    });
  }
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK",
        style: TextStyle(fontSize: 15),),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("${optResp['msg']}",
        style: TextStyle(fontSize: 18,),),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  var resp,data;
  userRegister() async {
    final Response response = await http.post(Uri.parse(API.stagingAPI + API.userRegisterApi),
        headers: {'Content-Type' :'application/json',
          HttpHeaders.authorizationHeader : API.stagingKey},
        body: jsonEncode(
            {
              "name": '${nameController.text}',
              "email" :'${emailController.text}',
              "mobile": '${mobileController.text}',
            }
        )
    );
    optResp = jsonDecode(response.body);
    if(response.statusCode == 200 && optResp['code']==1){
      setState(() {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=>UserLogin()));
      });
      return optResp;
    }else{
      showAlertDialog(context);
    }
  }

  void _validateSignUp() {
    if(signUpKey.currentState.validate()){
      signUpKey.currentState.save();
      _onLoading();
    } else{
      setState(() {
        autoValidate = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobileController.text = widget.userMobile;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> UserLogin()));
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Text(''),
            iconTheme: IconThemeData(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Text('SIGN UP',style: TextStyle(
                    fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 20,),
                Container(
                  margin: const EdgeInsets.only(left: 10,right: 10,top: 10),
                  child: Form(
                    key: signUpKey,
                    autovalidate: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Mobile number
                        TextFormField(
                          autovalidate: false,
                          style: TextStyle(color: Colors.black),
                          controller: mobileController,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (String mobile) {
                            mobile = mobileController.text;
                          },
                          validator: (String value){
                            if(value.length == 0) {
                              return "Mobile is required!";
                            }else if (value.length != 10){
                              return "Mobile number must be 10 digit only";
                            }else {
                              return null;
                            }
                          },
                          readOnly: false,
                          textInputAction: TextInputAction.none,
                          onTap: (){},
                          decoration: InputDecoration(
                              hintText: 'Mobile Number',
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 15.0),
                              fillColor: Colors.grey[100],
                              filled: true,
                              contentPadding: const EdgeInsets.fromLTRB(20.0,10.0,20.0,10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: BorderSide.none
                              )
                          ),
                        ),
                        // email
                        SizedBox(height: 20,),
                        TextFormField(
                          autovalidate: false,
                          style: TextStyle(color: Colors.black),
                          controller: emailController,
                          keyboardType: TextInputType.text,
                          onTap: (){},
                          readOnly: false,
                          textInputAction: TextInputAction.none,
                          validator: (String value){
                            String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regExp = new RegExp(pattern);
                            if (value.length == 0) {
                              return "Email is Required";
                            } else if(!regExp.hasMatch(value)){
                              return "Invalid Email";
                            }else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 15.0),
                              fillColor: Colors.grey[100],
                              filled: true,
                              contentPadding: const EdgeInsets.fromLTRB(20.0,10.0,20.0,10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: BorderSide.none
                              )
                          ),
                        ),
                        //name
                        SizedBox(height: 20,),
                        TextFormField(
                          autovalidate: false,
                          style: TextStyle(color: Colors.black),
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          validator: (String value){
                            if(value.length == 0) {
                              return "Name is required!";
                            }else {
                              return null;
                            }
                          },
                          readOnly: false,
                          textInputAction: TextInputAction.none,
                          decoration: InputDecoration(
                              hintText: 'Name',
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 15.0),
                              fillColor: Colors.grey[100],
                              filled: true,
                              contentPadding: const EdgeInsets.fromLTRB(20.0,10.0,20.0,10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: BorderSide.none
                              )
                          ),
                        ),
                        // Signup button
                        SizedBox(height: 100,),
                        InkWell(
                          child: Container(
                            height: 50,
                            //  width: 150,
                            margin: const EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topLeft,
                                  colors: [AppColors.gradFirstColor, AppColors.gradSecondColor]
                              ),
                            ),
                            child: Center(child: Text('Sign up',style: TextStyle(fontSize: 20,color: Colors.white),)),
                          ),
                          onTap: (){
                            _validateSignUp();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}


