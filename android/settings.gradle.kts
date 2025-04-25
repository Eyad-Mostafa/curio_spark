pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal() // Ensure Flutter plugin resolution is handled
    }
}

dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "curio_spark"
include(":app")
