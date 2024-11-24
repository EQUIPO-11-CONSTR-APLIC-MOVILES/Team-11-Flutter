import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restau/navigation/user_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ProfileScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserViewModel _userViewModel = UserViewModel();
  final TextEditingController _nameController = TextEditingController();
  static const double _profileImageSize = 150.0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userName = await _userViewModel.getUserName();
    setState(() {
      _nameController.text = userName ?? '';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildProfileImage(),
                    const SizedBox(height: 16),
                    _buildUserName(),
                    const SizedBox(height: 32),
                    _buildProfileSection(),
                    const SizedBox(height: 16),
                    _buildNameField(),
                    const SizedBox(height: 8),
                    _buildUpdateButton(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildLogoutButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: FutureBuilder<String?>(
        future: _userViewModel.getUserPic(),
        builder: (context, snapshot) {
          return Container(
            width: _profileImageSize,
            height: _profileImageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: snapshot.data != null
                  ? CachedNetworkImage(
                      imageUrl: snapshot.data!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.grey,
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserName() {
    return Center(
      child: FutureBuilder<String?>(
        future: _userViewModel.getUserName(),
        builder: (context, snapshot) {
          return Text(
            snapshot.data ?? 'Loading...',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 1,
          color: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      maxLength: 32,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
      ),
      decoration: const InputDecoration(
        hintText: 'Name',
        hintStyle: TextStyle(fontFamily: "Poppins"),
        prefixIcon: Icon(Icons.account_circle_outlined, color: Colors.black),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        counterText: "",
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          await _userViewModel.updateUserName(_nameController.text);
          await Future.delayed(const Duration(seconds: 1));
          await _loadUserData();
        },
        child: const Text(
          'Update profile',
          style: TextStyle(
            color: Color(0xFFD9534F),
            fontSize: 15,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }


  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () async {
          _userViewModel.logOut();
          await Future.delayed(const Duration(seconds: 1));
          widget.onBack();
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xFFD9534F)),
        ),
        child: const Text(
          'Log out',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}