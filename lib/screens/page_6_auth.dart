import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'page_1_home.dart';
import 'page_7_vendor_dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isVendor = false;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  void _handleLogin() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    String role = _isVendor ? 'vendor' : 'student';

    auth.login(_emailController.text, _passController.text, role).then((_) {
      if (_isVendor) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => VendorDashboardScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "FC3 Login",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text("Login as Vendor?"),
                Switch(
                  value: _isVendor,
                  onChanged: (val) => setState(() => _isVendor = val),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _handleLogin, child: Text("Login")),
          ],
        ),
      ),
    );
  }
}
