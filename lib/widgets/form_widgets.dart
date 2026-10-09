part of '../main.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.text,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class JobFormSection extends StatelessWidget {
  const JobFormSection({super.key, required this.section});

  final FormSectionData section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(section.icon, color: AppColors.primary, size: 21),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            if (section.fields.isNotEmpty) ...[
              const SizedBox(height: 14),
              ...section.fields.map((field) => JobTextField(label: field)),
            ],
            if (section.checks.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: section.checks.map((label) {
                  return ChoiceChip(
                    label: Text(label),
                    selected: false,
                    onSelected: (_) {},
                    showCheckmark: false,
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.greenSoft,
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }).toList(),
              ),
            ],
            if (section.photos.isNotEmpty) ...[
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: Responsive.isCompact(context) ? 2 : 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.35,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: section.photos
                    .map((photo) => PhotoUploadTile(label: photo))
                    .toList(),
              ),
            ],
            if (section.passFailChecks.isNotEmpty) ...[
              const SizedBox(height: 14),
              ...section.passFailChecks.map((check) => _PassFailRow(label: check)),
            ],
          ],
        ),
      ),
    );
  }
}

class _PassFailRow extends StatefulWidget {
  const _PassFailRow({required this.label});
  final String label;

  @override
  State<_PassFailRow> createState() => _PassFailRowState();
}

class _PassFailRowState extends State<_PassFailRow> {
  bool? _isPass;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ChoiceChip(
                label: const Text('Pass'),
                selected: _isPass == true,
                onSelected: (val) {
                  if (val) setState(() => _isPass = true);
                },
                showCheckmark: false,
                backgroundColor: AppColors.surface,
                selectedColor: AppColors.greenSoft,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _isPass == true ? AppColors.green : AppColors.muted,
                ),
                side: BorderSide(
                  color: _isPass == true ? AppColors.green : AppColors.border,
                ),
              ),
              const SizedBox(width: 6),
              ChoiceChip(
                label: const Text('Fail'),
                selected: _isPass == false,
                onSelected: (val) {
                  if (val) setState(() => _isPass = false);
                },
                showCheckmark: false,
                backgroundColor: AppColors.surface,
                selectedColor: const Color(0xFFFEF2F2),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _isPass == false ? Colors.red : AppColors.muted,
                ),
                side: BorderSide(
                  color: _isPass == false ? Colors.red : AppColors.border,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class JobTextField extends StatefulWidget {
  const JobTextField({super.key, required this.label});

  final String label;
  static String? currentError;
  static final values = <String, String>{};

  static void clearValues() {
    values.clear();
  }

  @override
  State<JobTextField> createState() => _JobTextFieldState();
}

class _JobTextFieldState extends State<JobTextField> {
  final TextEditingController _controller = TextEditingController();
  static const _vehicleBrands = [
    'Ather',
    'Bajaj',
    'Hero Electric',
    'Ola Electric',
    'TVS',
    'Vida',
    'Ampere',
    'Okaya',
    'Simple Energy',
    'Greaves Electric',
  ];
  static const _vehicleModels = [
    'Ather 450X',
    'Ather Rizta',
    'Bajaj Chetak',
    'Hero Optima CX',
    'Ola S1 Pro',
    'Ola S1 Air',
    'TVS iQube',
    'Vida V1 Pro',
    'Ampere Magnus EX',
    'Simple One',
  ];
  static const _vehicleTypes = [
    'Electric Scooter',
    'Electric Bike',
    'Electric Moped',
    'Electric Motorcycle',
    'Electric Cargo Scooter',
    'Electric Delivery Bike',
    'Low Speed EV Scooter',
    'High Speed EV Scooter',
  ];

  String get label => widget.label;

  @override
  void initState() {
    super.initState();
    final existing = JobTextField.values[widget.label];
    if (existing != null && existing.isNotEmpty) {
      _controller.text = existing;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLong =
        label.contains('Description') ||
        label.contains('Observation') ||
        label.contains('Repairs') ||
        label.contains('Remarks') ||
        label.contains('Address') ||
        label.contains('Other') ||
        label.contains('Others');
    final isMobile = label.contains('Mobile');
    final isEmail = label.contains('Email');
    final isNumber =
        label.contains('Cost') ||
        label.contains('Percentage') ||
        label.contains('Odometer');
    final isDate = label.contains('Date');
    final isVehicleBrand = label == 'Vehicle Brand';
    final isVehicleModel = label == 'Vehicle Model';
    final isVehicleType = label == 'Vehicle Type';
    final isSelector = isVehicleBrand || isVehicleModel || isVehicleType;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldLabel(label),
          const SizedBox(height: 8),
          TextFormField(
            controller: _controller,
            onChanged: (value) {
              JobTextField.values[label] = value.trim();
            },
            readOnly: isDate || isSelector,
            onTap: () {
              if (isDate) {
                _pickDate(context, includeTime: label.contains('Date & Time'));
              } else if (isSelector) {
                _showOptionSheet(
                  context,
                  title: isVehicleBrand
                      ? 'Select Make'
                      : isVehicleModel
                          ? 'Select Model'
                          : 'Select Vehicle Type',
                  options: isVehicleBrand
                      ? _vehicleBrands
                      : isVehicleModel
                          ? _vehicleModels
                          : _vehicleTypes,
                );
              }
            },
            minLines: isLong ? 2 : 1,
            maxLines: isLong ? 3 : 1,
            keyboardType: isLong
                ? TextInputType.multiline
                : isEmail
                    ? TextInputType.emailAddress
                    : isMobile
                        ? TextInputType.phone
                        : isNumber
                            ? const TextInputType.numberWithOptions(decimal: true)
                            : TextInputType.text,
            textInputAction: isLong
                ? TextInputAction.newline
                : TextInputAction.next,
            inputFormatters: [
              if (isMobile) FilteringTextInputFormatter.digitsOnly,
              if (isMobile) LengthLimitingTextInputFormatter(10),
              if (isNumber) FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            validator: _validate,
            decoration: InputDecoration(
              isDense: true,
              hintText: _hintText ?? 'Enter $label',
              suffixIcon: isDate || isSelector
                  ? Icon(
                      isDate
                          ? Icons.calendar_month_outlined
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary,
                    )
                  : null,
              errorMaxLines: 1,
              errorStyle: const TextStyle(
                height: 0.01,
                fontSize: 0.01,
                color: Colors.transparent,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showOptionSheet(
    BuildContext context, {
    required String title,
    required List<String> options,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final sheetHeight = MediaQuery.sizeOf(context).height * 0.68;
        return SafeArea(
          top: false,
          child: Container(
            height: sheetHeight.clamp(360.0, 620.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 52,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 18, 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF374151),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
                    itemCount: options.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: Color(0xFFE5E7EB),
                    ),
                    itemBuilder: (context, index) {
                      final option = options[index];
                      return InkWell(
                        onTap: () => Navigator.pop(context, option),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          child: Text(
                            option,
                            style: const TextStyle(
                              color: AppColors.text,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || selected == null) return;
    setState(() {
      _controller.text = selected;
      JobTextField.values[label] = selected;
    });
  }

  Future<void> _pickDate(
    BuildContext context, {
    required bool includeTime,
  }) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 30),
      lastDate: DateTime(now.year + 10),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              secondary: AppColors.green,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate == null) return;

    TimeOfDay? pickedTime;
    if (includeTime && context.mounted) {
      pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primary,
                secondary: AppColors.green,
              ),
            ),
            child: child!,
          );
        },
      );
      if (pickedTime == null) return;
    }

    final day = pickedDate.day.toString().padLeft(2, '0');
    final month = pickedDate.month.toString().padLeft(2, '0');
    final year = pickedDate.year.toString();
    final formattedDate = '$day/$month/$year';
    if (!mounted) return;
    setState(() {
      if (pickedTime == null) {
        _controller.text = formattedDate;
      } else {
        final hour = pickedTime.hour.toString().padLeft(2, '0');
        final minute = pickedTime.minute.toString().padLeft(2, '0');
        _controller.text = '$formattedDate $hour:$minute';
      }
      JobTextField.values[label] = _controller.text;
    });
  }

  String? get _hintText {
    if (label.contains('Mobile')) return '10 digit mobile number';
    if (label.contains('Email')) return 'name@example.com';
    if (label.contains('Percentage')) return '0 to 100';
    if (label.contains('Odometer')) return 'KM reading';
    if (label.contains('Cost')) return 'Amount';
    if (label.contains('Date & Time')) return 'Select date and time';
    if (label.contains('Date')) return 'Select date';
    return null;
  }

  String? _validate(String? value) {
    final text = value?.trim() ?? '';
    final isOptional = label.contains('Optional');
    String? error;

    if (!isOptional && text.isEmpty) {
      error = '$label is required';
    } else if (isOptional && text.isEmpty) {
      error = null;
    } else if (label.contains('Mobile')) {
      if (!RegExp(r'^[6-9]\d{9}$').hasMatch(text)) {
        error = 'Enter a valid 10 digit mobile number';
      }
    } else if (label.contains('Email')) {
      final isValidEmail = RegExp(
        r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
      ).hasMatch(text);
      if (!isValidEmail) error = 'Enter a valid email address';
    } else if (label.contains('Percentage')) {
      final percentage = double.tryParse(text);
      if (percentage == null || percentage < 0 || percentage > 100) {
        error = 'Enter percentage between 0 and 100';
      }
    } else if (label.contains('Odometer') || label.contains('Cost')) {
      final number = double.tryParse(text);
      if (number == null || number < 0) error = 'Enter a valid number for $label';
    } else if (label.contains('Date')) {
      final datePattern = RegExp(r'^\d{2}/\d{2}/\d{4}(\s+\d{1,2}:\d{2})?$');
      if (!datePattern.hasMatch(text)) {
        error = label.contains('Date & Time')
            ? 'Select a valid date and time'
            : 'Select a valid date';
      }
    } else if (label.contains('Vehicle Number')) {
      if (!RegExp(
        r'^[A-Z]{2}\s?\d{1,2}\s?[A-Z]{1,3}\s?\d{4}$',
      ).hasMatch(text.toUpperCase())) {
        error = 'Enter a valid vehicle number';
      }
    } else if ((label.contains('Chassis') ||
            label.contains('Motor') ||
            label.contains('Battery')) &&
        text.length < 5) {
      error = '$label must be at least 5 characters';
    }

    if (error != null) {
      JobTextField.currentError ??= error;
    }
    return error;
  }
}

class PhotoUploadTile extends StatefulWidget {
  const PhotoUploadTile({super.key, required this.label});

  final String label;

  @override
  State<PhotoUploadTile> createState() => _PhotoUploadTileState();
}

class _PhotoUploadTileState extends State<PhotoUploadTile> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    try {
      final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Upload Photo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPickerOption(
                    context,
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                  _buildPickerOption(
                    context,
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickerOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.text,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showImagePicker(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          image: _imageFile != null
              ? DecorationImage(
                  image: FileImage(File(_imageFile!.path)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo_outlined, color: AppColors.primary),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ],
              )
            : Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 16),
                      onPressed: () {
                        setState(() {
                          _imageFile = null;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
