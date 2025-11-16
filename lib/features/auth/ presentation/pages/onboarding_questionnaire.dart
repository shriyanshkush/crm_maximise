import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/ios_typography.dart';

class OnboardingQuestionnaire extends StatefulWidget {
  const OnboardingQuestionnaire({super.key});

  @override
  State<OnboardingQuestionnaire> createState() =>
      _OnboardingQuestionnaireState();
}

class _OnboardingQuestionnaireState extends State<OnboardingQuestionnaire> {
  int currentStep = 0;
  
  // Controllers for text inputs
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
    // Validate current step
    if (currentStep == 0 && nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }
    if (currentStep == 1 && organizationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter organization name')),
      );
      return;
    }
    if (currentStep == 2 && phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone number')),
      );
      return;
    }
    if (currentStep == 3 && selectedLanguage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a language')),
      );
      return;
    }
    if (currentStep == 4 && selectedCurrency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a currency')),
      );
      return;
    }

    if (currentStep < 4) {
      setState(() {
        currentStep++;
      });
    } else {
      // Complete onboarding
      context.go(AppRoutes.home);
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            _buildProgressBar(),
            
            // Step indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Step ${currentStep + 2} of 8',
                style: IOSTypography.subheadline(
                  color: Colors.grey[600]!,
                  weight: FontWeight.w500,
                ),
              ),
            ),
            
            // Question content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildQuestionContent(),
              ),
            ),
            
            // Navigation buttons
            Padding(
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
                            style: IOSTypography.callout(
                              color: const Color(0xFF056BE3),
                              weight: FontWeight.w500,
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
                              style: IOSTypography.headline(
                                color: Colors.white,
                                weight: FontWeight.w600,
                              ),
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
            ),
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
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF056BE3)),
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

  Widget _buildNameQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s your name?',
          style: IOSTypography.title1(
            color: Colors.black87,
            weight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 40),
        TextField(
          controller: nameController,
          autofocus: true,
          style: IOSTypography.body(color: Colors.black87),
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            hintStyle: IOSTypography.body(color: Colors.grey[400]!),
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
          ),
        ),
      ],
    );
  }

  Widget _buildOrganizationQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Organization',
          style: IOSTypography.title1(
            color: Colors.black87,
            weight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 40),
        TextField(
          controller: organizationController,
          autofocus: true,
          style: IOSTypography.body(color: Colors.black87),
          decoration: InputDecoration(
            hintText: 'Enter your organization name',
            hintStyle: IOSTypography.body(color: Colors.grey[400]!),
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
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: IOSTypography.title1(
            color: Colors.black87,
            weight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 40),
        TextField(
          controller: phoneController,
          autofocus: true,
          keyboardType: TextInputType.phone,
          style: IOSTypography.body(color: Colors.black87),
          decoration: InputDecoration(
            hintText: '+1 234 567 8900',
            hintStyle: IOSTypography.body(color: Colors.grey[400]!),
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
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s your preferred language?',
          style: IOSTypography.title1(
            color: Colors.black87,
            weight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedLanguage,
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Select language',
                  style: IOSTypography.body(color: Colors.grey[400]!),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              borderRadius: BorderRadius.circular(12),
              items: languages.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(
                    language,
                    style: IOSTypography.body(color: Colors.black87),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s your preferred currency?',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCurrency,
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Select currency',
                  style: GoogleFonts.poppins(color: Colors.grey[400]),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              borderRadius: BorderRadius.circular(12),
              items: currencies.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(
                    currency,
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCurrency = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
