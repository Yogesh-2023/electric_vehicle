part of '../main.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalInfoScreen(
      title: 'Privacy Policy',
      sections: [
        LegalSection(
          '1. Information Collection',
          'We collect customer, technician, vehicle and inspection data required to manage EV service requests and job cards.',
        ),
        LegalSection(
          '2. Use of Information',
          'Information is used for service booking, inspection workflow, status updates, reporting and customer communication.',
        ),
        LegalSection(
          '3. Data Protection',
          'We use operational controls to protect customer records, vehicle details, uploaded photos and technician observations.',
        ),
        LegalSection(
          '4. Service Records',
          'Inspection photos, remarks and job status may be stored as part of the service history and quality process.',
        ),
        LegalSection(
          '5. Consent',
          'By using EV Service, you consent to this privacy policy and transparent data handling practices.',
        ),
      ],
    );
  }
}

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalInfoScreen(
      title: 'Terms & Conditions',
      sections: [
        LegalSection(
          '1. Platform Usage',
          'EV Service is intended for service booking, technician inspections, job sheets and workflow tracking.',
        ),
        LegalSection(
          '2. Customer Responsibility',
          'Customers must provide accurate vehicle, contact and complaint details before inspection.',
        ),
        LegalSection(
          '3. Technician Workflow',
          'Technicians must capture honest observations, photos, repair needs and final status during pre-inspection.',
        ),
        LegalSection(
          '4. Estimates',
          'Estimated costs and delivery dates may change after detailed diagnosis, parts availability or customer approval.',
        ),
        LegalSection(
          '5. Acceptance',
          'Using this application means you agree to the operational terms of EV Service.',
        ),
      ],
    );
  }
}

class LegalInfoScreen extends StatelessWidget {
  const LegalInfoScreen({
    super.key,
    required this.title,
    required this.sections,
  });

  final String title;
  final List<LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sections
              .map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        section.content,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.muted,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
