# TomsOldFMComposerReloaded

I started the editor to edit various objects. Currently it's my sound editor for sound effects and my own frequency modulation format (from the 90s)

---

![Flux Editor](FluxEditor_2026-01-11.png).

---

## 📎 Libraries using OhmFlux Engine
- OpenGL
- Glew
- SDL3
- ImGui
- Box2D
- nlohmann json 
- stb
- ymdm

---

## 🏗 Build Instructions (Native Desktop)

Requires a C++20 compiler, **SDL3**, and **GLEW**.

```shell
# 1. Configure the project
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release

# 2. Build everything
cmake --build build --config Release
```

---

## 📝 Notes

- The composer itself if feature complete. Goal was to implement a FMTPU compatible play/composer. 
- The File Browser will be become better since i'll work on it on OhmFlux Engine. 
- As an goodie it also includes a sfx generator ;)
