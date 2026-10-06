String? requiredField(String? value, String label) =>
    (value == null || value.trim().isEmpty) ? '$label is required' : null;
