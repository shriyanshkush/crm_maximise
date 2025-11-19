import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingQuestionnaire extends StatefulWidget {
  const OnboardingQuestionnaire({super.key});

  @override
  State<OnboardingQuestionnaire> createState() =>
      _OnboardingQuestionnaireState();
}

class _OnboardingQuestionnaireState extends State<OnboardingQuestionnaire> {
  int currentStep = 0;

  // Controllers
  final nameController = TextEditingController();
  final organizationController = TextEditingController();
  final phoneController = TextEditingController();

  // Selected values
  String? selectedLanguage;
  String? selectedCurrency;

  final List<String> languages = ['English', 'Hindi', 'Spanish', 'French'];
  final List<String> currencies = [
    'USD - US Dollar',
    'INR - Indian Rupee',
    'EUR - Euro',
    'GBP - British Pound'
  ];

  @override
  void dispose() {
    nameController.dispose();
    organizationController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (currentStep == 0 && nameController.text.isEmpty) {
      _showError('Please enter your name');
      return;
    }
    if (currentStep == 1 && organizationController.text.isEmpty) {
      _showError('Please enter organization name');
      return;
    }
    if (currentStep == 2 && phoneController.text.isEmpty) {
      _showError('Please enter phone number');
      return;
    }
    if (currentStep == 3 && selectedLanguage == null) {
      _showError('Please select a language');
      return;
    }
    if (currentStep == 4 && selectedCurrency == null) {
      _showError('Please select a currency');
      return;
    }

    if (currentStep < 4) {
      setState(() => currentStep++);
    } else {
      context.go(AppRoutes.home);
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Step ${currentStep + 2} of 8',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildQuestionContent(),
              ),
            ),

            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: LinearProgressIndicator(
          value: (currentStep + 2) / 8,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation(Color(0xFF056BE3)),
        ),
      ),
    );
  }

  Widget _buildQuestionContent() {
    switch (currentStep) {
      case 0:
        return _buildNameQuestion();
      case 1:
        return _buildOrganizationQuestion();
      case 2:
        return _buildPhoneQuestion();
      case 3:
        return _buildLanguageQuestion();
      case 4:
        return _buildCurrencyQuestion();
      default:
        return const SizedBox();
    }
  }

  // --------------------------------------------------------
  // QUESTIONS
  // --------------------------------------------------------

  Widget _buildNameQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What's your name?", style: AppTextStyles.headlineLarge),
        const SizedBox(height: 40),
        TextField(
          controller: nameController,
          style: AppTextStyles.bodyLarge,
          decoration: _inputDecoration("Enter your full name"),
        ),
      ],
    );
  }

  Widget _buildOrganizationQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Organization", style: AppTextStyles.headlineLarge),
        const SizedBox(height: 40),
        TextField(
          controller: organizationController,
          style: AppTextStyles.bodyLarge,
          decoration: _inputDecoration("Enter your organization name"),
        ),
      ],
    );
  }

  Widget _buildPhoneQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Phone Number", style: AppTextStyles.headlineLarge),
        const SizedBox(height: 40),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          style: AppTextStyles.bodyLarge,
          decoration: _inputDecoration("+1 234 567 8900"),
        ),
      ],
    );
  }

  Widget _buildLanguageQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What's your preferred language?", style: AppTextStyles.headlineLarge),
        const SizedBox(height: 40),
        _styledDropdown(
          value: selectedLanguage,
          hint: "Select language",
          items: languages,
          onChanged: (v) => setState(() => selectedLanguage = v),
        ),
      ],
    );
  }

  Widget _buildCurrencyQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What's your preferred currency?", style: AppTextStyles.headlineLarge),
        const SizedBox(height: 40),
        _styledDropdown(
          value: selectedCurrency,
          hint: "Select currency",
          items: currencies,
          onChanged: (v) => setState(() => selectedCurrency = v),
        ),
      ],
    );
  }

  // --------------------------------------------------------
  // COMPONENTS
  // --------------------------------------------------------

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodySmall,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF056BE3), width: 2),
      ),
      contentPadding: const EdgeInsets.all(20),
    );
  }

  Widget _styledDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(hint, style: AppTextStyles.bodySmall),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          borderRadius: BorderRadius.circular(12),
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: AppTextStyles.bodyLarge),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          if (currentStep > 0)
            OutlinedButton(
              onPressed: _previousStep,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                side: const BorderSide(color: Color(0xFF056BE3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Back',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: const Color(0xFF056BE3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          const Spacer(),

          Expanded(
            flex: 2,
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF056BE3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentStep < 4 ? 'Continue' : 'Complete',
                      style: AppTextStyles.button,
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
