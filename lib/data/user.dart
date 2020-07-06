class User {
  final String name;
  final String company;
  final String email;
  final String company_id;
  final String user_id;
  final List platforms;
  final bool is_head;

  User(this.name, this.company, this.email, this.company_id, this.user_id,
      this.platforms, this.is_head);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'].toString(),
        company = json['company_name'],
        email = json['email'],
        company_id = json['company_id'],
        user_id = json['user_id'],
        platforms = json['platforms'],
        is_head = json['is_head'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'company': company,
      };
}
