plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    ndkVersion = "27.0.12077973"
    namespace = "com.example.curio_spark"
    compileSdk = flutter.compileSdkVersion

    compileOptions {
        // Use Java 8 language features & enable core library desugaring
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        // Also target Java 8 bytecode for Kotlin
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.example.curio_spark"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.core:core-ktx:1.13.1")

    // <— Add this line to pull in the desugaring library
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
