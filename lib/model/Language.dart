class LanguageModel {
  String? language_id;
  String? language_name;
  String? is_selected;

  LanguageModel({this.language_id, this.language_name, this.is_selected});

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      language_id: json['language_id'],
      language_name: json['language_name'],
      is_selected: json['is_selected'].toString(),
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return is_selected.toString();
  }
}
