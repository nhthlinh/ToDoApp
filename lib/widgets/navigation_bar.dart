import 'package:flutter/material.dart';
import 'package:to_do_app/views/add_task_page.dart';
import 'package:to_do_app/views/log_out_page.dart';
import 'package:to_do_app/views/main_page.dart';
import 'package:to_do_app/views/task_page.dart';

class NaviBar extends StatelessWidget {
  final int selectedIndex;
  final BuildContext context;

  static const Color primaryColor = Color(0xFF5F33E1);
  static const Color backgroundColor = Color(0xFFE6E0F8); // nền nhạt hơn

  const NaviBar({
    super.key,
    required this.selectedIndex,
    required this.context,
  });

  void onItemSelected(int value) {
    switch (value) {
      case 0:
        // Trang Main, có thể pop đến root hoặc làm gì đó
        Navigator.push(context, MaterialPageRoute(builder: (_) => MainPage()));
        break;
      case 1:
        // Trang Task
        Navigator.push(context, MaterialPageRoute(builder: (_) => TaskPage()));
        break;
      case 2:
      case 3:
        // // Trang Profile
        // Navigator.push(context, MaterialPageRoute(builder: (_) => MainPage()));
        break;
      case 4:
        // Trang LogOut
        Navigator.push(context, MaterialPageRoute(builder: (_) => LogOutPage()));
        break;
      default:
        break;
    }
  }

  void onAddTaskPressed () { 
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddTaskPage()),
    ); 
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 700;
    final navWidth = isWide ? 400.0 : screenWidth;

    return Align(
      alignment: isWide ? Alignment.bottomRight : Alignment.bottomCenter,
      child: SizedBox(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              width: navWidth,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: selectedIndex,
                onTap: onItemSelected,
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: primaryColor,
                unselectedItemColor: const Color.fromARGB(52, 95, 51, 225),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Main',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.task_outlined),
                    activeIcon: Icon(Icons.task),
                    label: 'Task',
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox.shrink(), // <-- Mục rỗng chừa chỗ nút cộng
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox.shrink(), // <-- Mục rỗng chừa chỗ nút cộng
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.logout_outlined),
                    activeIcon: Icon(Icons.logout),
                    label: 'Log Out',
                  ),
                ],
              ),
            ),

            // Nút + nổi lên trên
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton(
                  shape: CircleBorder(),
                  backgroundColor: primaryColor,
                  onPressed: onAddTaskPressed,
                  elevation: 4,
                  child: const Icon(Icons.add, size: 32, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
