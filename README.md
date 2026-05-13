# 🍕 Food Delivery App

A modern **Flutter Food Delivery Application** powered by **Firebase**, featuring authentication, a real-time food menu, shopping cart, order management, and user profiles.

---

## ✨ Features

### 🔐 Authentication
- Sign up & sign in using **Email/Password**
- Secure **Firebase Authentication**
- Persistent login session

### 👤 User Profile
- Set and update display name
- View profile information
- Secure sign out

### 🍔 Food Menu
- Browse food items from **Cloud Firestore**
- View:
    - Food name
    - Price
    - Description
- Real-time updates

### 🛒 Shopping Cart
- Add/remove food items
- Update item quantities
- Calculate total price dynamically

### 📦 Order Management
- Place orders instantly
- Save order history in **Firestore**
- Linked to authenticated user ID

### 🎨 UI/UX
- Responsive layout
- Smooth animations
- Custom modern theme
- Clean and intuitive interface

---

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter 3.x | Frontend Framework |
| Dart | Programming Language |
| Firebase Core | Firebase Initialization |
| Firebase Authentication | User Authentication |
| Cloud Firestore | Database |
| Provider | State Management |
| Google Fonts | Typography |
| Flutter Animate | UI Animations |

---

## 📂 Project Structure

```bash
lib/
│── main.dart                     # App entry point
│
├── models/
│   └── menu_item.dart            # Food item model
│
├── screens/
│   ├── auth_screen.dart          # Login & Sign Up
│   ├── home_screen.dart          # Food menu
│   ├── cart_screen.dart          # Shopping cart
│   ├── profile_screen.dart       # User profile
│   └── item_detail_screen.dart   # Food details
│
├── services/
│   ├── auth_service.dart         # Firebase Auth logic
│   ├── cart_service.dart         # Cart state management
│   └── firestore_service.dart    # Firestore operations
│
└── widgets/
    ├── food_card_grid.dart       # Food card widget
    ├── cart_item_tile.dart       # Cart item component
    └── custom_button.dart        # Reusable button
```

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

- **Flutter SDK** `>=3.0.0`
- **Android Studio** or **VS Code**
- A **Firebase Project**

---

## ⚙️ Installation

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/food_delivery_app.git
cd food_delivery_app
```

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

### 3️⃣ Firebase Setup

#### Create a Firebase Project

Go to Firebase Console:

https://console.firebase.google.com

#### Enable Authentication

1. Open **Authentication**
2. Navigate to **Sign-in Method**
3. Enable **Email/Password**

#### Setup Firestore

1. Open **Firestore Database**
2. Click **Create Database**
3. Start in **Test Mode**

#### Configure Android

Download:

```text
google-services.json
```

Place it inside:

```text
android/app/
```

---

## 🔥 Firestore Security Rules

Go to:

**Firestore Database → Rules**

Replace the default rules with:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    match /menu/{document} {
      allow read: if request.auth != null;
      allow write: if false;
    }

    match /orders/{document} {
      allow read, write: if request.auth != null &&
      (
        resource.data.userId == request.auth.uid ||
        request.resource.data.userId == request.auth.uid
      );
    }

    match /users/{userId} {
      allow read, write: if request.auth != null
      && request.auth.uid == userId;
    }
  }
}
```

---

## 🍕 Add Sample Menu Items

Create a **menu** collection in **Firestore**.

Add documents with the following fields:

| Field | Type |
|--------|------|
| `name` | String |
| `price` | Number |
| `description` | String (Optional) |
| `imageUrl` | String (Optional) |


Example:

```json
{
  "name": "Cheese Burger",
  "price": 9.99,
  "description": "Juicy beef burger with cheese",
  "imageUrl": "https://your-image-url.com/burger.png"
}
```

---

## ▶️ Run the App

```bash
flutter run
```

---

## 👥 Team Members

| Name                      | Student ID |
|---------------------------|------------|
| **Zeyad Mahmoud Khalifa** | `240100079` |
| **Abram Mina Nashaat**    | `2401000822` |
| **Malak Ahmed Mostafa**   | `240100343` |

---

## 📄 License

This project is developed for **educational purposes**.

---

## 🙌 Acknowledgements

Special thanks to:

- Flutter Team
- Firebase Team
- Material Design Icons
- Google Fonts

---

## ⭐ Support

If you like this project, consider giving it a **star ⭐ on GitHub**.

**Happy Coding 🍔🍟**