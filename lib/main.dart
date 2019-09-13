import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './application_loclizations.dart';
import 'home.dart';
void main() {
  runApp(StartupPoint());
}

class StartupPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo Application',
      theme: ThemeData(primarySwatch: Colors.amber),
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: [
        // My localization
        AppLocalizations.delegate,
        // A LocalizationsDelegate that uses GlobalWidgetsLocalizations.load
        // to create an instance of this class.
        GlobalWidgetsLocalizations.delegate,
        //A LocalizationsDelegate that uses GlobalMaterialLocalizations.load
        // to create an instance of this class.
        GlobalMaterialLocalizations.delegate,
      ],

      localeResolutionCallback: (locale,supportedLocales){
        for(var supportedLocale in supportedLocales){
          if(supportedLocale.languageCode == locale.languageCode){
            return supportedLocale;
          }
        }
      return supportedLocales.first;
        },
      home: Splash(title: 'app_name'),
    );
  }
}

class Splash extends StatefulWidget {
  String title;

  Splash({Key key, this.title}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInToLinear);
    _controller.forward();

    Future.delayed(Duration(milliseconds: 3000), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
//        return Home(title: widget.title);
        return Home(title: _z(widget.title));
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_z(widget.title),textAlign: TextAlign.start,),
      ),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Text(
                  _z(widget.title),
                  style: TextStyle(fontSize: 80, fontFamily: 'Pacifico'),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _z('application'),
                  style: TextStyle(fontSize: 30, fontFamily: 'Pacifico'),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  _z('flutter_group')+"\n2019",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
String _z(String key){
    return AppLocalizations.of(context).translate(key);
}
}
