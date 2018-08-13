# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO cginternals/glbinding
    REF v3.0.2
    SHA512 524ad20a11af7d8ee1764f53326b43efb3b3dbd6c64d1539f4d9fa2bcb7b58a6bd6caf460d6944aed4fd7439b82536d8f28a0f0f51c14c62c2f0c73baab9afcb
    HEAD_REF master
)
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DOPTION_BUILD_EXAMPLES=OFF
        -DOPTION_BUILD_TESTS=OFF
        -DOPTION_BUILD_TOOLS=OFF
        -DOPTION_BUILD_GPU_TESTS=OFF
)

vcpkg_install_cmake()


file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
#file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share)
#file(RENAME ${CURRENT_PACKAGES_DIR}/cmake/glbinding ${CURRENT_PACKAGES_DIR}/share/glbinding)
#file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/cmake)

# TODO figure out how to get vcpkg_fixup_cmake_targets() to fixup both glbinding & glbinding-aux libraries
# currently only the first only end up being usable.
vcpkg_fixup_cmake_targets(CONFIG_PATH "cmake/glbinding")
#vcpkg_fixup_cmake_targets(CONFIG_PATH "cmake/glbinding-aux")

#file(READ ${CURRENT_PACKAGES_DIR}/debug/cmake/glbinding/glbinding-export-debug.cmake GLBINDING_DEBUG_MODULE)
#string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" GLBINDING_DEBUG_MODULE "${GLBINDING_DEBUG_MODULE}")
#string(REPLACE "glbindingd.dll" "bin/glbindingd.dll" GLBINDING_DEBUG_MODULE "${GLBINDING_DEBUG_MODULE}")
#file(WRITE ${CURRENT_PACKAGES_DIR}/share/glbinding/glbinding-export-debug.cmake "${GLBINDING_DEBUG_MODULE}")
#
#file(READ ${CURRENT_PACKAGES_DIR}/share/glbinding/glbinding-export-release.cmake RELEASE_CONF)
#string(REPLACE "glbinding.dll" "bin/glbinding.dll" RELEASE_CONF "${RELEASE_CONF}")
#file(WRITE ${CURRENT_PACKAGES_DIR}/share/glbinding/glbinding-export-release.cmake "${RELEASE_CONF}")
#
#file(READ ${CURRENT_PACKAGES_DIR}/debug/cmake/glbinding-aux/glbinding-aux-export-debug.cmake GLBINDING_AUX_DEBUG_MODULE)
#string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" GLBINDING_AUX_DEBUG_MODULE "${GLBINDING_AUX_DEBUG_MODULE}")
#string(REPLACE "glbinding-auxd.dll" "bin/glbinding-auxd.dll" GLBINDING_AUX_DEBUG_MODULE "${GLBINDING_AUX_DEBUG_MODULE}")
#file(WRITE ${CURRENT_PACKAGES_DIR}/share/glbinding-aux/glbinding-aux-export-debug.cmake "${GLBINDING_AUX_DEBUG_MODULE}")
#
#file(READ ${CURRENT_PACKAGES_DIR}/share/glbinding-aux/glbinding-aux-export.cmake GLBINDING_AUX_RELEASE_MODULE)
#string(REPLACE "glbinding-aux.dll" "bin/glbinding-aux.dll" GLBINDING_AUX_RELEASE_MODULE "${GLBINDING_AUX_RELEASE_MODULE}")
#file(WRITE ${CURRENT_PACKAGES_DIR}/share/glbinding/glbinding-aux-export-release.cmake "${GLBINDING_AUX_RELEASE_MODULE}")

file(REMOVE ${CURRENT_PACKAGES_DIR}/glbinding-config.cmake)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/glbinding-config.cmake)
#file(RENAME ${CURRENT_PACKAGES_DIR}/share/glbinding/glbinding-export.cmake ${CURRENT_PACKAGES_DIR}/share/glbinding/glbinding-config.cmake)
if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/bin)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/bin)
    file(RENAME ${CURRENT_PACKAGES_DIR}/glbinding.dll ${CURRENT_PACKAGES_DIR}/bin/glbinding.dll)
    file(RENAME ${CURRENT_PACKAGES_DIR}/debug/glbindingd.dll ${CURRENT_PACKAGES_DIR}/debug/bin/glbindingd.dll)
    file(RENAME ${CURRENT_PACKAGES_DIR}/glbinding-aux.dll ${CURRENT_PACKAGES_DIR}/bin/glbinding-aux.dll)
    file(RENAME ${CURRENT_PACKAGES_DIR}/debug/glbinding-auxd.dll ${CURRENT_PACKAGES_DIR}/debug/bin/glbinding-auxd.dll)
endif()
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/data)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/data)
file(REMOVE ${CURRENT_PACKAGES_DIR}/AUTHORS
            ${CURRENT_PACKAGES_DIR}/LICENSE
            ${CURRENT_PACKAGES_DIR}/README.md
            ${CURRENT_PACKAGES_DIR}/VERSION
            ${CURRENT_PACKAGES_DIR}/debug/AUTHORS
            ${CURRENT_PACKAGES_DIR}/debug/LICENSE
            ${CURRENT_PACKAGES_DIR}/debug/README.md
            ${CURRENT_PACKAGES_DIR}/debug/VERSION
    )

# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/glbinding)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/glbinding/LICENSE ${CURRENT_PACKAGES_DIR}/share/glbinding/copyright)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

vcpkg_copy_pdbs()