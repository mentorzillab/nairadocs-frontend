import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../domain/entities/document.dart';
import '../bloc/documents_bloc.dart';
import '../bloc/documents_event.dart';
import '../bloc/documents_state.dart';

class DocumentUploadPage extends StatefulWidget {
  final DocumentType? initialType;

  const DocumentUploadPage({
    super.key,
    this.initialType,
  });

  @override
  State<DocumentUploadPage> createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends State<DocumentUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _documentNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  DocumentType _selectedType = DocumentType.nin;
  DateTime? _selectedDateOfBirth;
  DateTime? _selectedExpiryDate;
  String? _selectedGender;
  List<File> _selectedFiles = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null) {
      _selectedType = widget.initialType!;
    }
  }

  @override
  void dispose() {
    _documentNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Upload Document'),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.darkText,
      ),
      body: BlocListener<DocumentsBloc, DocumentsState>(
        listener: (context, state) {
          if (state is DocumentUploadError) {
            ErrorSnackBar.show(context, state.message);
          } else if (state is DocumentUploadSuccess) {
            SuccessSnackBar.show(context, 'Document uploaded successfully!');
            Navigator.of(context).pop(state.document);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Document type selection
                const Text(
                  'Document Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DocumentType>(
                      value: _selectedType,
                      onChanged: (DocumentType? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedType = newValue;
                            // Clear form when type changes
                            _clearForm();
                          });
                        }
                      },
                      items: DocumentType.values.map((DocumentType type) {
                        return DropdownMenuItem<DocumentType>(
                          value: type,
                          child: Text(type.displayName),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Document number
                CustomTextField(
                  label: '${_selectedType.displayName} Number',
                  hint: 'Enter your ${_selectedType.displayName.toLowerCase()} number',
                  controller: _documentNumberController,
                  validator: (value) => Validators.validateDocumentNumber(value, _selectedType.displayName),
                  keyboardType: _selectedType == DocumentType.nin || _selectedType == DocumentType.bvn
                      ? TextInputType.number
                      : TextInputType.text,
                ),
                const SizedBox(height: 20),

                // Conditional fields based on document type
                if (_requiresPersonalInfo()) ...[
                  // First Name
                  CustomTextField(
                    label: 'First Name',
                    hint: 'Enter your first name',
                    controller: _firstNameController,
                    validator: (value) => Validators.validateName(value, 'First name'),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 20),

                  // Last Name
                  CustomTextField(
                    label: 'Last Name',
                    hint: 'Enter your last name',
                    controller: _lastNameController,
                    validator: (value) => Validators.validateName(value, 'Last name'),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 20),

                  // Middle Name (optional)
                  CustomTextField(
                    label: 'Middle Name (Optional)',
                    hint: 'Enter your middle name',
                    controller: _middleNameController,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 20),

                  // Date of Birth
                  _buildDateField(
                    label: 'Date of Birth',
                    selectedDate: _selectedDateOfBirth,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDateOfBirth = date;
                      });
                    },
                    isRequired: true,
                  ),
                  const SizedBox(height: 20),

                  // Gender
                  _buildGenderField(),
                  const SizedBox(height: 20),
                ],

                if (_requiresExpiryDate()) ...[
                  // Expiry Date
                  _buildDateField(
                    label: 'Expiry Date',
                    selectedDate: _selectedExpiryDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedExpiryDate = date;
                      });
                    },
                    isRequired: true,
                    isFutureDate: true,
                  ),
                  const SizedBox(height: 20),
                ],

                // File upload section
                _buildFileUploadSection(),
                const SizedBox(height: 32),

                // Upload button
                BlocBuilder<DocumentsBloc, DocumentsState>(
                  builder: (context, state) {
                    return LoadingButton(
                      onPressed: _handleUpload,
                      text: 'Upload Document',
                      isLoading: state is DocumentUploadLoading,
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
    required bool isRequired,
    bool isFutureDate = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? (isFutureDate ? DateTime.now().add(const Duration(days: 365)) : DateTime.now()),
              firstDate: isFutureDate ? DateTime.now() : DateTime(1900),
              lastDate: isFutureDate ? DateTime(2100) : DateTime.now(),
            );
            if (picked != null) {
              onDateSelected(picked);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.lightText, size: 20),
                const SizedBox(width: 12),
                Text(
                  selectedDate != null
                      ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                      : 'Select $label',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedDate != null ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedGender,
              hint: const Text('Select Gender'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
              items: ['Male', 'Female', 'Other'].map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Document Files',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Upload clear photos or scans of your ${_selectedType.displayName.toLowerCase()}',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.lightText,
          ),
        ),
        const SizedBox(height: 16),

        // File upload area
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                style: BorderStyle.solid,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary.withOpacity(0.05),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 40,
                  color: AppColors.primary.withOpacity(0.7),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap to upload files',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'JPG, PNG, PDF (Max 5MB each)',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.lightText,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Selected files
        if (_selectedFiles.isNotEmpty) ...[
          const Text(
            'Selected Files:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 8),
          ...(_selectedFiles.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file, color: AppColors.lightText),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      file.path.split('/').last,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedFiles.removeAt(index);
                      });
                    },
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                  ),
                ],
              ),
            );
          }).toList()),
        ],
      ],
    );
  }

  bool _requiresPersonalInfo() {
    return _selectedType == DocumentType.nin || _selectedType == DocumentType.bvn;
  }

  bool _requiresExpiryDate() {
    return _selectedType == DocumentType.driversLicense || _selectedType == DocumentType.passport;
  }

  void _clearForm() {
    _documentNumberController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _middleNameController.clear();
    _addressController.clear();
    _phoneController.clear();
    _emailController.clear();
    _selectedDateOfBirth = null;
    _selectedExpiryDate = null;
    _selectedGender = null;
    _selectedFiles.clear();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();

      if (images.isNotEmpty) {
        setState(() {
          _selectedFiles = images.map((xFile) => File(xFile.path)).toList();
        });
      }
    } catch (e) {
      ErrorSnackBar.show(context, 'Failed to pick images: $e');
    }
  }

  void _handleUpload() {
    if (_formKey.currentState?.validate() ?? false) {
      // Validate required fields based on document type
      if (_requiresPersonalInfo()) {
        if (_selectedDateOfBirth == null) {
          ErrorSnackBar.show(context, 'Date of birth is required');
          return;
        }
        if (_selectedGender == null) {
          ErrorSnackBar.show(context, 'Gender is required');
          return;
        }
      }

      if (_requiresExpiryDate() && _selectedExpiryDate == null) {
        ErrorSnackBar.show(context, 'Expiry date is required');
        return;
      }

      if (_selectedFiles.isEmpty) {
        ErrorSnackBar.show(context, 'Please select at least one file');
        return;
      }

      // Create upload request
      final request = DocumentUploadRequest(
        type: _selectedType,
        documentNumber: _documentNumberController.text.trim(),
        firstName: _firstNameController.text.trim().isEmpty ? null : _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim().isEmpty ? null : _lastNameController.text.trim(),
        middleName: _middleNameController.text.trim().isEmpty ? null : _middleNameController.text.trim(),
        dateOfBirth: _selectedDateOfBirth,
        gender: _selectedGender,
        address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        filePaths: _selectedFiles.map((file) => file.path).toList(),
        expiryDate: _selectedExpiryDate,
      );

      // Trigger upload
      context.read<DocumentsBloc>().add(DocumentUploadRequested(request: request));
    }
  }
}
