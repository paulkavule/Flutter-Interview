enum AccountType {
  individual('Individual', 'A personal account for an individual user.'),
  business('Business', 'An account for a company or organization.');

  const AccountType(this.label, this.description);

  final String label;

  final String description;
}
