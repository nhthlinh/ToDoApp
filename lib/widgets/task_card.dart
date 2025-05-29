import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/views/task_detail_page.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final void Function(bool?)? onChanged;

  const TaskCard({
    super.key,
    required this.task,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM');
    final isMobile = MediaQuery.of(context).size.width < 700;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(task: task),
          ),
        );
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nội dung bên trái
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 14,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, 
                      softWrap: true,
                    ),
                    if (task.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          task.description,
                          style: TextStyle(
                            fontSize: isMobile ? 20 : 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, 
                          softWrap: true,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      '${dateFormat.format(task.beginAt)} - ${dateFormat.format(task.endAt)}',
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: isMobile ? 16 : 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, 
                      softWrap: true,
                    ),
                  ],
                ),
              ),
      
              // Nội dung bên phải
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _categoryIcon(task.category, isMobile),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? const Color.fromARGB(48, 155, 39, 176)
                          : const Color.fromARGB(46, 255, 153, 0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task.isCompleted ? 'Done' : 'In progress',
                      style: TextStyle(
                        color: task.isCompleted ? Colors.purple : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 14 : 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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


}
