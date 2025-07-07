import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    FileInputStream(localPropertiesFile).use { localProperties.load(it) }
}

val flutterRoot = localProperties.getProperty("flutter.sdk")
require(flutterRoot != null) {
    "Flutter SDK not found. Define location with flutter.sdk in the local.properties file."
}

var flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
var flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"


android {
    namespace = "com.umat.fitnessapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
        freeCompilerArgs = listOf("-Xjvm-default=all")
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        // TODO: Change this to your unique application ID.
        // You can also set this in the local.properties file with flutter.applicationId.
        applicationId = "com.umat.fitnessapp"
        minSdkVersion (23)
        targetSdkVersion (33)
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        ndk{
            abiFilters += ("arm64-v8a")
            abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86_64")
        }
    }

    packagingOptions {
        jniLibs {
            useLegacyPackaging = true
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            signingConfig = signingConfigs.getByName("debug")
        }
        debug{
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source=("../..")
}

dependencies {
    implementation("com.google.firebase:firebase-bom:33.13.0") // Firebase BOM
     // Example Firebase dependency
    implementation("androidx.core:core-ktx:1.10.1")
    implementation("com.google.firebase:firebase-analytics")
    implementation ("com.google.firebase:firebase-auth")
    implementation ("com.google.android.gms:play-services-auth") // For Google sign-in
    implementation ("com.facebook.android:facebook-android-sdk:latest.release") // For Facebook sign-in
    }
