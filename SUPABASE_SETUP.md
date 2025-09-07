# Supabase Google Authentication Setup Guide

## Steps to Fix Google Sign-In Issue

### 1. Configure Supabase Project Settings

1. **Go to your Supabase Dashboard**: https://supabase.com/dashboard
2. **Select your project**: `dbbizyarzydhgtfgvanj`
3. **Navigate to Authentication > Settings**
4. **Go to "URL Configuration" section**

### 2. Update Site URL and Redirect URLs

**Current Issue**: The redirect URL is set to `localhost:3000` which doesn't work on mobile devices.

**Fix**:
1. **Site URL**: Set to `https://your-app-domain.com` (or keep as is for now)
2. **Redirect URLs**: Add these URLs (one per line):
   ```
   http://localhost:3000
   com.example.todo_app://login-callback/
   https://dbbizyarzydhgtfgvanj.supabase.co/auth/v1/callback
   ```

### 3. Configure Google OAuth Provider

1. **In Supabase Dashboard**: Go to Authentication > Providers
2. **Enable Google Provider**
3. **Set the following**:
   - **Client ID**: Your Google OAuth Client ID
   - **Client Secret**: Your Google OAuth Client Secret
   - **Redirect URL**: `https://dbbizyarzydhgtfgvanj.supabase.co/auth/v1/callback`

### 4. Google Cloud Console Setup

1. **Go to Google Cloud Console**: https://console.cloud.google.com/
2. **Select your project** (or create one)
3. **Enable Google+ API**
4. **Go to Credentials > Create Credentials > OAuth 2.0 Client ID**
5. **Application Type**: Web application
6. **Authorized redirect URIs**: Add:
   ```
   https://dbbizyarzydhgtfgvanj.supabase.co/auth/v1/callback
   ```

### 5. Alternative: Use Supabase's Default Redirect

If you want to use the default Supabase redirect (simpler approach):

1. **In Supabase Dashboard**: Go to Authentication > Settings
2. **Redirect URLs**: Add only:
   ```
   https://dbbizyarzydhgtfgvanj.supabase.co/auth/v1/callback
   ```
3. **Remove** `localhost:3000` from redirect URLs

### 6. Test the Configuration

After making these changes:

1. **Restart your Flutter app**
2. **Try Google Sign-In again**
3. **The app should now redirect properly**

### 7. Troubleshooting

If you still get errors:

1. **Check Supabase logs**: Go to Logs > Auth in your Supabase dashboard
2. **Verify redirect URLs**: Make sure they match exactly
3. **Check Google OAuth settings**: Ensure the redirect URI matches
4. **Clear app data**: Uninstall and reinstall the app to clear any cached auth state

### 8. For Production

When deploying to production:

1. **Update Site URL** to your production domain
2. **Add production redirect URLs**:
   ```
   https://yourdomain.com/auth/callback
   https://yourdomain.com
   ```
3. **Update Google OAuth** with production redirect URIs

## Current App Configuration

The app is now configured to:
- Use Supabase's default redirect URL for mobile
- Handle authentication state changes automatically
- Create user profiles in the `profiles` table
- Store FCM tokens for push notifications

## Next Steps

1. Update your Supabase project settings as described above
2. Test the Google Sign-In functionality
3. If issues persist, check the Supabase logs for specific error messages

---

User? get currentUser => null; // Always return null for now
bool get isSignedIn => true; // Always return true to bypass auth

// Temporary UUID for testing (remove in production)
final userId = '123e4567-e89b-12d3-a456-426614174000';
