import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/support_provider.dart';
import '../../theme/app_theme.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  String _category = 'Authenticity & Certificate';
  final _orderIdController = TextEditingController(text: 'WH-9082-2026');
  final _detailsController = TextEditingController();

  final List<String> _issueCategories = [
    'Authenticity & Certificate',
    'Order Delivery & Courier Delay',
    'Warranty & Repair Service',
    'App Functionality & Account',
    'Other Special Inquiry',
  ];

  @override
  void dispose() {
    _orderIdController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _submitIssue() {
    if (_formKey.currentState!.validate()) {
      context.read<SupportProvider>().submitIssueReport(
            category: _category,
            orderId: _orderIdController.text.trim(),
            description: _detailsController.text.trim(),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Issue Ticket registered with WatchHub Concierge!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('REPORT ISSUE / FEEDBACK'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Submit a Service Ticket', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              const Text(
                'Our master horologists and concierge team will investigate your request within 2 hours.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Category Dropdown
              const Text('Issue Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _category,
                dropdownColor: AppTheme.cardBg,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: _issueCategories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),
              const SizedBox(height: 20),

              // Order ID Field
              const Text('Order Reference ID (Optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _orderIdController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'e.g. WH-9082-2026',
                ),
              ),
              const SizedBox(height: 20),

              // Details Field
              const Text('Detailed Explanation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _detailsController,
                maxLines: 5,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Describe your issue, feedback, or inquiry in detail...',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please describe your inquiry';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitIssue,
                  child: const Text('REGISTER SERVICE TICKET'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
