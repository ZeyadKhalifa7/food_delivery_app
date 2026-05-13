import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final data = await auth.getUserProfile();
    if (data == null) {
      // If no Firestore document yet, create one with current user's displayName or email
      final currentUser = FirebaseAuth.instance.currentUser;
      final defaultName = currentUser?.displayName ?? currentUser?.email?.split('@').first ?? 'User';
      await auth.updateDisplayName(defaultName);
      final newData = await auth.getUserProfile();
      setState(() {
        _profileData = newData;
        _isLoading = false;
      });
    } else {
      setState(() {
        _profileData = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _updateDisplayName() async {
    final controller = TextEditingController(text: _profileData?['displayName'] ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Display Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter your name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() => _isUpdating = true);
      final auth = Provider.of<AuthService>(context, listen: false);
      final success = await auth.updateDisplayName(result);
      if (success && mounted) {
        setState(() {
          _profileData?['displayName'] = result;
          _isUpdating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Display name updated')),
        );
        await _loadProfile();
      } else {
        setState(() => _isUpdating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update failed')),
        );
      }
    }
  }

  Future<void> _signOut() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xFFFF6B35),
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _profileData?['displayName'] ?? 'No name',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: _isUpdating ? null : _updateDisplayName,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(_profileData?['email'] ?? '', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _signOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}