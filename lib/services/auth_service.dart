import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProfile {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class AuthService extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  User? get currentUser {
    // Return mock user if not signed in, for development
    if (supabase.auth.currentUser == null) {
      return _createMockUserForAuth();
    }
    return supabase.auth.currentUser;
  }

  bool get isSignedIn => currentUser != null;

  User _createMockUserForAuth() {
    // Create a mock User object
    return User(
      id: '00000000-0000-0000-0000-000000000001',
      appMetadata: {},
      userMetadata: {
        'full_name': 'Test User',
        'name': 'Test User',
        'email': 'test@example.com',
        'avatar_url': 'https://via.placeholder.com/150',
      },
      aud: 'authenticated',
      createdAt: DateTime.now().toIso8601String(),
      email: 'test@example.com',
      phone: null,
      role: 'authenticated',
      updatedAt: DateTime.now().toIso8601String(),
    );
  }

  UserProfile? _userProfile;
  UserProfile? get userProfile =>
      _getDummyProfile(); // Always return a dummy profile

  UserProfile _getDummyProfile() {
    return UserProfile(
      id: 'dummy-user-id',
      email: 'test@example.com',
      fullName: 'Test User',
      avatarUrl: null, // Avoid network image issues
      createdAt: DateTime.now(),
    );
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthService() {
    _initializeAuth();
  }
  void _initializeAuth() {
    supabase.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        await _loadUserProfile();
      } else if (event == AuthChangeEvent.signedOut) {
        _userProfile = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserProfile() async {
    if (currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', currentUser!.id)
          .single();

      _userProfile = UserProfile.fromJson(response);
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      // Create profile if it doesn't exist
      await _createUserProfile();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _createUserProfile() async {
    if (currentUser == null) return;

    try {
      final profileData = {
        'id': currentUser!.id,
        'email': currentUser!.email!,
        'full_name': currentUser!.userMetadata?['full_name'] ??
            currentUser!.userMetadata?['name'],
        'avatar_url': currentUser!.userMetadata?['avatar_url'] ??
            currentUser!.userMetadata?['picture'],
        'created_at': DateTime.now().toIso8601String(),
      };

      await supabase.from('profiles').insert(profileData);
      _userProfile = UserProfile.fromJson(profileData);
    } catch (e) {
      debugPrint('Error creating user profile: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        // No need to specify redirectTo unless you have a custom domain
      );
    } catch (e) {
      debugPrint('Google Sign In Error: $e');
      throw AuthException('Failed to sign in with Google: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _createMockUser() async {
    // Simulate successful authentication
    await Future.delayed(const Duration(seconds: 1));

    // Generate a proper UUID for the mock user
    final mockUserId = '00000000-0000-0000-0000-000000000001';

    // Create a mock user profile directly (without saving to database for now)
    _userProfile = UserProfile(
      id: mockUserId,
      email: 'test@example.com',
      fullName: 'Test User',
      avatarUrl: 'https://via.placeholder.com/150',
      createdAt: DateTime.now(),
    );

    debugPrint('Mock user created successfully: ${_userProfile!.fullName}');

    // Skip database operations for now to avoid UUID issues
    // TODO: Implement proper database operations once tables are created
  }

  Future<void> _signInWithGoogleDirect() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      // Add your Google OAuth client ID here
      // You can find this in Google Cloud Console > APIs & Services > Credentials
      // serverClientId: 'YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com',
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw 'Google sign-in was cancelled';
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final String? accessToken = googleAuth.accessToken;
    final String? idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      throw 'Failed to get Google authentication tokens';
    }

    // Sign in to Supabase with the Google tokens
    final AuthResponse response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    if (response.user == null) {
      throw 'Failed to sign in to Supabase';
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await supabase.auth.signOut();
      _userProfile = null;
    } catch (e) {
      debugPrint('Sign Out Error: $e');
      throw AuthException('Failed to sign out: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    if (currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final updateData = <String, dynamic>{};
      if (fullName != null) updateData['full_name'] = fullName;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;

      if (updateData.isNotEmpty) {
        updateData['updated_at'] = DateTime.now().toIso8601String();

        await supabase
            .from('profiles')
            .update(updateData)
            .eq('id', currentUser!.id);

        await _loadUserProfile();
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      throw AuthException('Failed to update profile: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;
}
