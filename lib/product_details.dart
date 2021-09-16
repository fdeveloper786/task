import 'dart:convert';
import 'package:ecommerce_app/const/otherconst.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'const/api.dart';

class ProductDetails extends StatefulWidget {
  final prod_id;

  const ProductDetails({Key key, this.prod_id}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var resp;
  bool load = false;
  getSingleData() async {
    http.Response respone = await http
        .get(Uri.parse(API.singleProduct + widget.prod_id.toString()));
    setState(() {
      load = true;
      resp = jsonDecode(respone.body);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSingleData();
    debugPrint('product id ${widget.prod_id.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 5.0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Product Details',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: load == true && resp != null
            ? ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 3,
                child: Image.network(
                  resp['image'],
                  height: 200,
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Divider(),
                    Text(
                      'Details',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          Currency.rupee +
                              '\t${resp['price'].toString()}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Spacer(),
                        IconTheme(
                          data: IconThemeData(
                            color: resp['rating']['rate'].toInt() < 3
                                ? Colors.red
                                : Colors.green,
                            size: 10,
                          ),
                          child: StarDisplay(
                              value: resp['rating']['rate'].toInt()),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '${resp['title']}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Reviews : ${resp['rating']['count']}',
                          style: TextStyle(fontSize: 10),
                        ),
                        Spacer()
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Description : \t${resp['description']}',
                      style: TextStyle(fontSize: 10),
                    ),
                    Divider()
                  ],
                ),
              ),
            )
          ],
        )
            : Center(child: CircularProgressIndicator()));
  }
}

class StarDisplay extends StatelessWidget {
  final int value;
  const StarDisplay({Key key, this.value = 0})
      : assert(value != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
        );
      }),
    );
  }
}
