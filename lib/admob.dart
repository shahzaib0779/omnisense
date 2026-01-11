import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omnisense/ad_manager.dart';
import 'login_screen.dart';
import 'faq_page.dart'; // Create these files next
import 'complain_page.dart';
import 'help_support_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser;
  final _nameController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = user?.displayName ?? "";
  }

  Future<void> _updateName() async {
    setState(() => _isSaving = true);
    try {
      // Direct Auth update - No storage needed
      await user?.updateDisplayName(_nameController.text.trim());
      await user?.reload();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Profile Updated!",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0A74DA),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSimpleHeader(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildNameEditField(),
                  const SizedBox(height: 25),
                  _buildNavTile(
                    Icons.quiz_outlined,
                    "FAQs",
                    "Common technical questions",
                    const FaqPage(),
                  ),
                  _buildNavTile(
                    Icons.report_problem_outlined,
                    "Complain",
                    "Report bugs directly",
                    const ComplainPage(),
                  ),
                  _buildNavTile(
                    Icons.support_agent_outlined,
                    "Help & Support",
                    "Get technical assistance",
                    const HelpSupportPage(),
                  ),
                  _buildNavTile(
                    Icons.ads_click_outlined,
                    "AdMob Ads",
                    "Check out sample ads",
                    const AdDisplayClass(),
                  ),
                  const Divider(height: 40),
                  _buildLogoutTile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      color: const Color(0xFF0A74DA),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Color(0xFF0A74DA)),
          ),
          const SizedBox(height: 15),
          Text(
            user?.email ?? "",
            style: const TextStyle(
              color: Colors.white70,
              fontFamily: "Montserrat",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameEditField() {
    return Column(
      children: [
        TextField(
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w500,
          ),
          controller: _nameController,
          decoration: InputDecoration(
            labelText: "Display Name",
            labelStyle: const TextStyle(fontFamily: "Montserrat"),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _updateName,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A74DA),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: _isSaving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Save Name",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavTile(
    IconData icon,
    String title,
    String subtitle,
    Widget targetPage,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0A74DA)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Montserrat",
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.blueGrey,
            fontFamily: "Montserrat",
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        ),
      ),
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      },
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        "Logout",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontFamily: "Montserrat",
        ),
      ),
    );
  }
}
