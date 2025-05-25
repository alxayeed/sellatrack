plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.sellatrack"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.sellatrack"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = 3
        versionName = "0.1.0"
    }

    flavorDimensions += "env"

    productFlavors {
        create("dev") {
            dimension = "env"
//            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
//            applicationId = "com.example.sellatrackdev"
        }
        create("prod") {
            dimension = "env"
//            applicationId = "com.example.sellatrack"
        }
    }

    // Optional: custom applicationId per flavor
//    dev {
//        applicationId "com.yourcompany.sellatrackdev"
//    }
//
//    prod {
//        applicationId "com.yourcompany.sellatrack"
//    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
