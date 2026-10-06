class Company {
  const Company({required this.name});

  factory Company.fromJson(Map<String, dynamic> json) =>
      Company(name: json['name'] as String? ?? '');

  final String name;

  Map<String, dynamic> toJson() => {'name': name};
}
