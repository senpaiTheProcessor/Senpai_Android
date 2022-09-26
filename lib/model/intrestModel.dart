class IntrestModel {
  String? interest_id;
  String? interest_name;
  String? is_selected;
  IntrestModel({this.interest_id, this.interest_name, this.is_selected});
  
  factory IntrestModel.fromJson(Map<String, dynamic> json) {
    return IntrestModel(
        interest_id: json['interest_id'],
        interest_name: json['interest_name'],
        is_selected: json['is_selected'].toString(),
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return is_selected.toString();
  }
}
