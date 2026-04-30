# 📱 Task Manager App (Flutter + Firebase)

A scalable task management application built with Flutter and Firebase.

This project is part of my learning journey toward building production-ready applications, focusing on real-time data handling, authentication, and scalable architecture practices.

---

## ✨ Features

- 🔐 Firebase Authentication (Login / Signup)
- ☁️ Cloud Firestore real-time database
- 📋 Create, update, and delete tasks
- 📊 Task status tracking (In Progress / Done / Ongoing / Waiting Review)
- 👤 User profile with name & photo update
- 📷 Image upload using Firebase Storage
- 🔄 Real-time UI updates using Streams
- 📅 Calendar integration
- 💬 Chat screen (UI ready)

---

## 🧠 Tech Stack

- Flutter (Dart)
- Firebase Auth
- Cloud Firestore
- Firebase Storage
- Image Picker
- StreamBuilder (Reactive UI)

---

## 📁 Project Structure (Simplified)

lib/
├── core/
│ └── services/
│ └── firestore_service.dart
│
├── features/
│ ├── home/
│ ├── profile/
│ ├── calendar/
│ ├── chat/
│ └── onboarding/
│
├── widgets/
│ └── bottomNav/


---

## ⚠️ Known Issues (Current Version)

- Firestore security rules need production hardening
- Some screens rely heavily on StreamBuilder (performance improvement needed)
- No offline caching implemented yet
- Business logic still coupled with UI
- Limited error handling consistency

---

## 🚀 Future Improvements

- Implement Clean Architecture (Repository + Use Cases)
- Refactor state management using Bloc/Cubit
- Optimize Firestore queries (reduce reads)
- Add offline caching (Hive / SharedPreferences)
- Improve security rules per-user access
- Centralized error handling system
- Performance optimization for StreamBuilder usage

---

## 🔥 Setup Instructions

1. Clone repository:
```bash
git clone https://github.com/your-repo/task-manager-app.git


## ScreenShots:
<img width="398" height="778" alt="1" src="https://github.com/user-attachments/assets/4efe0eee-7096-4e46-85a6-5204e0ae7ca7" />

