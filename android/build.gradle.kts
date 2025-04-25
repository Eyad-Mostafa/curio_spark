plugins {
    id("com.android.application") version "8.3.0"  // Specify the version of the Android plugin
    id("org.jetbrains.kotlin.android") version "2.0.20"
}

android {
    namespace = "com.example.curio_spark"
    compileSdk = 34
    javaCompileOptions {
            annotationProcessorOptions {
                includeCompileClasspath true
            }
        }
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.curio_spark"
        minSdk = 21
        targetSdk = 34
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
    source = "../.."  // This points to your Flutter source directory
}

dependencies {
    implementation("androidx.core:core-ktx:1.13.1")
}
