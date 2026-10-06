enum UserRole { user, company }

class User {
	const User({
		this.id,
		required this.firstName,
		required this.lastName,
		required this.email,
		required this.role,
		this.password,
		this.companyName,
	});

	factory User.fromJson(Map<String, dynamic> json) {
		final company = json['company'];
		final roleName = json['role'];
		return User(
			id: json['id'] as int?,
			firstName: json['firstName'] as String? ?? '',
			lastName: json['lastName'] as String? ?? '',
			email: json['email'] as String? ?? '',
			password: json['password'] as String?,
			role: UserRole.values.firstWhere(
				(role) => role.name == roleName,
				orElse: () => UserRole.user,
			),
			companyName: company is Map<String, dynamic>
					? company['name'] as String?
					: null,
		);
	}

	final int? id;
	final String firstName;
	final String lastName;
	final String email;
	final String? password;
	final UserRole role;
	final String? companyName;

	Map<String, dynamic> toJson() {
		return {
			'firstName': firstName,
			'lastName': lastName,
			'email': email,
			if (password != null) 'password': password,
			'role': role.name,
			if (role == UserRole.company && companyName != null)
				'company': {'name': companyName},
		};
	}
}
