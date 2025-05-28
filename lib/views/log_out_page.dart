import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/view_models/login_view_model.dart';
import 'package:to_do_app/views/start_page.dart';
import 'package:to_do_app/widgets/button.dart';

class LogOutPage extends StatefulWidget {
  const LogOutPage({super.key});

  @override
  State<LogOutPage> createState() => _LogOutPageState();
}

class _LogOutPageState extends State<LogOutPage> {
  Future<void> _logOut(LoginViewModel loginVm) async {
    await loginVm.logOut(context);
  }

  @override
  Widget build(BuildContext context) {
    final loginVm = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(null)),
            Text(
              'Log Out Here',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            IconButton(onPressed: () {}, icon: const Icon(null)),
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/start.png'),
            fit: BoxFit.cover,
          ),
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Button(
            text: 'Log out',
            onPressed: () async {
              await _logOut(loginVm);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StartPage()
                ),
              );
            },
            isMobile: true,
            color: true,
          ),
        ),
      ),
    );
  }
}
