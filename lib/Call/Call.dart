// ignore_for_file: file_names

class Call {
  final String call;
  final String sender;
  final String receiver;

  final DateTime date;

  Call(this.call, this.date, this.sender, this.receiver);
  Call.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        call = json['message'] as String,
        sender = json['sender'] as String,
        receiver = json['receiver'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'date': date.toString(),
        'message': call,
        'sender': sender,
        'receiver': receiver,
      };
}
