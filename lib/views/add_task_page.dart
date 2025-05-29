import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/repositories/task_repository.dart';
import 'package:to_do_app/view_models/login_view_model.dart';
import 'package:to_do_app/view_models/task_view_model.dart';
import 'package:to_do_app/widgets/button.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();

  // Danh sách các category
  final List<String> _categories = ['Work', 'Office', 'Personal', 'Daily'];
  String? _selectedCategory; // Chọn mặc định là null, có thể cập nhật sau

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final now = DateTime.now();
    final initialDate = isStart ? (_startDate ?? now) : (_endDate ?? now);
    final firstDate = DateTime(now.year - 5);
    final lastDate = DateTime(now.year + 5);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // Nếu startDate > endDate thì reset endDate
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _saveTask(TaskViewModel taskVm, LoginViewModel loginVm) async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please chose start day and end day')),
        );
        return;
      }
      if (_endDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End day must after start day')),
        );
        return;
      }

      // Lấy dữ liệu từ form
      final category = _selectedCategory;
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();

      await taskVm.addTask(
        TaskModel(
          userId: loginVm.getUserId(),
          title: title,
          description: description,
          isCompleted: false,
          createdAt: DateTime.now(),
          beginAt: _startDate!,
          endAt: _endDate!,
          category: category!,
        ),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task is save')));

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskVm = context.watch<TaskViewModel>();
    final loginVm = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(null)),
            Text(
              'Add Task',
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
        child: Form(
          key: _formKey,
          child: Builder(
            builder: (context) {
              final col1 = Column(
                children: [
                  // Dropdown chọn category
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(33, 0, 0, 0),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<String>(
                      icon: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Colors.deepPurpleAccent,
                      ),
                      iconSize: 40,
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Row(
                            children: [
                              _categoryIcon(category, MediaQuery.of(context).size.width < 700),
                              const SizedBox(width: 8),
                              Text(category),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? 'Vui lòng chọn category'
                          : null,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Title input
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(33, 0, 0, 0),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Vui lòng nhập tiêu đề'
                          : null,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description input
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(33, 0, 0, 0),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Vui lòng nhập mô tả'
                          : null,
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              );

              final col2 = Column(
                children: [
                  // Start date picker
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(33, 0, 0, 0),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        _startDate == null
                            ? 'Start Day'
                            : 'Start Day: ${_startDate!.toLocal().toString().split(' ')[0]}',
                      ),
                      trailing: const Icon(
                        Icons.calendar_today,
                        color: Colors.deepPurpleAccent,
                        size: 28,
                      ),
                      onTap: () => _pickDate(context, true),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // End date picker
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(33, 0, 0, 0),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        _endDate == null
                            ? 'End Day'
                            : 'End Day: ${_endDate!.toLocal().toString().split(' ')[0]}',
                      ),
                      trailing: const Icon(
                        Icons.calendar_today,
                        color: Colors.deepPurpleAccent,
                        size: 28,
                      ),
                      onTap: () => _pickDate(context, false),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Button(
                    text: 'Add Task',
                    onPressed: () {
                      _saveTask(taskVm, loginVm);
                    },
                    isMobile: true,
                    color: true,
                  ),
                ],
              );

              return MediaQuery.of(context).size.width > 700
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: col1),
                        SizedBox(width: 32), // spacing giữa hai cột
                        Expanded(child: col2),
                      ],
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(8),
                      child: Column(children: [col1, col2]),
                    );
            },
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
