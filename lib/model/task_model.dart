
class Task {
  String id;
  String name;
  String customer;
  String status;
  int urgent;

  Task({
    required this.id,
    required this.name,
    required this.customer,
    required this.status,
    required this.urgent,
  });

  factory Task.createTasks(Map<String, dynamic> object) {

    return Task(
      id: object["id"].toString(),
      name: object["name"],
      customer: object["customer"],
      status: object["status"],
      urgent: object["urgent"],
    );
  }

}
