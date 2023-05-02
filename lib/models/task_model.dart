class TaskModel {
  String? id;
  String? task;
  bool? status;

  TaskModel(this.id, this.task, this.status);

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    task = json['task'];
    status = json['status'] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task': task,
      'status': status,
    };
  }
}
