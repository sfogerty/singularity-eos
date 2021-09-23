option(SINGULARITY_USE_HDF5 "Enable HDF5" OFF)
mark_as_advanced(SINGULARITY_USE_HDF5)

if(SINGULARITY_USE_HDF5)
    find_package(HDF5 REQUIRED)
    if(NOT HDF5_FOUND)
        message(FATAL_ERROR "HDF5 requested, but not found")
    endif()
    set(SPINER_USE_HDF5 ON CACHE BOOL "Spiner use hdf5" FORCE)
    # TODO: check for cmake version, this behavior is very new
    #list(APPEND TPL_INCLUDES ${HDF5_INCLUDE_DIRS})
    list(APPEND TPL_LIBRARIES ${HDF5_LIBRARIES} ${HDF5_HL_LIBRARIES})
    list(APPEND TPL_DEFINES SINGULARITY_USE_HDF5 SPINER_USE_HDF5)

    if(HDF5_IS_PARALLEL)
        if(NOT TARGET MPI::MPI_CXX)
            find_package(MPI COMPONENTS CXX REQUIRED)
            if(NOT MPI_FOUND)
                message(FATAL_ERROR "The HDF5 package requires MPI")
            endif()
            list(APPEND TPL_LIBRARIES MPI::MPI_CXX)
        endif()
    endif()
endif()