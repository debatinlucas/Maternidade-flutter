import 'package:flutter/material.dart';
import 'package:maternidade/modules/home/pages/home_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    });
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Image.asset(
                  'assets/imagens/logo_splash.png',
                  height: 90,
                ),
                const Padding(padding: EdgeInsets.only(top: 32)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
