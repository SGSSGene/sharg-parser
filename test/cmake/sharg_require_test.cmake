# --------------------------------------------------------------------------------------------------------
# Copyright (c) 2006-2021, Knut Reinert & Freie Universität Berlin
# Copyright (c) 2016-2021, Knut Reinert & MPI für molekulare Genetik
# This file may be used, modified and/or redistributed under the terms of the 3-clause BSD-License
# shipped with this file and also available at: https://github.com/seqan/sharg-parser/blob/main/LICENSE.md
# --------------------------------------------------------------------------------------------------------

# 3.14 is enough for the FetchContent feature, but it has a bug that prevents it from working.
cmake_minimum_required (VERSION 3.15)

# Exposes the google-test targets `gtest` and `gtest_main`.
macro (sharg_require_test)
    enable_testing ()

    set (gtest_git_tag "release-1.11.0")

    message (STATUS "Fetch Google Test:")

    include (FetchContent)
    FetchContent_Declare (
        gtest_fetch_content
        GIT_REPOSITORY "https://github.com/google/googletest.git"
        GIT_TAG "${gtest_git_tag}")
    option (BUILD_GMOCK "" OFF)
    FetchContent_MakeAvailable (gtest_fetch_content)

    if (NOT TARGET gtest_build)
        add_custom_target (gtest_build DEPENDS gtest_main gtest)
        target_compile_options ("gtest_main" PUBLIC "-w")
        target_compile_options ("gtest" PUBLIC "-w")
    endif ()
endmacro ()
