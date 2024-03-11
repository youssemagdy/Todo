class Task{
  String? id;
  String? title;
  String? description;
  int? date;
  bool? isDone;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
  });

  Task.fromFirestore(Map<String, dynamic> data){
    id = data['id'];
    title = data['title'];
    description = data['description'];
    date = data['date'];
    isDone = data['isDone'];
  }

  Map<String, dynamic> toFirestore(){
    Map<String, dynamic> data = {
      'id' : id,
      'title' : title,
      'description' : description,
      'date' : date,
      'isDone' : isDone
    };
    return data;
  }
}