plugins {
    // Gradle toolchain resolver - allows downloading JDKs automatically
    id("org.gradle.toolchains.foojay-resolver-convention") version "0.8.0"
}

rootProject.name = "AlexisGlass"

include("app")
