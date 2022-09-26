// ignore_for_file: camel_case_types, non_constant_identifier_names, prefer_typing_uninitialized_variables, file_names

class studyFieldModel {
  var study_field_id;
  var field_name;
  var is_active;
  var created;

  studyFieldModel(
    this.study_field_id,
    this.field_name,
    this.is_active,
    this.created,
  );
}

/**"         study_field_id": "1",
            "field_name": "Art Study",
            "is_active": "1",
            "created": "2022-06-24 15:30:55"
        }, */