class ValidationService {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email é obrigatório';
    
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Email inválido';
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Senha é obrigatória';
    if (value.length < 6) return 'Senha deve ter pelo menos 6 caracteres';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Nome é obrigatório';
    if (value.length < 2) return 'Nome deve ter pelo menos 2 caracteres';
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName é obrigatório';
    return null;
  }

  static String? validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName é obrigatório';
    
    final number = int.tryParse(value);
    if (number == null || number <= 0) return '$fieldName deve ser um número positivo';
    
    return null;
  }

  static String? validatePositiveDouble(String? value, String fieldName) {
    if (value == null || value.isEmpty) return null; // Optional field
    
    final number = double.tryParse(value);
    if (number == null || number <= 0) return '$fieldName deve ser um número positivo';
    
    return null;
  }
}