# HoaLibrary-Max - CMake Build Configuration
#
# Original HoaLibrary: Copyright (C) 2012-2015 Julien Colafrancesco, Pierre Guillot, Eliott Paris
# v3.0 Modernization: Copyright (C) 2025 Omar Karray
#
# This file is part of HoaLibrary v3.0 for Max 9
# Licensed under GNU General Public License v3.0
#
# CMake build system for Max 9 externals with Universal Binary support

cmake_minimum_required(VERSION 3.19)

project(HoaLibrary-Max)

# Set the path to Max SDK (can be overridden with -DMAX_SDK_PATH=...)
if(NOT DEFINED MAX_SDK_PATH)
    set(MAX_SDK_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../max-sdk" CACHE PATH "Path to Max SDK")
endif()

message(STATUS "Max SDK Path: ${MAX_SDK_PATH}")

# Verify Max SDK exists
if(NOT EXISTS "${MAX_SDK_PATH}/source/max-sdk-base")
    message(FATAL_ERROR "Max SDK not found at ${MAX_SDK_PATH}. Please set MAX_SDK_PATH.")
endif()

# Max SDK includes
set(MAX_SDK_INCLUDES "${MAX_SDK_PATH}/source/max-sdk-base/c74support/max-includes")
set(MAX_SDK_MSP_INCLUDES "${MAX_SDK_PATH}/source/max-sdk-base/c74support/msp-includes")
set(MAX_SDK_JIT_INCLUDES "${MAX_SDK_PATH}/source/max-sdk-base/c74support/jit-includes")

# macOS: Build Universal Binary (x86_64 + arm64) for Max 8+
if(APPLE)
    if(${CMAKE_GENERATOR} MATCHES "Xcode")
        if(${XCODE_VERSION} VERSION_LESS 10)
            message(FATAL_ERROR "Xcode 10 or higher is required.")
        endif()
    endif()
    
    if(NOT CMAKE_OSX_ARCHITECTURES)
        set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64" CACHE STRING "macOS architecture" FORCE)
        message(STATUS "Building Universal Binary: ${CMAKE_OSX_ARCHITECTURES}")
    endif()
    
    set(CMAKE_OSX_DEPLOYMENT_TARGET "10.11" CACHE STRING "Minimum macOS version" FORCE)
endif()

# HoaLibrary C++ headers (header-only library)
set(HOA_LIBRARY_INCLUDES "${CMAKE_CURRENT_SOURCE_DIR}/ThirdParty/HoaLibrary/Sources")

# Common includes for all externals
set(HOA_MAX_INCLUDES
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${HOA_LIBRARY_INCLUDES}
)

# Common source files used by all externals
set(HOA_MAX_COMMON_SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/hoa.max.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/hoa.library.cpp
)

# Preprocessor definitions
add_compile_definitions(
    DENORM_WANT_FIX=1
    NO_TRANSLATION_SUPPORT=1
    HOA_USE_CBLAS=1
)

# Compiler flags
if(APPLE)
    add_compile_options(
        -fvisibility=hidden
        -Wmost
        -Wno-four-char-constants
        -Wno-unknown-pragmas
    )
endif()

# Output directory for compiled externals
set(HOA_PACKAGE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/Package/HoaLibrary")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${HOA_PACKAGE_DIR}/externals")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${HOA_PACKAGE_DIR}/externals")

# Function to create a HoaLibrary external
function(add_hoa_external external_name source_file)
    # Convert name for CMake target (remove ~ and .)
    string(REPLACE "~" "_tilde" target_name ${external_name})
    string(REPLACE "." "_" target_name ${target_name})
    
    # Create the external
    add_library(${target_name} MODULE
        ${source_file}
        ${HOA_MAX_COMMON_SRC}
    )
    
    # Set output name and properties
    set_target_properties(${target_name} PROPERTIES
        OUTPUT_NAME "${external_name}"
        PREFIX ""
        SUFFIX ".mxo"
        BUNDLE TRUE
        BUNDLE_EXTENSION "mxo"
        CXX_STANDARD 11
        CXX_STANDARD_REQUIRED ON
    )
    
    # Include directories
    target_include_directories(${target_name} PRIVATE
        ${MAX_SDK_INCLUDES}
        ${MAX_SDK_MSP_INCLUDES}
        ${MAX_SDK_JIT_INCLUDES}
        ${HOA_MAX_INCLUDES}
    )
    
    # Link frameworks on macOS
    if(APPLE)
        # Find and link Max SDK frameworks
        find_library(MAX_AUDIO_API "MaxAudioAPI" REQUIRED 
            PATHS "${MAX_SDK_MSP_INCLUDES}" 
            NO_DEFAULT_PATH
        )
        find_library(JITTER_API "JitterAPI" REQUIRED
            PATHS "${MAX_SDK_JIT_INCLUDES}"
            NO_DEFAULT_PATH
        )
        
        # Read linker flags from Max SDK (undefined symbols will be provided by Max at runtime)
        file(READ "${MAX_SDK_INCLUDES}/c74_linker_flags.txt" MAX_LINKER_FLAGS)
        string(STRIP "${MAX_LINKER_FLAGS}" MAX_LINKER_FLAGS)
        
        target_link_libraries(${target_name} PUBLIC
            ${MAX_AUDIO_API}
            ${JITTER_API}
            "-framework Accelerate"
            "-framework Carbon"
        )
        
        # Add Max SDK linker flags for undefined symbols
        set_target_properties(${target_name} PROPERTIES
            LINK_FLAGS "${MAX_LINKER_FLAGS}"
        )
    endif()
    
    # Additional sources for specific externals
    set_target_properties(${target_name} PROPERTIES
        XCODE_ATTRIBUTE_GENERATE_PKGINFO_FILE "YES"
    )
endfunction()

# ===== 2D EXTERNALS =====
message(STATUS "Configuring 2D externals...")

add_hoa_external(hoa.2d.decoder~ Max2D/hoa.2d.decoder_tilde.cpp)
add_hoa_external(hoa.2d.encoder~ Max2D/hoa.2d.encoder_tilde.cpp)
add_hoa_external(hoa.2d.exchanger~ Max2D/hoa.2d.exchanger_tilde.cpp)
add_hoa_external(hoa.2d.map~ Max2D/hoa.2d.map_tilde.cpp)
add_hoa_external(hoa.2d.meter~ Max2D/hoa.2d.meter_gui_tilde.cpp)
add_hoa_external(hoa.2d.optim~ Max2D/hoa.2d.optim_tilde.cpp)
add_hoa_external(hoa.2d.projector~ Max2D/hoa.2d.projector_tilde.cpp)
add_hoa_external(hoa.2d.recomposer Max2D/hoa.2d.recomposer_gui.cpp)
target_sources(hoa_2d_recomposer PRIVATE
    Max2D/ChannelManager.cpp
)

add_hoa_external(hoa.2d.recomposer~ Max2D/hoa.2d.recomposer_tilde.cpp)
add_hoa_external(hoa.2d.rotate~ Max2D/hoa.2d.rotate_tilde.cpp)
add_hoa_external(hoa.2d.scope~ Max2D/hoa.2d.scope_gui_tilde.cpp)
add_hoa_external(hoa.2d.space Max2D/hoa.2d.space_gui.cpp)
add_hoa_external(hoa.2d.vector~ Max2D/hoa.2d.vector_tilde.cpp)
add_hoa_external(hoa.2d.wider~ Max2D/hoa.2d.wider_tilde.cpp)

# ===== 3D EXTERNALS =====
message(STATUS "Configuring 3D externals...")

add_hoa_external(hoa.3d.decoder~ Max3D/hoa.3d.decoder_tilde.cpp)
add_hoa_external(hoa.3d.encoder~ Max3D/hoa.3d.encoder_tilde.cpp)
add_hoa_external(hoa.3d.exchanger~ Max3D/hoa.3d.exchanger_tilde.cpp)
add_hoa_external(hoa.3d.map~ Max3D/hoa.3d.map_tilde.cpp)
add_hoa_external(hoa.3d.meter~ Max3D/hoa.3d.meter_gui_tilde.cpp)
add_hoa_external(hoa.3d.optim~ Max3D/hoa.3d.optim_tilde.cpp)
add_hoa_external(hoa.3d.scope~ Max3D/hoa.3d.scope_gui_tilde.cpp)
add_hoa_external(hoa.3d.vector~ Max3D/hoa.3d.vector_tilde.cpp)
add_hoa_external(hoa.3d.wider~ Max3D/hoa.3d.wider_tilde.cpp)

# ===== COMMON EXTERNALS =====
message(STATUS "Configuring common externals...")

add_hoa_external(c.convolve~ MaxCommon/c.convolve_tilde.cpp)
target_sources(c_convolve_tilde PRIVATE
    MaxCommon/FFTConvolver.cpp
    MaxCommon/AudioFFT.cpp
    MaxCommon/Utilities.cpp
)

add_hoa_external(c.freeverb~ MaxCommon/c.freeverb_tilde.cpp)

add_hoa_external(hoa.connect MaxCommon/hoa.connect.cpp)

add_hoa_external(hoa.dac~ MaxCommon/hoa.dac_tilde.c)
# Compile .c file as C++ because it includes C++ headers
set_source_files_properties(MaxCommon/hoa.dac_tilde.c PROPERTIES LANGUAGE CXX)

add_hoa_external(hoa.gain~ MaxCommon/hoa.gain_gui_tilde.cpp)
add_hoa_external(hoa.in MaxCommon/hoa.in.cpp)
add_hoa_external(hoa.in~ MaxCommon/hoa.in_tilde.cpp)
add_hoa_external(hoa.map MaxCommon/hoa.map_gui.cpp)
add_hoa_external(hoa.out MaxCommon/hoa.out.cpp)
add_hoa_external(hoa.out~ MaxCommon/hoa.out_tilde.cpp)
add_hoa_external(hoa.pi MaxCommon/hoa.pi.cpp)
add_hoa_external(hoa.pi~ MaxCommon/hoa.pi_tilde.cpp)
add_hoa_external(hoa.process~ MaxCommon/hoa.process_tilde.cpp)
add_hoa_external(hoa.thisprocess~ MaxCommon/hoa.thisprocess_tilde.cpp)

message(STATUS "")
message(STATUS "===========================================")
message(STATUS "HoaLibrary-Max Configuration Complete")
message(STATUS "===========================================")
message(STATUS "Output directory: ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
message(STATUS "Architectures: ${CMAKE_OSX_ARCHITECTURES}")
message(STATUS "")
message(STATUS "To build:")
message(STATUS "  mkdir build && cd build")
message(STATUS "  cmake ..")
message(STATUS "  cmake --build .")
message(STATUS "===========================================")
