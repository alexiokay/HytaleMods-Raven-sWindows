# Glass Window Models

This folder contains the 3D models for the connected glass window block.

## Required Models

You need to create 12 `.blockymodel` files:

| File | Shape | Description |
|------|-------|-------------|
| `single.blockymodel` | Single | No connections - standalone post |
| `horizontal.blockymodel` | Horizontal | Connects East-West only |
| `vertical.blockymodel` | Vertical | Connects North-South only |
| `corner_ne.blockymodel` | Corner NE | Connects North and East |
| `corner_nw.blockymodel` | Corner NW | Connects North and West |
| `corner_se.blockymodel` | Corner SE | Connects South and East |
| `corner_sw.blockymodel` | Corner SW | Connects South and West |
| `tshape_n.blockymodel` | T-Shape N | Connects E, W, S (open to North) |
| `tshape_s.blockymodel` | T-Shape S | Connects E, W, N (open to South) |
| `tshape_e.blockymodel` | T-Shape E | Connects N, S, W (open to East) |
| `tshape_w.blockymodel` | T-Shape W | Connects N, S, E (open to West) |
| `cross.blockymodel` | Cross | Connects all 4 directions |

## Texture

- `glass_texture.png` - The glass texture (semi-transparent recommended)

## Model Format

Hytale uses `.blockymodel` JSON format. Example structure:

```json
{
  "formatVersion": 1,
  "textureWidth": 32,
  "textureHeight": 32,
  "nodes": [
    {
      "id": "1",
      "name": "root",
      "position": {"x": 0, "y": 0, "z": 0},
      "shape": {
        "type": "box",
        "offset": {"x": -1, "y": 0, "z": -8},
        "size": {"x": 2, "y": 16, "z": 16}
      }
    }
  ]
}
```

## Design Guidelines

1. **Pane Style**: Models should be thin (2-4 pixels wide) glass panes
2. **Frame**: Consider adding a wood or metal frame around the glass
3. **Center**: The single model should be a centered post (for placing)
4. **Connections**: Other models extend from center to connect to neighbors

## Visual Reference

```
Single:     Horizontal:    Vertical:     Corner NE:
   |           ===            |              |
   |                          |            ==+
   |                          |

T-Shape N:    Cross:
  ===          ===
   |            |
              ===
```

## Tips

- Use Blockbench or Hytale's model editor to create the models
- Export as `.blockymodel` format
- Test in-game by placing windows in different configurations
