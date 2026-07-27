import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final _addressCtrl = TextEditingController();

  @override
  void dispose() {
    _addressCtrl.dispose();
    super.dispose();
  }

  void _showAddAddressModal(BuildContext context, AuthProvider auth) {
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
            const Text('Add Shipping Address', style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            TextField(
              controller: _addressCtrl,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Full Address',
                hintText: 'Street Address, Suite, City, State, ZIP',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final addrText = _addressCtrl.text.trim();
                  if (addrText.isNotEmpty) {
                    auth.addAddress(addrText);
                    _addressCtrl.clear();
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Address added successfully!')),
                    );
                  }
                },
                child: const Text('SAVE ADDRESS'),
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
    final user = auth.user;
    final addresses = user?.shippingAddresses ?? [];

    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('DELIVERY ADDRESSES'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.goldAccent),
            onPressed: () => _showAddAddressModal(context, auth),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off_outlined, color: AppTheme.textMuted, size: 64),
                  const SizedBox(height: 16),
                  const Text('No Saved Addresses', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  const Text('Add delivery points for your secure couriers.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final addr = addresses[index];
                final isDefault = user?.defaultAddress == addr;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: ListTile(
                      leading: Icon(
                        isDefault ? Icons.stars : Icons.location_on_outlined,
                        color: isDefault ? AppTheme.goldAccent : AppTheme.textMuted,
                      ),
                      title: Text(
                        isDefault ? 'PRIMARY ADDRESS' : 'SHIPPING LOCATION',
                        style: TextStyle(
                          color: isDefault ? AppTheme.goldAccent : AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(addr, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.3)),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppTheme.errorRed, size: 20),
                        onPressed: () {
                          auth.removeAddress(addr);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Address removed.')),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
