cmake_minimum_required(VERSION 3.16)
project(IncludeTestProject LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Disable the demos
set(DISABLE_DEMOS ON CACHE BOOL "Disable engine demos" FORCE)
set(WITH_BOX2D OFF CACHE BOOL "with Box2D" FORCE)


set(OPL_DIR    "${CMAKE_CURRENT_LIST_DIR}/lib/opl")

# fetching OhmFlux
include(FetchContent)

FetchContent_Declare(
    ohmFlux
    GIT_REPOSITORY https://github.com/ohmtal/OhmFlux
    GIT_TAG        main
)

# This command downloads the code and automatically calls add_subdirectory
FetchContent_MakeAvailable(ohmFlux)

# Use  macro


set(COMP_SOURCES
    src/main.cpp
    src/editorGui.cpp
    #  --- opl ---
    ${OPL_DIR}/OplController.cpp
)


configure_project_target(Composer  "${CMAKE_CURRENT_SOURCE_DIR}/" "${CMAKE_CURRENT_SOURCE_DIR}/assets@assets" "${COMP_SOURCES}")

target_include_directories(Composer PRIVATE
    $<BUILD_INTERFACE:${OPL_DIR}>
)
