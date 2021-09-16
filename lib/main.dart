import 'package:ecommerce_app/Screens/userlogin.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/products.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*void main() {
  runApp(Homepage());
}*/

var mob,name,email;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  mob = preferences.getString('phone');
  name = preferences.getString('name');
  email = preferences.getString('email');
  runApp(
      Homepage()
  );
}

class Homepage extends StatefulWidget {
  const Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context,widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context,widget),
        maxWidth: 1200,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(450,name: MOBILE),
          ResponsiveBreakpoint.autoScale(800,name: TABLET),
          ResponsiveBreakpoint.autoScale(1000,name: TABLET),
          ResponsiveBreakpoint.resize(1200,name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460,name: "4K"),
        ]
      ),
      home: mob == null ? UserLogin(): Products(),
    );
  }
}





