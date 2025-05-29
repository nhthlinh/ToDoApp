import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/view_models/login_view_model.dart';
import 'package:to_do_app/view_models/task_view_model.dart';
import 'package:to_do_app/views/add_task_page.dart';
import 'package:to_do_app/views/task_detail_page.dart';
import 'package:to_do_app/views/task_page.dart';
import 'package:to_do_app/widgets/navigation_bar.dart';
import 'package:to_do_app/widgets/task_sumary.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskVm = context.read<TaskViewModel>();
      final loginVm = context
          .read<LoginViewModel>(); // dùng read thay vì watch trong initState

      fetchInitialData(taskVm, loginVm);
    });
  }

  Future<void> fetchInitialData(
    TaskViewModel taskVm,
    LoginViewModel loginVm,
  ) async {
    try {
      await taskVm.fetchTasks(loginVm.getUserId());
      setState(() {});
    } catch (e) {
      debugPrint('Error fetching initial data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 700;
    final taskVm = context.watch<TaskViewModel>();
    final scrollController = ScrollController();
    final scrollController2 = ScrollController();

    final List<String> category = ['Work', 'Office', 'Personal', 'Daily'];

    return Stack(
      children: [
        // Nền trắng
        Positioned.fill(
          child: Image.asset(
            'lib/assets/start.png',
            fit: BoxFit.cover, // để ảnh phủ hết vùng
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: isMobile
              ? null
              : AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  centerTitle: true,
                  title: const Text(
                    'ToDo',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
          body: Stack(
            children: [
              Container(
                padding: isMobile
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 5)
                    : const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                color: Colors.transparent,
                child: Center(
                  child: Builder(
                    builder: (context) {
                      final content = Flex(
                        direction: isMobile ? Axis.vertical : Axis.horizontal,
                        children: [
                          Builder(
                            builder: (context) {
                              final col1 = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //Avartar
                                  Row(
                                    children: [
                                      // Avatar
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundImage: const AssetImage(
                                          'lib/assets/image.png',
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      // Lời chào
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Hello,',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                          ),
                                          Text(
                                            'Thuy Linh Nguyen',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // Progress
                                  const SizedBox(height: 15),

                                  TaskSummary(
                                    completedTasks: taskVm
                                        .getCompletedTasks()
                                        .length,
                                    totalTasks: taskVm.getTasksLength(),
                                    isMobile: isMobile,
                                  ),

                                  const SizedBox(height: 15),
                                ],
                              );

                              if (isMobile) {
                                return SingleChildScrollView(
                                  padding: const EdgeInsets.only(top: 20),
                                  controller: scrollController,
                                  child: col1,
                                );
                              }
                              return Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: SingleChildScrollView(child: col1),
                                ),
                              );
                            },
                          ),

                          isMobile
                              ? const SizedBox(height: 20)
                              : const SizedBox(width: 40),

                          Builder(
                            builder: (context) {
                              final col = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "In progress",
                                        style: TextStyle(
                                          fontSize: isMobile ? 20 : 28,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            36,
                                            124,
                                            77,
                                            255,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          taskVm
                                              .getPendingTasks()
                                              .length
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: isMobile ? 14 : 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.deepPurpleAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),
                                  ...[
                                    if (taskVm.getTasksByTime().isNotEmpty)
                                      SizedBox(
                                        height: isMobile ? 110 : 120,
                                        child: ListView.builder(
                                          itemCount: taskVm
                                              .getTasksByTime()
                                              .length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TaskDetailPage(
                                                          task: taskVm.getTasksByTime()[index],
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: isMobile ? 150 : 170,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8,
                                                    ),
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: index%2 == 0 ? Color.fromARGB(40, 3, 168, 244) : const Color.fromARGB(61, 255, 153, 0),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            taskVm.getTasksByTime()[index].title,
                                                            style: TextStyle(
                                                              fontSize: isMobile
                                                                  ? 10
                                                                  : 16,
                                                              color:
                                                                  Colors.black54,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1, 
                                                            softWrap: true,
                                                          ),
                                                        ),
                                                        _categoryIcon(
                                                          taskVm.getTasksByTime()[index].category,
                                                          isMobile,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 6),
                                                    if (taskVm.getTasksByTime()[index]
                                                        .description
                                                        .isNotEmpty)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              top: 4,
                                                            ),
                                                        child: Text(
                                                          taskVm.getTasksByTime()[index].description,
                                                          style: TextStyle(
                                                            fontSize: isMobile
                                                                ? 14
                                                                : 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1, 
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    const SizedBox(height: 6),
                                                    Consumer<TaskViewModel>(
                                                      builder: (context, taskVm, child) {
                                                        final totalDuration = taskVm.getTasksByTime()[index].endAt.difference(taskVm.getTasksByTime()[index].beginAt).inSeconds.toDouble();
                                                        final elapsed = DateTime.now().difference(taskVm.getTasksByTime()[index].beginAt).inSeconds.toDouble();
                                                        final progress = (elapsed / totalDuration).clamp(0.0, 1.0);

                                                        return LinearProgressIndicator(
                                                          value: progress,
                                                          backgroundColor:
                                                              Colors.white,
                                                          color: index%2 == 0 ? Colors.lightBlueAccent : const Color.fromARGB(255, 255, 153, 0),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                  
                                  ],

                                  const SizedBox(height: 8),

                                  // Task category
                                  Row(
                                    children: [
                                      Text(
                                        "Task Group",
                                        style: TextStyle(
                                          fontSize: isMobile ? 20 : 28,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            36,
                                            124,
                                            77,
                                            255,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          '4',
                                          style: TextStyle(
                                            fontSize: isMobile ? 14 : 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.deepPurpleAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      final cate = category[index];

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TaskPage()
                                            ),
                                          );
                                        },      
                                        child: Container(
                                          height: isMobile ? 70 : 90,
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 8,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color: Colors.white,
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
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  _categoryIcon(cate, isMobile),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        cate,
                                                        style: TextStyle(
                                                          fontSize: isMobile
                                                              ? 14
                                                              : 18,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                      Text(
                                                        '${(taskVm
                                                            .getTasksByCategory(
                                                              cate,
                                                              false,
                                                            )
                                                            .length + taskVm
                                                            .getTasksByCategory(
                                                              cate,
                                                              true,
                                                            )
                                                            .length).toString()} Tasks',
                                                        style: TextStyle(
                                                          fontSize: isMobile
                                                              ? 10
                                                              : 14,
                                                          color: Colors.black38,
                                                          fontWeight: FontWeight.w500
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                        
                                              Consumer<TaskViewModel>(
                                                builder: (context, taskVm, child) {
                                                  final completeTask = taskVm
                                                      .getTasksByCategory(
                                                        cate,
                                                        true,
                                                      )
                                                      .length;
                                                  final numOfTask =
                                                      taskVm
                                                          .getTasksByCategory(
                                                            cate,
                                                            false,
                                                          )
                                                          .length +
                                                      completeTask;
                                                  final percent = numOfTask != 0
                                                      ? completeTask / numOfTask
                                                      : 0.0;
                                        
                                                  return CircularPercentIndicator(
                                                    radius: 20.0,
                                                    lineWidth: 6.0,
                                                    percent: percent.clamp(
                                                      0.0,
                                                      1.0,
                                                    ),
                                                    center: Text(
                                                      '${(percent * 100).toStringAsFixed(0)}%',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    progressColor: _getCol(cate),
                                                    backgroundColor:
                                                      Colors.black12,
                                                    circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 70),
                                ],
                              );

                              if (isMobile) {
                                return SingleChildScrollView(
                                  controller: scrollController2,
                                  child: col,
                                );
                              }
                              return Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: SingleChildScrollView(child: col),
                                ),
                              );
                            },
                          ),
                        ],
                      );

                      if (isMobile)
                        return SingleChildScrollView(child: content);
                      return content;
                    },
                  ),
                ),
              ),

              NaviBar(selectedIndex: 0, context: context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryIcon(String category, bool isMobile) {
    Icon icon;
    Color color;

    switch (category) {
      case 'Work':
        icon = Icon(Icons.work, color: Color.fromARGB(255, 33, 149, 243), size: 25);
        color = const Color.fromARGB(46, 33, 149, 243);
        break;
      case 'Office':
        icon = Icon(Icons.apartment, color: const Color.fromARGB(255, 233, 30, 98), size: 25);
        color = const Color.fromARGB(49, 233, 30, 98);
        break;
      case 'Personal':
        icon = Icon(Icons.person, color: Colors.purple, size: 25);
        color = const Color.fromARGB(42, 155, 39, 176);
        break;
      case 'Daily':
        icon = Icon(Icons.calendar_today, color: Color.fromARGB(255, 255, 153, 0), size: 25);
        color = const Color.fromARGB(42, 255, 153, 0);
        break;
      default:
        icon = Icon(Icons.calendar_today, color: Colors.grey, size: 25);
        color = const Color.fromARGB(42, 158, 158, 158);
    }

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: icon,
    );
  }
  
  Color _getCol(String category) {
    switch (category) {
      case 'Work':
        return const Color.fromARGB(255, 33, 149, 243);
      case 'Office':
        return const Color.fromARGB(255, 233, 30, 98);
      case 'Personal':
        return const Color.fromARGB(255, 155, 39, 176);
      case 'Daily':
        return const Color.fromARGB(255, 255, 153, 0);
      default:
        return Colors.grey;
    }
  }

}
