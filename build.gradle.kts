plugins {
    java
}

allprojects {
    repositories {
        mavenCentral()
        maven {
            name = "HytaleRelease"
            url = uri("https://maven.hytale.com/release")
        }
        maven {
            name = "HytalePreRelease"
            url = uri("https://maven.hytale.com/pre-release")
        }
    }
}

subprojects {
    apply(plugin = "java")

    java {
        toolchain {
            languageVersion.set(JavaLanguageVersion.of(25))
        }
    }
}

// Configure Gradle to auto-download Java 25 from Adoptium (Eclipse Temurin)
plugins.withType<JavaPlugin> {
    configure<JavaPluginExtension> {
        toolchain {
            languageVersion.set(JavaLanguageVersion.of(25))
        }
    }
}
