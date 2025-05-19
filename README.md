# CurioSpark

CurioSpark is a Flutter mobile application developed as a project for the **COMP 310** course. The app provides users with a feed of interesting curiosities, automatically fetched every 12 hours using background tasks. It combines elegant UI, persistent storage, and scheduled background logic—even when the app is closed.

## 🚀 Features

- 🧠 Auto-fetches curiosities every 12 hours
- 🔔 Push notifications when a new curiosity is available
- 🌙 Dark Theme support
- 🔧 Background processing with [`android_alarm_manager_plus`](https://pub.dev/packages/android_alarm_manager_plus)
- 💾 Persistent storage using Hive
- 🌐 Gemini-powered curiosity generation
- 🔁 Share curiosities as a text
- 📱 Minimal and modern UI built with Flutter

## 🛠 Tech Stack

- Flutter (Dart)
- Hive (NoSQL local storage)
- `android_alarm_manager_plus` for background tasks
- Gemini API (text generation)
- Local notifications
- Material Design + Dark Theme

## 👥 Team Members

This project was developed by a team of 4 students:

- **[Eyad Mostafa](https://github.com/Eyad-Mostafa)**  
- **[Abdulrahman Hamdi](https://github.com/AbdulrahmanHamdy)**  
- **[Rahma Nasser](https://github.com/Rahma9999)**  
- **[Rashad Mostafa](https://github.com/rashadmo8)**

## 📚 Course Information

- **Course:** COMP 310 
- **Instructor:** Assoc. Prof. Dieaa I. Nassr  
- **University:** Ain Shams University – Faculty of Science  
- **Semester:** Spring 2025

## 📲 How to Run

1. Clone the repository:
```bash
   git clone https://github.com/Eyad-Mostafa/curiospark.git
   cd curiospark
```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

> ⚠️ Background tasks are tested only on Android. Make sure battery optimizations are disabled and proper permissions are granted for alarms and notifications.

## 📃 License

This project is for academic use only and is not licensed for commercial distribution.
