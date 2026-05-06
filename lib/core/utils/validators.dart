class Validators {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) return 'Title is required';
    if (value.trim().length < 3) return 'Title must be at least 3 characters';
    if (value.trim().length > 100) return 'Title cannot exceed 100 characters';
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) return 'Description is required';
    if (value.trim().length < 10) return 'Please provide more details (min 10 chars)';
    if (value.trim().length > 500) return 'Description cannot exceed 500 characters';
    return null;
  }

  static String? validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) return 'Location is required';
    return null;
  }
}
