// ignore_for_file: file_names, non_constant_identifier_names

class ReciviedModel {
  
  String? user_request_id;
  String? user_id;
  String? teacher_id;
  String? interest_id;
  String? question;
  String? note;
  String? teacher_note;
  String? request_status;
  String? request_date;
  String? request_time;
  String? call_rate;
  String? call_duration;
  String? total_amount;
  String? created;
  String? updated;
  String? interest_name;
  String? user_unique_id;
  String? name;
  String? email_id;
  String? user_image;
  String? t_user_unique_id;
  String? t_name;
  String? t_email_id;
  String? t_user_image;
  String? t_device_token;
  String? t_user_wallet_balance;
  String? user_wallet_balance;
  String? device_token;
  
  ReciviedModel({
    this.user_request_id,
    this.user_id,
    this.teacher_id,
    this.interest_id,
    this.question,
    this.note,
    this.teacher_note,
    this.request_status,
    this.request_date,
    this.request_time,
    this.call_rate,
    this.call_duration,
    this.total_amount,
    this.created,
    this.updated,
    this.interest_name,
    this.user_unique_id,
    this.name,
    this.email_id,
    this.user_image,
    this.t_user_unique_id,
    this.t_name,
    this.t_email_id,
    this.t_user_image,
    this.t_device_token,
    this.t_user_wallet_balance,
    this.user_wallet_balance,
    this.device_token,
  });

  factory ReciviedModel.fromJson(Map<String, dynamic> json) {
    return ReciviedModel(
      user_request_id: json['user_request_id'],
      user_id: json['user_id'],
      teacher_id: json['teacher_id'],
      interest_id: json['interest_id'],
      question: json['question'],
      note: json['note'],
            teacher_note: json['teacher_note'],

      request_status: json['request_status'],
      request_date: json['request_date'],
      request_time: json['request_time'],
      call_rate: json['call_rate'],
      call_duration: json['call_duration'],
      total_amount: json['total_amount'],
      created: json['created'],
      updated: json['updated'],
      interest_name: json['interest_name'],
      user_unique_id: json['user_unique_id'],
      name: json['name'].length == 0 ? "N/A" : json['name'],
      email_id: json['email_id'],
      user_image: json['user_image'],
      t_user_unique_id: json['t_user_unique_id'],
      t_name: json['t_name'],
      t_email_id: json['t_email_id'],
      t_user_image: json['t_user_image'],
      t_device_token: json['t_device_token'],
            t_user_wallet_balance: json['t_user_wallet_balance'],

      user_wallet_balance: json['user_wallet_balance'],

      device_token: json['device_token'],
    );
  }
}

/***
 * "        "user_request_id": "10",
            "user_id": "2",
            "teacher_id": "1",
            "interest_id": "6",
            "question": "how are you",
            "note": "how are toge js wis sjsb",
            "request_status": "0",
            "request_date": "2022-06-22",
            "request_time": "17:20:29",
            "call_rate": " ",
            "call_duration": "",
            "total_amount": "",
            "created": "2022-06-22 06:51:02",
            "updated": "2022-06-22 06:51:02",
            "interest_name": "Photography",
            "user_unique_id": "10002",
            "name": "Nisha",
            "email_id": "nisha@gmail.com",
            "user_image": "",
            "t_user_unique_id": "10002",
            "t_name": "Nisha",
            "t_email_id": "nisha@gmail.com",
            "t_user_image": ""
       
             "user_request_id": "15",
            "user_id": "1",
            "teacher_id": "2",
            "interest_id": "9",
            "question": "dggf",
            "note": "dhvv",
            "request_status": "0",
            "request_date": "2022-06-22",
            "request_time": "17:58:03",
            "call_rate": " ",
            "call_duration": "",
            "total_amount": "",
            "created": "2022-06-22 07:28:06",
            "updated": "2022-06-22 07:28:06",
            "interest_name": "Start Up",
            "user_unique_id": "10001",
            "name": "Priya yadav",
            "email_id": "Priya@gmail.com",
            "user_image": "http://parkhya.org/senpai/uploads/user_image/64971.jpg",
            "t_user_unique_id": "10001",
            "t_name": "Priya yadav",
            "t_email_id": "Priya@gmail.com",
            "t_user_image": "http://parkhya.org/senpai/uploads/user_image/64971.jpg"
       
        },
      
 */