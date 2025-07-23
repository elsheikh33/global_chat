import 'package:flutter/material.dart';
import 'package:fourth_project/screens/login_screen.dart';
import 'package:fourth_project/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";

  const WelcomeScreen({super.key});
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  String login= LoginScreen.id;
  String Regist= RegistrationScreen.id;

  late AnimationController Controller1;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Controller1 = AnimationController(duration: const Duration(seconds: 1)  ,vsync: this );
    animation = CurvedAnimation(parent: Controller1, curve: Curves.decelerate);
    Controller1.forward();
    Controller1.addListener(() {
      setState(() {
      });
      print(Controller1.value);
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
              SafeArea(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                
                      height: animation.value * 100,

                
                      child: Image.asset('images/logo.png', ),
                    ),
                ),
              ),
                  SafeArea(
                   child: TypewriterAnimatedTextKit(
                    text: const ['Flash Chat'],
                    textStyle: const TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black
                    ),
                                   ),
                 ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            const RoundedButton(title: 'log in',colour: Colors.lightBlueAccent,route: LoginScreen.id,),
            const RoundedButton(title: 'Register',colour: Colors.blueAccent,route: RegistrationScreen.id,),

          ],
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({super.key, required this.title,required this.colour,required this.route});
 final Color colour;
 final String title;
 final String route;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: (){
            Navigator.pushNamed(context, route);

          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title
          ),
        ),
      ),
    );
  }
}
