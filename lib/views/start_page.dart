import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/view_models/login_view_model.dart';
import 'package:to_do_app/views/main_page.dart';
import 'dart:math';

import 'package:to_do_app/widgets/button.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isLogin = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Invalid email';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginVm = context.read<LoginViewModel>();
      fetchInitialData(loginVm);
    });
  }

  Future<void> fetchInitialData(LoginViewModel loginVm) async {
    // Kiểm tra xem đã đăng nhập hay chưa
    if (loginVm.getUserId() != '') {
      //loginVm.logOut(context);
      Navigator.pushReplacementNamed(context, '/');
    } 
    setState(() {
      isLogin = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginVm = context.watch<LoginViewModel>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 700;
          double imageSize = isMobile ? 250 : 300;
          double smallImageSize = isMobile ? 50 : 80;

          return Stack(
            children: [
              // Nền trắng
              Positioned.fill(
                child: Image.asset(
                  'lib/assets/start.png',
                  fit: BoxFit.cover, // để ảnh phủ hết vùng
                ),
              ),

              Center(
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 10 : 30),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!isLogin)
                          SizedBox(
                          width: imageSize + smallImageSize * 0.3,
                          height: imageSize + smallImageSize * 0.3,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none, // Cho phép tràn ra ngoài
                            children: [
                              // Các ảnh nhỏ quanh ảnh lớn
                              Positioned(
                                right: 40,
                                top: 0,
                                child: Image.asset(
                                  'lib/assets/Blue desk calendar.png',
                                  width: smallImageSize,
                                  height: smallImageSize,
                                ),
                              ),
                              Positioned(
                                top: -30,
                                left: 40,
                                child: Image.asset(
                                  'lib/assets/Blue stopwatch with pink arrow.png',
                                  width: smallImageSize * 1.5,
                                  height: smallImageSize * 1.5,
                                ),
                              ),
                              Positioned(
                                right: 50,
                                child: Image.asset(
                                  'lib/assets/multicolored smartphone notifications.png',
                                  width: smallImageSize * 1.2,
                                  height: smallImageSize * 1.2,
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 10,
                                bottom: 20,
                                child: Image.asset(
                                  'lib/assets/pie chart.png',
                                  width: smallImageSize * 0.8,
                                  height: smallImageSize * 0.8,
                                ),
                              ),
                              Positioned(
                                left: 20,
                                bottom: 40,
                                child: Image.asset(
                                  'lib/assets/vase with tulips, glasses and pencil.png',
                                  width: smallImageSize * 1.3,
                                  height: smallImageSize * 1.3,
                                ),
                              ),

                              // Ảnh lớn ở giữa
                              Image.asset(
                                'lib/assets/female sitting on the floor with cup in hand and laptop on leg.png',
                                width: imageSize,
                                height: imageSize,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Task Management & To-Do List',
                          style: TextStyle(
                            fontSize: isMobile ? 20 : 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),

                        ...[
                          if (!isLogin)
                            Text(
                              'This productive tool is designed to help you better manage your task project-wise conveniently!',
                              style: TextStyle(fontSize: isMobile ? 14 : 20),
                              textAlign: TextAlign.center,
                            ),
                          const SizedBox(height: 10),
                        ],
                        ...[
                          if (isLogin)
                            Text(
                              'Welcome to your tasks!',
                              style: TextStyle(
                                fontSize: isMobile ? 20 : 25,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if (isLogin)
                            Form(
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Container(
                                    height: MediaQuery.sizeOf(context).width < 700
                                        ? 50
                                        : 60, // Điều chỉnh chiều cao cho phù hợp
                                    width: MediaQuery.sizeOf(context).width < 700
                                        ? double.infinity
                                        : 300,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                            33,
                                            0,
                                            0,
                                            0,
                                          ),
                                          blurRadius: 6,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: _emailController,
                                      maxLines: 3,
                                      decoration: const InputDecoration(
                                        labelText: 'Email',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                          ? 'please enter a email'
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: MediaQuery.sizeOf(context).width < 700
                                        ? 50
                                        : 60,
                                    width: MediaQuery.sizeOf(context).width < 700
                                        ? double.infinity
                                        : 300,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                            33,
                                            0,
                                            0,
                                            0,
                                          ),
                                          blurRadius: 6,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: _passwordController,
                                      maxLines: 3,
                                      decoration: const InputDecoration(
                                        labelText: 'Password',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                          ? 'please enter a password'
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                        ],
                        Button(
                          text: 'Get Started',
                          onPressed: () async {
                            if (!isLogin) {
                              setState(() {
                                isLogin =
                                    !isLogin; // Chuyển đổi trạng thái đăng nhập
                              });
                            } else {
                              
                              await loginVm.signUpOrLogin(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                context,
                              );

                              if (loginVm.getUserId() != '') {
                                // Nếu đăng nhập thành công, chuyển đến trang chính
                                Navigator.pushReplacementNamed(
                                    context, '/');
                              } else {
                                // Nếu đăng nhập thất bại, hiển thị thông báo lỗi
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Login failed. Please try again.',
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          isMobile: isMobile,
                          color: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildColoredDots() {
    final random = Random();
    final List<Color> colors = [
      const Color.fromARGB(33, 3, 168, 244),
      const Color.fromARGB(30, 255, 82, 82),
      const Color.fromARGB(38, 76, 175, 79),
      const Color.fromARGB(28, 255, 153, 0),
      const Color.fromARGB(30, 155, 39, 176),
    ];

    return List.generate(5, (index) {
      double top = random.nextDouble() * 600;
      double left = random.nextDouble() * 600;
      double size = 100 + random.nextDouble() * 40;
      return _buildDot(top, left, colors[index], size);
    });
  }

  Widget _buildDot(double top, double left, Color color, double size) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
