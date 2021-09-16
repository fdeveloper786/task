import 'dart:convert';
import 'package:ecommerce_app/product_details.dart';
import 'package:ecommerce_app/scoped_model/model_products.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/userlogin.dart';
import 'const/api.dart';
import 'const/otherconst.dart';

class Products extends StatefulWidget {
  const Products({Key key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var resp;
  bool load = false;
  ProductModel productModel = new ProductModel();
  getData() async {
    http.Response response = await http.get(Uri.parse(API.products));
    setState(() {
      load = true;
      resp = jsonDecode(response.body);
    });
  }
  Future<void> _signOut(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('phone');
    prefs.remove('name');
    prefs.remove('email');
    Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> UserLogin()));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 5.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            'HomePage',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(
                icon: Icon(Icons.power_settings_new_rounded),
                onPressed: (){
                  _signOut(context);
                  }
                )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                new MaterialPageRoute(builder: (context) => super.widget));
          },
          label: Text(
            load == true ? 'Reload' : 'Loading...',
            style: TextStyle(color: Colors.white),
          ),
          icon: load == true
              ? Icon(
            Icons.refresh_rounded,
            color: Colors.white,
            size: 29,
          )
              : SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
              // color: Colors.white,
              strokeWidth: 2.0,
            ),
          ),
          backgroundColor: Colors.green,
          //tooltip: 'Capture Picture',
          elevation: 5,
          splashColor: Colors.grey,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: resp != null
                  ? GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate:
                new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 2),
                ),
                itemCount: resp == null ? 0 : resp.length,
                itemBuilder: (context, index) {
                  productModel = new ProductModel.fromJson(resp[index]);
                  return GestureDetector(
                    onTap: () {
                      var prodId = resp[index]['id'].toString();
                      setState(() {
                        print("hello ${resp[index]['id'].toString()}");
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) =>
                                ProductDetails(prod_id: prodId))
                        );
                      });
                    },
                    child: Card(
                      color: Colors.white,
                      child: Container(
                        child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.network(
                                    productModel.image,
                                    height: 50,
                                    width: 50,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    productModel.title.toString(),
                                    style: TextStyle(fontSize: 10.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  );
                },
              )
                  : Center(child: CircularProgressIndicator())),
        ));
  }
}
