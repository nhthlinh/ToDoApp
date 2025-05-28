import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firebase_options.dart';
import 'package:to_do_app/view_models/login_view_model.dart';
import 'package:to_do_app/view_models/task_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/views/main_page.dart';
import 'package:to_do_app/views/start_page.dart';
import 'package:to_do_app/views/task_page.dart';
import 'package:to_do_app/views/task_detail_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskViewModel()),
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
      ],
      child: const ToDoApp(),
    ),
  );
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        primaryColor: const Color(0xFF5F33E1),
        useMaterial3: true,
        textTheme: GoogleFonts.rubikTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/start', // Đặt trang khởi đầu
      routes: <String, WidgetBuilder> {
        '/start': (BuildContext context) => const StartPage(), //Done
        '/': (BuildContext context) => const MainPage(), // còn khúc dưới miếng 
        '/tasks': (BuildContext context) => TaskPage(), //Done, detail done
      },
    );
  }
}



