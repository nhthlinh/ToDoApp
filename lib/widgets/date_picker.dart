import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;

  const DatePicker({
    super.key,
    required this.onDateSelected,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final ScrollController _scrollController = ScrollController();
  final int totalDays = 60;
  late DateTime selectedDate;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    currentIndex = totalDays ~/ 2;

    // Delay scroll to allow layout to complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToCenter(currentIndex);
    });
  }

  void scrollToCenter(int index) {
    // Approximate width per item (adjust based on your UI)
    double itemWidth = 60.0 + 16.0;
    double screenWidth = MediaQuery.of(context).size.width;
    double offset = (index * itemWidth) - (screenWidth/2);
    _scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> days = List.generate(
      totalDays,
      (index) => DateTime.now().subtract(Duration(days: totalDays ~/ 2 - index)),
    );

    return SizedBox(
      height: 90,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(days.length, (index) {
            DateTime day = days[index];
            bool isSelected = day.day == selectedDate.day &&
                              day.month == selectedDate.month &&
                              day.year == selectedDate.year;

            return Container(
              height: 80,
              width: 60,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                //color: Colors.white,
                color: isSelected ? Colors.deepPurpleAccent : Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedDate = day;
                    scrollToCenter(index);
                  });
                  widget.onDateSelected(selectedDate); // Truyền ra ngoài
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('MMM').format(day),
                      style: TextStyle(
                        fontSize:  MediaQuery.of(context).size.width > 700 ?  14 : 10,
                        color: isSelected ? Colors.white : Colors.black,
                      )
                    ),
                    Text(
                      DateFormat('d').format(day), 
                      style: TextStyle(
                        fontSize:  MediaQuery.of(context).size.width > 700 ?  18 : 15,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                      )
                    ), // 1, 2, 3...
                    Text(
                      DateFormat('E').format(day),
                      style: TextStyle(
                        fontSize:  MediaQuery.of(context).size.width > 700 ?  14 : 10,
                        color: isSelected ? Colors.white : Colors.black,
                      )
                    ), // Mon, Tue, etc.
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
