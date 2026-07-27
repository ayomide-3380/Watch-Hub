import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class SavedPaymentsScreen extends StatefulWidget {
  const SavedPaymentsScreen({super.key});

  @override
  State<SavedPaymentsScreen> createState() => _SavedPaymentsScreenState();
}

class _SavedPaymentsScreenState extends State<SavedPaymentsScreen> {
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  String _selectedType = 'Visa';

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    super.dispose();
  }

  void _showAddCardModal(BuildContext context, AuthProvider auth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.darkCharcoal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Payment Method', style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              dropdownColor: AppTheme.darkCharcoal,
              decoration: const InputDecoration(labelText: 'Card Type'),
              items: ['Visa', 'Mastercard', 'Amex'].map((t) {
                return DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(color: Colors.white)));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedType = val);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cardNumberCtrl,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                hintText: 'xxxx xxxx xxxx xxxx',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _expiryCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Expiry Date',
                hintText: 'MM/YY',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final rawNum = _cardNumberCtrl.text.trim();
                  if (rawNum.length >= 4) {
                    final maskedNum = '•••• ${rawNum.substring(rawNum.length - 4)}';
                    auth.addCard({
                      'number': maskedNum,
                      'type': _selectedType,
                      'expiry': _expiryCtrl.text.trim(),
                    });
                    _cardNumberCtrl.clear();
                    _expiryCtrl.clear();
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Card added successfully!')),
                    );
                  }
                },
                child: const Text('ADD CARD'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final cards = auth.user?.savedCards ?? [];

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('WALLET & PAYMENTS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.goldAccent),
            onPressed: () => _showAddCardModal(context, auth),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: cards.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.credit_card_off, color: AppTheme.textMuted, size: 64),
                  const SizedBox(height: 16),
                  const Text('No Saved Cards', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  const Text('Add a mock billing method for fast checkout.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF14161B), Color(0xFF2C3039)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.goldAccent.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              card['type']?.toUpperCase() ?? 'CARD',
                              style: const TextStyle(
                                color: AppTheme.goldAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1.0,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppTheme.errorRed, size: 20),
                              onPressed: () {
                                auth.removeCard(card['number'] ?? '');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Card removed.')),
                                );
                              },
                            ),
                          ],
                        ),
                        Text(
                          card['number'] ?? '•••• •••• •••• ••••',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 2.0,
                            fontFamily: 'monospace',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CARDHOLDER', style: TextStyle(color: AppTheme.textMuted, fontSize: 8)),
                                SizedBox(height: 2),
                                Text('ALEXANDER VANCE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('EXPIRES', style: TextStyle(color: AppTheme.textMuted, fontSize: 8)),
                                const SizedBox(height: 2),
                                Text(card['expiry'] ?? '12/29', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
