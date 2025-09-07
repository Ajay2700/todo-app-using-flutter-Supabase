# Todo Reminder App

A professional, feature-rich Todo Reminder application built with Flutter, Supabase, and Firebase. This app provides a complete solution for managing personal todos with smart notifications and cloud synchronization.


https://github.com/user-attachments/assets/d7ebbf93-ec8a-4782-b902-4efbd8c6afa9     ------------------ https://github.com/user-attachments/assets/cf31fa05-f72a-4aab-afad-e17a4485fa7a

## ✨ Features

### 🔐 Authentication
- **Google Sign-In Integration**: Secure authentication using Supabase Auth
- **User Profile Management**: Display user's name and profile picture from Google
- **Automatic Profile Creation**: Seamless user onboarding

### 📝 Todo Management
- **CRUD Operations**: Create, read, update, and delete todos
- **Rich Todo Details**: Title, description, and deadline support
- **Smart Categorization**: Automatic sorting into All, Overdue, and Due Soon
- **Real-time Updates**: Live synchronization across devices
- **User-specific Data**: Each user sees only their own todos

### 🔔 Smart Notifications
- **Firebase FCM Integration**: Push notifications via Firebase Cloud Messaging
- **1-Hour Reminder**: Automatic notifications 1 hour before each deadline
- **Local Notifications**: Fallback local notifications for reliability
- **Notification Scheduling**: Server-side notification scheduling via Supabase Edge Functions

### 🎨 Professional UI/UX
- **Modern Material Design**: Beautiful, responsive interface
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Smooth Animations**: Delightful micro-interactions and transitions
- **Professional Color Scheme**: Carefully crafted color palette
- **Responsive Design**: Optimized for all screen sizes

### 📊 Dashboard & Analytics
- **Statistics Overview**: Total, Overdue, and Due Soon todo counts
- **Visual Indicators**: Color-coded priority indicators
- **Progress Tracking**: Easy-to-understand status visualization

## 🛠️ Technical Stack

### Frontend
- **Flutter**: Cross-platform mobile development
- **Provider**: State management
- **Material Design 3**: Modern UI components

### Backend & Services
- **Supabase**: Backend-as-a-Service for database and authentication
- **Firebase**: Push notifications and cloud messaging
- **PostgreSQL**: Database (via Supabase)

### Key Dependencies
```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.1
  supabase_flutter: ^2.5.0
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.9
  flutter_local_notifications: ^16.3.2
  google_sign_in: ^6.2.1
  intl: ^0.19.0
  timezone: ^0.9.2
  uuid: ^4.2.1
```

## 🗄️ Database Schema

### Profiles Table
```sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Todos Table
```sql
CREATE TABLE todos (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  deadline TIMESTAMP WITH TIME ZONE NOT NULL,
  is_completed BOOLEAN DEFAULT FALSE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  notification_id TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### User Tokens Table
```sql
CREATE TABLE user_tokens (
  user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  fcm_token TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Android Studio / VS Code
- Google Cloud Console account
- Supabase account
- Firebase project

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd TodoApp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   - Create a new Supabase project
   - Update the Supabase URL and anon key in `lib/main.dart`
   - Run the database migrations (see Database Schema section)

4. **Configure Firebase**
   - Create a Firebase project
   - Add Android/iOS apps to your Firebase project
   - Download and place configuration files:
     - `android/app/google-services.json`
     - `ios/Runner/GoogleService-Info.plist`

5. **Configure Google Sign-In**
   - Enable Google Sign-In in Firebase Authentication
   - Add your app's SHA-1 fingerprint to Firebase
   - Update OAuth redirect URLs in Supabase

6. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── todo_model.dart      # Todo data model
├── screens/
│   ├── auth_screen.dart     # Google Sign-In screen
│   └── home_screen.dart     # Main dashboard
├── services/
│   ├── auth_service.dart    # Authentication logic
│   ├── todo_service.dart    # Todo CRUD operations
│   └── notification_service.dart # FCM notifications
├── themes/
│   └── app_theme.dart       # App theming
├── utils/
│   └── init.dart           # App initialization
└── widgets/
    ├── add_todo_dialog.dart # Add todo modal
    └── todo_list.dart       # Todo list components
```

## 🔧 Configuration

### Supabase Setup
1. Create a new Supabase project
2. Enable Row Level Security (RLS)
3. Create the database tables with proper RLS policies
4. Configure OAuth providers for Google Sign-In

### Firebase Setup
1. Create a Firebase project
2. Enable Cloud Messaging
3. Configure Android/iOS apps
4. Set up Cloud Functions for notification scheduling (optional)

## 🎯 Key Features Implementation

### Authentication Flow
- Automatic user profile creation on first sign-in
- Secure token management
- Real-time authentication state updates

### Todo Management
- User-specific data isolation
- Real-time synchronization
- Optimistic UI updates
- Comprehensive error handling

### Notification System
- Dual notification approach (FCM + Local)
- Smart scheduling (1 hour before deadline)
- Background notification handling
- Notification cancellation on todo completion

### UI/UX Excellence
- Consistent design system
- Smooth animations and transitions
- Accessibility considerations
- Professional color scheme and typography

## 🔒 Security Features

- **Row Level Security**: Database-level user data isolation
- **Secure Authentication**: OAuth 2.0 with Google
- **Token Management**: Secure FCM token storage
- **Input Validation**: Comprehensive form validation
- **Error Handling**: Secure error messages without data exposure

## 📈 Performance Optimizations

- **Efficient State Management**: Provider pattern for optimal rebuilds
- **Lazy Loading**: On-demand data fetching
- **Image Caching**: Optimized profile picture loading
- **Animation Performance**: Hardware-accelerated animations
- **Memory Management**: Proper disposal of controllers and streams

## 🧪 Testing

The app includes comprehensive error handling and validation:
- Form validation with user-friendly messages
- Network error handling with retry mechanisms
- Authentication error handling
- Database operation error handling

## 🚀 Deployment

### Android
1. Generate a signed APK
2. Configure Firebase for production
3. Update Supabase production settings
4. Test on physical devices

### iOS
1. Configure iOS signing
2. Update Firebase iOS configuration
3. Test on iOS devices
4. Submit to App Store

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request



**Built with ❤️ using Flutter, Supabase, and Firebase**
