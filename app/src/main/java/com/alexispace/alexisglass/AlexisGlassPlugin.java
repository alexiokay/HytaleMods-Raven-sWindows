package com.alexispace.alexisglass;

import com.hypixel.hytale.server.core.plugin.JavaPlugin;
import com.hypixel.hytale.server.core.plugin.JavaPluginInit;
import java.util.logging.Level;

/**
 * HytaleWindows - Connected glass windows for Hytale
 *
 * This plugin adds glass window blocks that automatically connect to each other,
 * similar to how fences work. The connection logic is handled by Hytale's
 * ConnectedBlockRuleSet system using custom templates.
 *
 * The plugin is mostly asset-based - the connected block template JSON files
 * define how blocks morph based on neighbors. No Java code is needed for
 * the connection logic itself.
 */
public class AlexisGlassPlugin extends JavaPlugin {

    private static AlexisGlassPlugin instance;

    public AlexisGlassPlugin(JavaPluginInit init) {
        super(init);
        instance = this;
    }

    public static AlexisGlassPlugin getInstance() {
        return instance;
    }

    @Override
    public void setup() {
        getLogger().at(Level.INFO).log("Alexi's Glass loading...");

        // All connected block logic is handled by the asset pack JSON files:
        // - Server/Block/ConnectedBlockTemplate/GlassPanelTemplate.json
        // - Server/Block/Blocks/GlassPanel.json
        //
        // The ConnectedBlockRuleSet system automatically handles:
        // 1. Detecting neighboring blocks
        // 2. Selecting the correct shape (Single, Horizontal, Vertical, Corner, etc.)
        // 3. Updating visuals when blocks are placed/removed

        getLogger().at(Level.INFO).log("Alexi's Glass setup complete - connected blocks registered via asset pack");
    }

    @Override
    public void start() {
        getLogger().at(Level.INFO).log("Alexi's Glass started!");
        getLogger().at(Level.INFO).log("Glass windows will now auto-connect when placed adjacent to each other.");
    }

    @Override
    public void shutdown() {
        getLogger().at(Level.INFO).log("Alexi's Glass shutting down...");
    }
}
