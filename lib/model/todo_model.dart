class TodoModel {
  String? taskname;
  String? tasktitile;
  bool? isCompleted;
  String? uId;

  TodoModel(
      {this.taskname, this.isCompleted = false, this.uId, this.tasktitile});

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      taskname: json['taskname'],
      tasktitile: json['titile'],
      isCompleted: json['isCompleted'] ?? false,
      uId: json['uId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskname': taskname,
      'titile': tasktitile,
      'isCompleted': isCompleted,
      'uId': uId,
    };
  }
}
