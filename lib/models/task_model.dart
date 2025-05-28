class TaskModel {
  String? id; // id document trên Firestore (có thể null khi tạo mới)
  String userId;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;
  DateTime beginAt;
  DateTime endAt;
  String category;

  TaskModel({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.beginAt,
    required this.endAt,
    required this.category,
  });

  // Convert JSON to TaskModel
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      createdAt: DateTime.parse(json['createdAt']),
      beginAt: DateTime.parse(json['beginAt']),
      endAt: DateTime.parse(json['endAt']),
      category: json['category'], 
      userId: json['userId'],
    );
  }

  // Convert TaskModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'beginAt': beginAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
      'category': category,
      'userId': userId
    };
  }

  // Copy with optional overrides
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? beginAt,
    DateTime? endAt,
    String? category,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      beginAt: beginAt ?? this.beginAt,
      endAt: endAt ?? this.endAt,
      category: category ?? this.category, 
      userId: userId, // userId không thay đổi
    );
  }
}
