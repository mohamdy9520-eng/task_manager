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


2. ScreenShots":
<img width="317" height="656" alt="لقطة الشاشة 2026-04-30 132820" src="https://github.com/user-attachments/assets/c99b5d1a-beb3-4579-8945-79852ad327a9" />
<img width="341" height="712" alt="لقطة الشاشة 2026-04-28 222930" src="https://github.com/user-attachments/assets/c66916d4-79e3-4f6a-ae0c-210f44e59a67" />
<img width="352" height="727" alt="لقطة الشاشة 2026-04-28 133339" src="https://github.com/user-attachments/assets/d38ac11e-bd8a-41f1-8a1a-00f005406845" />
<img width="397" height="803" alt="لقطة الشاشة 2026-04-27 105242" src="https://github.com/user-attachments/assets/f349cd88-c0bd-4309-9b9b-ff1d8e7f1ea6" />
<img width="420" height="797" alt="لقطة الشاشة 2026-04-27 105221" src="https://github.com/user-attachments/assets/2932b27d-9dab-4507-af6c-23657aaed1c1" />
<img width="391" height="802" alt="لقطة الشاشة 2026-04-27 105152" src="https://github.com/user-attachments/assets/0fea467f-7d36-420b-a76c-cb3efe70e620" />
<img width="423" height="787" alt="لقطة الشاشة 2026-04-27 092949" src="https://github.com/user-attachments/assets/432d7b14-f58d-4b3a-a5d0-b8e92ac84f73" />
<img width="398" height="778" alt="1" src="https://github.com/user-attachments/assets/359de08f-27dd-4b77-a264-7ad63cd83ef8" />
