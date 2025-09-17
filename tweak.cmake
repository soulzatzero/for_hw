if(CMAKE_C_COMPILER_ID MATCHES "GNU|Clang")

  # Add a "Profiling" configuration (works for single- and multi-config generators)
  if(NOT CMAKE_CONFIGURATION_TYPES) # single-config (Unix Makefiles, Ninja)
    # Expose Profiling in the cache menu
    set(CMAKE_BUILD_TYPE "Profiling" CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug;Release;RelWithDebInfo;MinSizeRel;Profiling")
  else() # multi-config (Ninja Multi-Config, Visual Studio, etc.)
    list(APPEND CMAKE_CONFIGURATION_TYPES Profiling)
    list(REMOVE_DUPLICATES CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_CONFIGURATION_TYPES "${CMAKE_CONFIGURATION_TYPES}" CACHE STRING "" FORCE)
  endif()

  # Classic per-config flags (picked up by most targets)
  set(CMAKE_C_FLAGS_PROFILING             "-O2 -g -pg -fno-omit-frame-pointer")
  set(CMAKE_CXX_FLAGS_PROFILING           "-O2 -g -pg -fno-omit-frame-pointer")
  set(CMAKE_EXE_LINKER_FLAGS_PROFILING    "-pg")
  set(CMAKE_SHARED_LINKER_FLAGS_PROFILING "-pg")

  # Make absolutely sure ALL targets in this directory tree get -pg (even if they set their own flags)
  add_compile_options(
    $<$<CONFIG:Profiling>:-O2>
    $<$<CONFIG:Profiling>:-g>
    $<$<CONFIG:Profiling>:-pg>
    $<$<CONFIG:Profiling>:-fno-omit-frame-pointer>
)

add_link_options(
    $<$<CONFIG:Profiling>:-pg>
)

  # gprof often breaks with LTO/IPO; keep it off in Profiling
  set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_PROFILING OFF)

  # Optional: turn off sanitizers that can interfere with gprof when Profiling is used
  # set(SANITIZE_FLAGS "")  # only if your project sets custom sanitizer vars; otherwise ignore
endif()
