import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile? profile;

  const EditProfilePage({
    super.key,
    this.profile,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _occupationController = TextEditingController();

  DateTime? _selectedDateOfBirth;
  String? _selectedGender;
  String? _profileImagePath;
  bool _isLoading = false;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (widget.profile != null) {
      final profile = widget.profile!;
      _firstNameController.text = profile.firstName;
      _lastNameController.text = profile.lastName;
      _middleNameController.text = profile.middleName ?? '';
      _phoneController.text = profile.phoneNumber ?? '';
      _addressController.text = profile.address ?? '';
      _cityController.text = profile.city ?? '';
      _stateController.text = profile.state ?? '';
      _countryController.text = profile.country ?? '';
      _postalCodeController.text = profile.postalCode ?? '';
      _occupationController.text = profile.occupation ?? '';
      _selectedDateOfBirth = profile.dateOfBirth;
      _selectedGender = profile.gender;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.darkText,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image Section
              _buildProfileImageSection(),
              const SizedBox(height: 32),

              // Personal Information
              _buildSectionHeader('Personal Information'),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _firstNameController,
                      label: 'First Name',
                      validator: (value) => Validators.validateName(value, 'First name'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _lastNameController,
                      label: 'Last Name',
                      validator: (value) => Validators.validateName(value, 'Last name'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _middleNameController,
                label: 'Middle Name (Optional)',
                validator: (value) => value != null && value.isNotEmpty 
                    ? Validators.validateName(value, 'Middle name') 
                    : null,
              ),
              const SizedBox(height: 16),

              // Date of Birth
              _buildDateField(
                label: 'Date of Birth',
                value: _selectedDateOfBirth,
                onTap: _selectDateOfBirth,
              ),
              const SizedBox(height: 16),

              // Gender
              _buildGenderField(),
              const SizedBox(height: 32),

              // Contact Information
              _buildSectionHeader('Contact Information'),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhoneNumber,
              ),
              const SizedBox(height: 32),

              // Address Information
              _buildSectionHeader('Address Information'),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _addressController,
                label: 'Street Address',
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _cityController,
                      label: 'City',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _stateController,
                      label: 'State/Province',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _countryController,
                      label: 'Country',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _postalCodeController,
                      label: 'Postal Code',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Professional Information
              _buildSectionHeader('Professional Information'),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _occupationController,
                label: 'Occupation',
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: _profileImagePath != null 
                ? FileImage(File(_profileImagePath!)) as ImageProvider
                : widget.profile?.profileImageUrl != null
                    ? NetworkImage(widget.profile!.profileImageUrl!)
                    : null,
            child: _profileImagePath == null && widget.profile?.profileImageUrl == null
                ? Text(
                    _getInitials(),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showImagePicker,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.darkText,
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value != null 
                        ? '${value.day}/${value.month}/${value.year}'
                        : 'Select date',
                    style: TextStyle(
                      fontSize: 16,
                      color: value != null ? AppColors.darkText : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: Colors.grey.shade500,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: const InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
      items: _genderOptions.map((gender) {
        return DropdownMenuItem(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedGender = value;
        });
      },
    );
  }

  String _getInitials() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    
    if (widget.profile != null) {
      return widget.profile!.initials;
    }
    
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_profileImagePath != null || widget.profile?.profileImageUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _profileImagePath = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _profileImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Create profile update request
      final request = ProfileUpdateRequest(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        middleName: _middleNameController.text.trim().isEmpty 
            ? null 
            : _middleNameController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty 
            ? null 
            : _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty 
            ? null 
            : _addressController.text.trim(),
        city: _cityController.text.trim().isEmpty 
            ? null 
            : _cityController.text.trim(),
        state: _stateController.text.trim().isEmpty 
            ? null 
            : _stateController.text.trim(),
        country: _countryController.text.trim().isEmpty 
            ? null 
            : _countryController.text.trim(),
        postalCode: _postalCodeController.text.trim().isEmpty 
            ? null 
            : _postalCodeController.text.trim(),
        dateOfBirth: _selectedDateOfBirth,
        gender: _selectedGender,
        occupation: _occupationController.text.trim().isEmpty 
            ? null 
            : _occupationController.text.trim(),
      );

      // Use ProfileBloc to update profile
      context.read<ProfileBloc>().add(ProfileUpdateRequested(request: request));

      // Listen for the result
      final subscription = context.read<ProfileBloc>().stream.listen((state) {
        if (state is ProfileUpdateSuccess) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );

          Navigator.of(context).pop(true);
        } else if (state is ProfileUpdateError) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      });

      // Clean up subscription after a delay
      Future.delayed(const Duration(seconds: 10), () {
        subscription.cancel();
        if (_isLoading) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
