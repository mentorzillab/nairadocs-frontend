class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    
    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    
    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Name validation
  static String? validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters long';
    }
    
    // Check for valid name characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value.trim())) {
      return '$fieldName can only contain letters, spaces, hyphens, and apostrophes';
    }
    
    return null;
  }

  // Phone number validation (Nigerian format)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone number is optional
    }
    
    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // Check for Nigerian phone number patterns
    if (digitsOnly.length == 11 && digitsOnly.startsWith('0')) {
      // Local format: 08012345678
      return null;
    } else if (digitsOnly.length == 13 && digitsOnly.startsWith('234')) {
      // International format: 2348012345678
      return null;
    } else if (digitsOnly.length == 10 && !digitsOnly.startsWith('0')) {
      // Without country code: 8012345678
      return null;
    }
    
    return 'Please enter a valid Nigerian phone number';
  }

  // NIN validation (Nigerian National Identification Number)
  static String? validateNIN(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIN is required';
    }
    
    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length != 11) {
      return 'NIN must be exactly 11 digits';
    }
    
    return null;
  }

  // BVN validation (Bank Verification Number)
  static String? validateBVN(String? value) {
    if (value == null || value.isEmpty) {
      return 'BVN is required';
    }
    
    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length != 11) {
      return 'BVN must be exactly 11 digits';
    }
    
    return null;
  }



  // Date validation
  static String? validateDate(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    try {
      final date = DateTime.parse(value);
      final now = DateTime.now();
      
      if (date.isAfter(now)) {
        return '$fieldName cannot be in the future';
      }
      
      return null;
    } catch (e) {
      return 'Please enter a valid date';
    }
  }

  // Age validation
  static String? validateAge(String? value, {int minAge = 18, int maxAge = 120}) {
    if (value == null || value.isEmpty) {
      return 'Date of birth is required';
    }
    
    try {
      final birthDate = DateTime.parse(value);
      final now = DateTime.now();
      final age = now.year - birthDate.year;
      
      if (birthDate.isAfter(now)) {
        return 'Date of birth cannot be in the future';
      }
      
      if (age < minAge) {
        return 'You must be at least $minAge years old';
      }
      
      if (age > maxAge) {
        return 'Please enter a valid date of birth';
      }
      
      return null;
    } catch (e) {
      return 'Please enter a valid date of birth';
    }
  }

  /// Validates document number based on document type
  static String? validateDocumentNumber(String? value, String documentType) {
    if (value == null || value.trim().isEmpty) {
      return '$documentType number is required';
    }

    final trimmedValue = value.trim();

    // Type-specific validation
    switch (documentType.toLowerCase()) {
      case 'nin':
      case 'national identification number':
        final digitsOnly = trimmedValue.replaceAll(RegExp(r'[^\d]'), '');
        if (digitsOnly.length != 11) {
          return 'NIN must be exactly 11 digits';
        }
        break;
      case 'bvn':
      case 'bank verification number':
        final digitsOnly = trimmedValue.replaceAll(RegExp(r'[^\d]'), '');
        if (digitsOnly.length != 11) {
          return 'BVN must be exactly 11 digits';
        }
        break;
      case 'driver\'s license':
      case 'drivers license':
        if (trimmedValue.length < 5) {
          return 'Driver\'s license number must be at least 5 characters';
        }
        break;
      case 'international passport':
      case 'passport':
        if (trimmedValue.length < 6) {
          return 'Passport number must be at least 6 characters';
        }
        break;
      case 'waec':
      case 'waec certificate':
        if (trimmedValue.length < 8) {
          return 'WAEC number must be at least 8 characters';
        }
        break;
      case 'jamb':
      case 'jamb result':
        if (trimmedValue.length < 8) {
          return 'JAMB number must be at least 8 characters';
        }
        break;
      default:
        if (trimmedValue.length < 3) {
          return '$documentType number must be at least 3 characters';
        }
    }

    return null;
  }
}
