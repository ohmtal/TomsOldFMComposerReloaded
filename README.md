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
- The OPLController was part of my OhmFlux Engine. But I'am working on the new version with OPL3 Support. 


---
---

# FMTPU for Turbo Pascal 6

by T. Hühn 1994

This is my source code of the FMTPU. I also include the DOS EXE files which can be used with DosBox.

There are not all files to build in includes folder, since i don't know which Licences they are under. 

The includes/FMTPU.PAS file only uses DOS so not problem to use it ;)


![COMPOSER](pascal/Screenshot_COMPOSER.png)

![INSGEN](pascal/Screenshot_INSGEN.png)
