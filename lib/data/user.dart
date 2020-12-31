class User {
  final String name;
  final String company;
  final String email;
  final String company_id;
  final String id;
  final bool is_head;
  final bool is_approved;

  User(this.name, this.company, this.email, this.company_id, this.id,
      this.is_head, this.is_approved);

  User.fromJson(Map<String, dynamic> json)
      : name = json['user']['name'],
        company = json['company_name'],
        email = json['user']['email'],
        company_id = json['user']['company_id'],
        id = json['user']['id'],
        is_head = json['user']['is_head'],
        is_approved = json['user']['is_approved'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'company': company,
      };
}
