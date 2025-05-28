import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/view_models/task_view_model.dart';
import 'package:to_do_app/widgets/date_picker.dart';
import 'package:to_do_app/widgets/navigation_bar.dart';
import 'package:to_do_app/widgets/task_card.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<String> filter = [
    'All',
    'In progress',
    'Done',
    'Work',
    'Office',
    'Personal',
    'Daily',
  ];

  late String filterChosen = 'All';
  late DateTime day = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final taskVm = context.watch<TaskViewModel>();

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'lib/assets/start.png',
            fit: BoxFit.cover, // để ảnh phủ hết vùng
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(null)),
                Text(
                  'Today'
                  's Tasks',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                IconButton(onPressed: () {}, icon: const Icon(null)),
              ],
            ),
            backgroundColor: Colors.transparent,
          ),
          body: Stack(
            children: [
              // List day
              Container(
                padding: MediaQuery.of(context).size.width < 700
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 5)
                    : const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                color: Colors.transparent,
                child: Column(
                  children: [
                    DatePicker(
                      onDateSelected: (DateTime value) {
                        day = value;
                        setState(() {
                          
                        });
                      },
                    ),

                    const SizedBox(height: 8),

                    // Category
                    Container(
                      height: MediaQuery.of(context).size.width < 700 ? 20 : 30,
                      margin: const EdgeInsets.all(0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filter.length,
                        itemBuilder: (BuildContext context, int index) {
                          String selectString = filter[index];
                          bool isSelected = selectString == filterChosen;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  filterChosen = filter[index];
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: isSelected
                                    ? Colors.deepPurpleAccent
                                    : Colors.transparent,
                                foregroundColor: isSelected
                                    ? Colors.white
                                    : Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(filter[index]),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 8),

                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile = constraints.maxWidth < 700;

                          if (isMobile) {
                            // Hiển thị dạng ListView cho mobile
                            return ListView.builder(
                              itemCount: taskVm.getTasksByFilter(day, filterChosen).length,
                              itemBuilder: (context, index) {
                                return TaskCard(task: taskVm.getTasksByFilter(day, filterChosen)[index]);
                              },
                            );
                          } else {
                            // Hiển thị dạng GridView cho màn hình lớn
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        3, // số cột (có thể điều chỉnh)
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    childAspectRatio:
                                        2.5, // tỉ lệ chiều rộng/cao cho từng card
                                  ),
                              itemCount: taskVm.getTasksByFilter(day, filterChosen).length,
                              itemBuilder: (context, index) {
                                return TaskCard(task: taskVm.getTasksByFilter(day, filterChosen)[index]);
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),

              // Navi bar
              NaviBar(selectedIndex: 1, context: context),
            ],
          ),
        ),
      ],
    );
  }
}
