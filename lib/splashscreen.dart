import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pisang_meledak/login.dart';
import 'package:pisang_meledak/customer/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3), // Durasi tampilan splash screen
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              const WelcomePage(), // Navigate to MainScreen
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('./lib/assets/logo.png', scale: 2.0),
      ),
    );
  }
}


class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with a modern gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                   Color(0xFFFFE180),
                   Color(0xFF67C4A7), // Soft teal
                   Color(0xFFFFFFFF),// White
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: CustomPaint(
              painter: CirclePainter(),
              child: Container(), // Empty container to enable the painter
            ),
          ),
          // Content of the page
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: <Widget>[
                const Spacer(flex: 1),
                // Welcome title
                const Text(
                  'Pisang Meledak',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color:  Color(0xFF2A7C5B), // Darker teal for title
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                // Welcome tagline
                const Text(
                  'Ledakkan Mood mu, dengan Pisang Meledak!!',
                  style: TextStyle(fontSize: 18, color: Colors.black87), // Dark black for tagline
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 1), // Spacer to lift the login button higher
                // Log in button, full width
                SizedBox(
                  width: double.infinity, // Make the button full width
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color(0xFF2A7C5B), // Dark teal for button
                    ),
                    onPressed: () {
                      // Navigate to the Login Page when button is pressed
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30), // Adjust spacing below the login button
                // Skip button positioned right below the login button
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the Home Page when button is pressed
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min, // Ensure the Row only takes up as much space as needed
                      children: [
                        Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87, // Dark black for skip text
                          ),
                        ),
                        SizedBox(width: 5), // Space between text and icon
                        Icon(
                          Icons.arrow_right_alt, // Icon for the arrow
                          color: Colors.black87, // Dark black for icon
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 200), // Reduced the bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// CustomPainter to draw circular shapes in the background
class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(0.1) // Soft white circles
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = const Color(0xFF67C4A7).withOpacity(0.1) // Soft teal circles
      ..style = PaintingStyle.fill;

        final paint3 = Paint()
      ..color = const Color(0xFFFFE180).withOpacity(0.1) // Soft teal circles
      ..style = PaintingStyle.fill;

    // Draw circles
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.2), 150, paint1);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), 200, paint2);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.5), 100, paint3);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.7), 250, paint2);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
