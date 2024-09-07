class TaskModel {
  String? uId;
  String? title;
  String? description;

  TaskModel({this.title, this.description, required this.uId});

  TaskModel.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    description = json["description"];
    uId = json["uId"];
  }
  Map<String, dynamic> toJson() {
    return {"title": title, "description": description, "uId": uId};
  }
}
