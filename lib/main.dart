import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/watch_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/review_provider.dart';
import 'providers/order_provider.dart';
import 'providers/support_provider.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/catalog/catalog_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/profile/profile_screen.dart';

// Widgets
import 'widgets/custom_nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WatchHubApp());
}

class WatchHubApp extends StatelessWidget {
  const WatchHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WatchProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => SupportProvider()),
      ],
      child: MaterialApp(
        title: 'WatchHub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const RootNavigationScreen(),
      ),
    );
  }
}

class RootNavigationScreen extends StatefulWidget {
  const RootNavigationScreen({super.key});

  @override
  State<RootNavigationScreen> createState() => _RootNavigationScreenState();
}

class _RootNavigationScreenState extends State<RootNavigationScreen> {
  int _currentTab = 0;

  void _navigateToCatalog() {
    setState(() => _currentTab = 1);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // If user is logged out, show Login screen
    if (!authProvider.isLoggedIn) {
      return const LoginScreen();
    }

    final List<Widget> screens = [
      HomeScreen(onNavigateToCatalog: _navigateToCatalog),
      const CatalogScreen(),
      WishlistScreen(onNavigateToCatalog: _navigateToCatalog),
      CartScreen(onNavigateToCatalog: _navigateToCatalog),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentTab,
        children: screens,
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentTab,
        onTap: (index) => setState(() => _currentTab = index),
      ),
    );
  }
}
