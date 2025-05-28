import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:to_do_app/views/task_page.dart';
import 'package:to_do_app/widgets/button.dart';

class TaskSummary extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;
  final bool isMobile;

  const TaskSummary({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final double percent = totalTasks == 0 ? 0 : completedTasks / totalTasks;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF5F33E1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // Phần text và nút
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Today Task is almost done',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text('$completedTasks / $totalTasks task', style: TextStyle(color: Colors.white) ,),

                const SizedBox(height: 10),

                Button(
                  isMobile: isMobile,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TaskPage()),
                    );
                  },
                  text: 'View Tasks',
                  color: false,
                )
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Biểu đồ tròn
          // Biểu đồ tròn chỉ hiện khi percent > 0
          if (percent > 0)
            CircularPercentIndicator(
              radius: 50.0,
              lineWidth: 10.0,
              percent: percent.clamp(0.0, 1.0),
              center: Text('${(percent * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white)),
              progressColor: Colors.white,
              backgroundColor: Colors.white60,
              circularStrokeCap: CircularStrokeCap.round,
            ),
        ],
      ),
    );
  }
}
