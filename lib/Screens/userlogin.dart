import 'dart:convert';
import 'dart:io';
import 'package:ecommerce_app/Screens/userregistration.dart';
import 'package:ecommerce_app/const/api.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../products.dart';
import 'package:ecommerce_app/const/otherconst.dart';


class MyData{
  String name,email,mobile;
  MyData(this.name, this.email, this.mobile);
}

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  List<MyData> allData = [];
  var resp,data;
  List loginData = [];
  var mobileController = TextEditingController();
  bool flag = false;
  var mobile = '';
  var email = '';
  var name = '';
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  // loggin loader
  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 20,),
          Container(margin: EdgeInsets.only(left: 2),
              child:Text("Logging.. Please wait..." )
          ),
        ],),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => alert,
    );
  }
  // login alert
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
        Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> UserLogin()));
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> UserRegistration(userMobile:mobileController.text)));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("${resp['msg']}"),
      content: Text("Please Register to continue!",
        style: TextStyle(fontSize: 18,),),
      actions: [
        cancelButton,
        continueButton,
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
  // user login method
  userLogin() async {
    showLoaderDialog(context);
    mobile = mobileController.text;
    http.Response response = await http.post(Uri.parse(API.stagingAPI+API.userLogin),
        headers: {'Content-Type' :'application/json',
          HttpHeaders.authorizationHeader : API.stagingKey},
        body: jsonEncode(
            {
              "mobile":mobile,
            }
        ));
    resp = jsonDecode(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(response.statusCode == 200 && resp['code']==1){
      data = resp['user'];
      loginData = [
        mobile = data[0]['phone'],
        name = data[0]['name'],
        email = data[0]['email'],
      ];
      setState(() {
        prefs.setString('phone', loginData[0]);
        prefs.setString('name', loginData[1]);
        prefs.setString('email', loginData[2]);
        Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> Products()));
      });
      return resp;
    }
    else{
      showAlertDialog(context);
    }
  }

  void loginValidate(){
    if(loginKey.currentState.validate()){
      loginKey.currentState.save();
      userLogin();
    }else{
      setState(() {
        _autoValidate = true;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobile = mobileController.text;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: (){
          exit(0);
        },
        child:Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height:MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(0))
                  ),
                  child: Image.network("https://i.pinimg.com/736x/8f/c4/69/8fc46935246069c1b0d9dcd33c1bcce5.jpg",
                  height: 500,width: MediaQuery.of(context).size.width,fit: BoxFit.cover,)/*new Image.asset("assets/images/icons/login/login_back.png",
                    fit: BoxFit.cover,height:500,width: MediaQuery.of(context).size.width,),*/
                ),
                Positioned(
                  top: 60,
                  left: 330,
                  child: InkWell(
                    child: Container(
                      height: 40,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black.withOpacity(0.6),
                      ),
                      child: Center(child: Text('Skip',
                        style: TextStyle(fontSize: 15,
                          color: Colors.white,),)),
                    ),
                    onTap: (){
                      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context)=> Products()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 320),
                  child: customLogin(),
                )
              ],
            ),
          ),
        )
    );
  }

  Widget customLogin(){
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40)
          )
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 40,left: 10,right: 10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50)
              )
          ),
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            reverse: false,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Login',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Container(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 40),
                    child:Form(
                      key: loginKey,
                      autovalidate: true,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            autovalidate: false,
                            validator: (String value){
                              if(value.length == 0)
                              {
                                return " Mobile Number is required !";
                              }else if (value.length != 10){
                                return '10 Digits only';
                              }else {
                                return null;
                              }
                            },
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            controller: mobileController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.none,
                            decoration: InputDecoration(
                                hintText: 'Enter Mobile Number',
                                hintStyle: TextStyle(color: Colors.grey,fontFamily: 'signika',),
                                fillColor: Colors.grey[100],
                                // errorStyle: TextStyle(color: Colors.red),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: (){
                                    this.setState(() {
                                      mobileController.clear();
                                    });
                                  },
                                ),
                                contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0,20.0,10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    borderSide: BorderSide(
                                      //width: 0.2,
                                        color: Colors.grey,style: BorderStyle.none
                                    )
                                )
                            ),
                          ),
                          SizedBox(height: 15),
                          InkWell(
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topLeft,
                                    colors: [AppColors.gradFirstColor, AppColors.gradSecondColor]
                                ),
                              ),
                              child: Center(child: Text('Login',style: TextStyle(fontSize: 20,color: Colors.white),)),
                            ),
                            onTap: (){
                              loginValidate();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}