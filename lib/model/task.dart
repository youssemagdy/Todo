class Task{
  String? id;
  String? title;
  String? description;
  int? date;

  Task({this.id,required this.title, required this.description, required this.date});

  Task.fromFirestore(Map<String, dynamic> data){
    id = data['id'];
    title = data['title'];
    description = data['description'];
    date = data['date'];
  }

  Map<String, dynamic> toFirestore(){
    Map<String, dynamic> data = {
      'id' : id,
      'title' : title,
      'description' : description,
      'date' : date
    };
    return data;
  }
}