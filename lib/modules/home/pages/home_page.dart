import 'package:maternidade/modules/bebe/pages/bebe_page.dart';
import 'package:maternidade/modules/medico/pages/medico_page.dart';
import 'package:maternidade/modules/mae/pages/mae_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            SizedBox(
              width: 100,
              child: ElevatedButton(
                child: const Text("Médicos"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MedicoPage(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
                width: 100,
                child: ElevatedButton(
                child: const Text("Mães"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MaePage(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
                width: 100,
                child: ElevatedButton(
                child: const Text("Bebês"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BebePage(),
                    ),
                  );
                },
              ),
            ),
        ]),
      ),
    );
  }
}
