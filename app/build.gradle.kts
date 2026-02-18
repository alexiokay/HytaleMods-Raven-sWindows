plugins {
    java
    id("com.github.johnrengelman.shadow") version "8.1.1"
}

// Apply our custom run-hytale plugin
apply<RunHytalePlugin>()

group = "com.alexispace"
version = "1.0.5"

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(25))
    }
}

dependencies {
    // Hytale Server API - local JAR (Maven repo lags behind game updates)
    compileOnly(files("F:/games/hytale/install/release/package/game/latest/Server/HytaleServer.jar"))
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

// Release JAR: excludes test/dev resources (folders ending in _Test)
// Usage: ./gradlew :app:releaseJar
val releaseJar by tasks.registering(com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar::class) {
    from(sourceSets.main.get().output)
    configurations = listOf(project.configurations.runtimeClasspath.get())
    archiveBaseName.set("AlexisGlass")
    archiveClassifier.set("release")
    exclude("**/Common/Items/*_Test/**")
    exclude("**/Server/Item/Items/*_Test*")
}

// Configure the Hytale server runner
configure<RunHytaleExtension> {
    serverPath = "F:/games/hytale"
}
