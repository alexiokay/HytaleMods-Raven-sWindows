import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.api.tasks.JavaExec
import org.gradle.kotlin.dsl.*
import java.io.File
import java.net.URL
import java.util.jar.JarFile

/**
 * Gradle plugin for running a local Hytale server for testing.
 *
 * Usage: ./gradlew runServer
 */
open class RunHytaleExtension {
    var serverPath: String = ""
    var serverJar: String = "run/hytale-server.jar"
    var runDir: String = "run"
    var modsDir: String = "run/mods"
    var jvmArgs: List<String> = listOf("-Xmx4G", "-Xms1G", "--enable-native-access=ALL-UNNAMED")
}

class RunHytalePlugin : Plugin<Project> {
    override fun apply(project: Project) {
        val extension = project.extensions.create<RunHytaleExtension>("runHytale")

        project.afterEvaluate {
            // Try to find Hytale installation automatically
            val possiblePaths = listOf(
                "F:/games/hytale",
                System.getenv("LOCALAPPDATA")?.let { "$it/Hytale" },
                System.getenv("APPDATA")?.let { "$it/Hytale" },
                System.getProperty("user.home")?.let { "$it/Hytale" }
            ).filterNotNull()

            val hytalePath = possiblePaths.firstOrNull { File(it).exists() }
            if (hytalePath != null && extension.serverPath.isEmpty()) {
                extension.serverPath = hytalePath
                println("Found Hytale installation at: $hytalePath")
            }

            project.tasks.register<JavaExec>("runServer") {
                group = "hytale"
                description = "Run a local Hytale server for testing"

                dependsOn("shadowJar")

                doFirst {
                    val runDir = File(project.projectDir, extension.runDir)
                    val modsDir = File(project.projectDir, extension.modsDir)

                    runDir.mkdirs()
                    modsDir.mkdirs()

                    val serverJar = findServerJar(project, extension)
                    if (serverJar == null || !serverJar.exists()) {
                        throw org.gradle.api.GradleException("Hytale server not found!")
                    }

                    val pluginJar = project.tasks.getByName("shadowJar").outputs.files.singleFile
                    val destJar = File(modsDir, pluginJar.name)
                    pluginJar.copyTo(destJar, overwrite = true)
                    println("Deployed plugin: ${destJar.absolutePath}")

                    classpath = project.files(serverJar)
                    mainClass.set("com.hypixel.hytale.server.Main")
                    workingDir = runDir
                    jvmArgs = extension.jvmArgs
                    standardInput = System.`in`
                }
            }

            project.tasks.register<org.gradle.api.tasks.Copy>("deployPlugin") {
                group = "hytale"
                description = "Deploy plugin to run/mods folder"

                dependsOn("shadowJar")

                from(project.tasks.getByName("shadowJar").outputs.files)
                into(File(project.projectDir, extension.modsDir))

                doLast {
                    println("Plugin deployed to ${extension.modsDir}")
                }
            }

            project.tasks.register<org.gradle.api.tasks.Copy>("deployToGame") {
                group = "hytale"
                description = "Deploy plugin to your Hytale game mods folder"

                val shadowJarTask = project.tasks.named("shadowJar")
                dependsOn(shadowJarTask)
                inputs.files(shadowJarTask)

                doFirst {
                    if (extension.serverPath.isEmpty()) {
                        throw org.gradle.api.GradleException("serverPath not set")
                    }
                }

                from(shadowJarTask)
                into(File(extension.serverPath, "UserData/Mods"))

                doLast {
                    val modsPath = File(extension.serverPath, "UserData/Mods")
                    println("=========================================")
                    println("Plugin deployed to: ${modsPath.absolutePath}")
                    println("=========================================")
                }
            }
        }
    }

    private fun findServerJar(project: Project, extension: RunHytaleExtension): File? {
        val directJar = File(project.projectDir, extension.serverJar)
        if (directJar.exists()) return directJar

        if (extension.serverPath.isNotEmpty()) {
            val possibleLocations = listOf(
                "install/release/package/game/latest/Server/HytaleServer.jar",
                "install/pre-release/package/game/latest/Server/HytaleServer.jar",
                "Server/HytaleServer.jar",
                "server/HytaleServer.jar",
                "HytaleServer.jar"
            )
            for (loc in possibleLocations) {
                val jar = File(extension.serverPath, loc)
                if (jar.exists()) {
                    println("Found Hytale server at: ${jar.absolutePath}")
                    return jar
                }
            }
        }

        return null
    }
}
