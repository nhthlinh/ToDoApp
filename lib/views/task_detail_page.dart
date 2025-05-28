import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/view_models/task_view_model.dart';
import 'package:to_do_app/widgets/button.dart';

class TaskDetailPage extends StatefulWidget {
  final TaskModel task;
  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final _formKey = GlobalKey<FormState>();

  // Danh sách các category
  final List<String> _categories = ['Work', 'Office', 'Personal', 'Daily'];

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedCategory; // Chọn mặc định là null, có thể cập nhật sau
  String? _title;
  String? _description;
  bool? isComplete;

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

  Future<void> _updateTask(TaskViewModel taskVm) async {
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

      await taskVm.updateTask(widget.task);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task is save')));

      Navigator.of(context).pop();
    }
  }

  Future<void> _deleteTask(TaskViewModel taskVm, String id) async {
    await taskVm.deleteTask(id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Task is delete')));

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _startDate = widget.task.beginAt;
    _endDate = widget.task.endAt;
    _title = widget.task.title;
    _description = widget.task.description;
    _selectedCategory = widget.task.category;
    isComplete = widget.task.isCompleted;
    _descriptionController = TextEditingController(text: _description);
    _titleController = TextEditingController(text: _title);
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
                          color: Colors.black26,
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
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? _selectedCategory
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
                          color: Colors.black26,
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
                          ? 'Please enter the title'
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
                          color: Colors.black26,
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
                          ? 'Please enter the description'
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
                          color: Colors.black26,
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
                          color: Colors.black26,
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
                    text: (widget.task.isCompleted) ? 'Reset' : 'Done',
                    onPressed: () {
                      widget.task.isCompleted = !widget.task.isCompleted;
                      _updateTask(taskVm);
                    },
                    isMobile: true,
                    color: true,
                  ),

                  const SizedBox(height: 8),

                  Button(
                    text: 'Save',
                    onPressed: () {
                      widget.task.beginAt = _startDate!;
                      widget.task.endAt = _endDate!;
                      widget.task.category =
                          _selectedCategory!; // Chọn mặc định là null, có thể cập nhật sau
                      widget.task.title = _titleController.text.trim();
                      widget.task.description = _descriptionController.text
                          .trim();
                      _updateTask(taskVm);
                    },
                    isMobile: true,
                    color: true,
                  ),

                  const SizedBox(height: 8),

                  Button(
                    text: 'Delete Task',
                    onPressed: () {
                      _deleteTask(taskVm, widget.task.id!);
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
                    child: Column(
                      children: [
                        col1,
                        col2
                      ],
                    ),
                  );
              
            },
          ),
        ),
      ),
    );
  }
}
