class Job {
  String name; // stores the name of the entity
  DateTime timeStart; // stores the start time of the event
  DateTime timeEnd; // stores the end time of the event
  String message; // stores the message associated with the entity
  bool isSuccess; // stores whether the operation was a success

  Job({
    required this.name,
    required this.timeStart,
    required this.timeEnd,
    required this.message,
    this.isSuccess = true,
  });
}
