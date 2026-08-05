import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/watch_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import 'luxury_order_confirmation_screen.dart';

class CheckoutModal extends StatefulWidget {
  const CheckoutModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.darkCharcoal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const CheckoutModal(),
    );
  }

  @override
  State<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<CheckoutModal> {
  int _currentStep = 0;
  String _selectedPaymentMethod = 'Apple Pay';
  late String _selectedAddress;
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    _selectedAddress = user?.defaultAddress ?? '742 Evergreen Terrace, Suite 4B, New York, NY 10021';
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EXPRESS CHECKOUT',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppTheme.goldAccent),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(color: AppTheme.cardBorder),

          // Stepper Indicator Header
          Row(
            children: [
              _buildStepIndicator(0, '1. Address'),
              const Expanded(child: Divider(color: AppTheme.cardBorder)),
              _buildStepIndicator(1, '2. Payment'),
              const Expanded(child: Divider(color: AppTheme.cardBorder)),
              _buildStepIndicator(2, '3. Confirm'),
            ],
          ),
          const SizedBox(height: 20),

          // Step Body
          Expanded(
            child: SingleChildScrollView(
              child: _buildStepContent(cartProvider, currencyFormat),
            ),
          ),

          // Action Buttons Bottom
          const SizedBox(height: 12),
          Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _currentStep--),
                    child: const Text('BACK'),
                  ),
                ),
              if (_currentStep > 0) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isPlacingOrder
                      ? null
                      : () {
                          if (_currentStep < 2) {
                            setState(() => _currentStep++);
                          } else {
                            _processOrder(context, cartProvider);
                          }
                        },
                  child: _isPlacingOrder
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppTheme.obsidianBlack),
                          ),
                        )
                      : Text(_currentStep == 2 ? 'PLACE ORDER NOW' : 'CONTINUE'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title) {
    final isActive = _currentStep == stepIndex;
    final isDone = _currentStep > stepIndex;

    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isDone || isActive ? AppTheme.goldAccent : AppTheme.cardBg,
          child: Text(
            '${stepIndex + 1}',
            style: TextStyle(
              color: isDone || isActive ? AppTheme.obsidianBlack : AppTheme.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            color: isActive ? AppTheme.textPrimary : AppTheme.textMuted,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent(CartProvider cartProvider, NumberFormat currencyFormat) {
    if (_currentStep == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Insured Shipping Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Card(
            child: RadioListTile<String>(
              value: '742 Evergreen Terrace, Suite 4B, New York, NY 10021',
              groupValue: _selectedAddress,
              activeColor: AppTheme.goldAccent,
              title: const Text('Primary Residence (NY)', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
              subtitle: const Text('742 Evergreen Terrace, Suite 4B, New York, NY 10021', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              onChanged: (val) => setState(() => _selectedAddress = val!),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: RadioListTile<String>(
              value: '88 Ocean Drive, Penthouse 12, Miami, FL 33139',
              groupValue: _selectedAddress,
              activeColor: AppTheme.goldAccent,
              title: const Text('Vacation Penthouse (FL)', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
              subtitle: const Text('88 Ocean Drive, Penthouse 12, Miami, FL 33139', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              onChanged: (val) => setState(() => _selectedAddress = val!),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.goldAccent.withOpacity(0.4)),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: AppTheme.goldAccent, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'All shipments are insured up to \$250,000 via Armored Express Courier with adult signature verification.',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (_currentStep == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _buildPaymentCard('Apple Pay', 'Apple Pay One-Touch', Icons.apple),
          _buildPaymentCard('Credit Card', 'Amex Centurion / Black Card (•••• 8812)', Icons.credit_card),
          _buildPaymentCard('Wire Transfer', 'Direct Bank Wire (2% Off High Value Orders)', Icons.account_balance),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartProvider.items.length,
            itemBuilder: (context, index) {
              final item = cartProvider.items[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: AppImage(url: item.watch.imageUrls.first, width: 40, height: 40, fit: BoxFit.cover),
                ),
                title: Text(item.watch.title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text('Qty: ${item.quantity} | ${item.selectedColor}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                trailing: Text(currencyFormat.format(item.totalPrice), style: const TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold)),
              );
            },
          ),
          const Divider(color: AppTheme.cardBorder),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Grand Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                currencyFormat.format(cartProvider.grandTotal),
                style: const TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Deliver to: $_selectedAddress', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          Text('Payment: $_selectedPaymentMethod', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ],
      );
    }
  }

  Widget _buildPaymentCard(String method, String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: RadioListTile<String>(
        value: method,
        groupValue: _selectedPaymentMethod,
        activeColor: AppTheme.goldAccent,
        secondary: Icon(icon, color: AppTheme.goldAccent),
        title: Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
        onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
      ),
    );
  }

  Future<void> _processOrder(
      BuildContext context, CartProvider cartProvider) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final watchProvider = Provider.of<WatchProvider>(context, listen: false);

    final userId = authProvider.user?.id;
    if (userId == null) return;

    setState(() => _isPlacingOrder = true);

    final newOrder = await orderProvider.checkout(
      userId: userId,
      shippingAddress: _selectedAddress,
      paymentMethod: _selectedPaymentMethod,
      discountAmount: cartProvider.discountAmount,
      allWatches: watchProvider.allWatches,
    );

    if (!context.mounted) return;
    setState(() => _isPlacingOrder = false);

    if (newOrder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              orderProvider.errorMessage ?? 'Could not place order. Please try again.'),
        ),
      );
      return;
    }

    // Backend already deleted the cart items server-side during checkout;
    // this just syncs local cart state and clears the promo code.
    cartProvider.clearCart();
    Navigator.pop(context); // Close checkout sheet

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LuxuryOrderConfirmationScreen(order: newOrder),
      ),
    );
  }
}