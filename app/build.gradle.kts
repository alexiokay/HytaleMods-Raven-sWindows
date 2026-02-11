plugins {
    java
    id("com.github.johnrengelman.shadow") version "8.1.1"
}

// Apply our custom run-hytale plugin
apply<RunHytalePlugin>()

group = "com.alexispace"
version = "1.0.3"

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(25))
    }
}

dependencies {
    // Hytale Server API
    compileOnly("com.hypixel.hytale:Server:+")
}

tasks.jar {
    archiveBaseName.set("AlexisGlass")
}

tasks.shadowJar {
    archiveBaseName.set("AlexisGlass")
    archiveClassifier.set("")
}

tasks.build {
    dependsOn(tasks.shadowJar)
}

// Configure the Hytale server runner
configure<RunHytaleExtension> {
    serverPath = "F:/games/hytale"
}
