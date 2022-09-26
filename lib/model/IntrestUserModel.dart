class IntrestUserModel {
  String? user_id;
  String? user_unique_id;
  String? name;
  String? mobile_number;
  String? email_id;
  String? country_id;
  String? state_id;
  String? city_id;
  String? rate_amount;
  String? user_bio;
  String? user_image;
  String? user_wallet_balance;
  String? avg_rating;

  IntrestUserModel({
    this.user_id,
    this.user_unique_id,
    this.name,
    this.mobile_number,
    this.email_id,
    this.country_id,
    this.state_id,
    this.city_id,
    this.rate_amount,
    this.user_bio,
    this.user_image,
    this.user_wallet_balance,
    this.avg_rating,
  });

  factory IntrestUserModel.fromJson(Map<String, dynamic> json) {
    return IntrestUserModel(
      user_id: json['user_id'],
      user_unique_id: json['user_unique_id'],
      name: json['name'].toString().length == 0? "N/A":json['name'],
      mobile_number: json['mobile_number'],
      email_id: json['email_id'],
      country_id: json['country_id'],
      state_id: json['state_id'],
      city_id: json['city_id'],
      rate_amount: json['rate_amount'].length ==0?"0.0":json['rate_amount'],
      user_bio: json['user_bio'],
      user_image: json['user_image'],
      user_wallet_balance: json['user_wallet_balance'],
      avg_rating: json['avg_rating'].length ==0?"0":json['avg_rating'],
    );
  }
}

/***
 * "         user_id": "31",
            "user_unique_id": "10031",
            "name": "kuldeep",
            "mobile_number": "5555555555",
            "email_id": "kuldeep@gmail.com",
            "country_id": "1",
            "state_id": "1",
            "city_id": "1",
            "rate_amount": "",
            "user_bio": "",
            "user_image": "",
            "user_wallet_balance": "",
            "avg_rating": ""
        },
      
 */