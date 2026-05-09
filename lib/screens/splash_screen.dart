import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(AppConstants.splashDuration);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFAF0), Color(0xFFFEF3C7)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Splash Logo
              Image.asset(
                'assets/splash.png',
                width: MediaQuery.of(context).size.width * 0.82,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 6),
              
              // Powered by section
              Column(
                children: [
                  Text(
                    'Powered by',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConstants.developerName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF064E3B),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 60,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Color(0xFF16A34A), Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Contact info
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, size: 18, color: Color(0xFF16A34A)),
                      const SizedBox(width: 10),
                      Text(
                        AppConstants.developerPhone,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF064E3B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, size: 18, color: Color(0xFF16A34A)),
                      const SizedBox(width: 10),
                      Text(
                        AppConstants.developerEmail,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF064E3B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              
              // Loading spinner
              Column(
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)),
                      backgroundColor: Color(0xFF16A34A).withOpacity(0.2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF064E3B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
