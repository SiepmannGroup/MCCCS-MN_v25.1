set(CMAKE_Fortran_COMPILER "/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/bin/intel64/ifort")
set(CMAKE_Fortran_COMPILER_ARG1 "")
set(CMAKE_Fortran_COMPILER_ID "Intel")
set(CMAKE_Fortran_COMPILER_VERSION "19.0.0.20181018")
set(CMAKE_Fortran_COMPILER_WRAPPER "")
set(CMAKE_Fortran_PLATFORM_ID "Linux")
set(CMAKE_Fortran_SIMULATE_ID "")
set(CMAKE_Fortran_COMPILER_FRONTEND_VARIANT "")
set(CMAKE_Fortran_SIMULATE_VERSION "")




set(CMAKE_AR "/usr/bin/ar")
set(CMAKE_Fortran_COMPILER_AR "")
set(CMAKE_RANLIB "/usr/bin/ranlib")
set(CMAKE_Fortran_COMPILER_RANLIB "")
set(CMAKE_COMPILER_IS_GNUG77 )
set(CMAKE_Fortran_COMPILER_LOADED 1)
set(CMAKE_Fortran_COMPILER_WORKS TRUE)
set(CMAKE_Fortran_ABI_COMPILED TRUE)

set(CMAKE_Fortran_COMPILER_ENV_VAR "FC")

set(CMAKE_Fortran_COMPILER_SUPPORTS_F90 1)

set(CMAKE_Fortran_COMPILER_ID_RUN 1)
set(CMAKE_Fortran_SOURCE_FILE_EXTENSIONS f;F;fpp;FPP;f77;F77;f90;F90;for;For;FOR;f95;F95)
set(CMAKE_Fortran_IGNORE_EXTENSIONS h;H;o;O;obj;OBJ;def;DEF;rc;RC)
set(CMAKE_Fortran_LINKER_PREFERENCE 20)
if(UNIX)
  set(CMAKE_Fortran_OUTPUT_EXTENSION .o)
else()
  set(CMAKE_Fortran_OUTPUT_EXTENSION .obj)
endif()

# Save compiler ABI information.
set(CMAKE_Fortran_SIZEOF_DATA_PTR "8")
set(CMAKE_Fortran_COMPILER_ABI "ELF")
set(CMAKE_Fortran_LIBRARY_ARCHITECTURE "")

if(CMAKE_Fortran_SIZEOF_DATA_PTR AND NOT CMAKE_SIZEOF_VOID_P)
  set(CMAKE_SIZEOF_VOID_P "${CMAKE_Fortran_SIZEOF_DATA_PTR}")
endif()

if(CMAKE_Fortran_COMPILER_ABI)
  set(CMAKE_INTERNAL_PLATFORM_ABI "${CMAKE_Fortran_COMPILER_ABI}")
endif()

if(CMAKE_Fortran_LIBRARY_ARCHITECTURE)
  set(CMAKE_LIBRARY_ARCHITECTURE "")
endif()





set(CMAKE_Fortran_IMPLICIT_INCLUDE_DIRECTORIES "/common/software/install/spack/linux-centos7-ivybridge/gcc-13.1.0/openssl-1.1.1t-hdhinvb6wyp7tg3bofnhxa6kuj7evqqj/include;/common/software/install/spack/linux-centos7-ivybridge/gcc-13.1.0/zlib-1.2.13-2los5xuw5qm5xlkcra34jsqrbz4xnjut/include;/common/software/install/spack/linux-centos7-ivybridge/gcc-13.1.0/ncurses-6.4-bwuoiyb47bp5o7bjpkml32m7zl72vsig/include;/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/ipp/include;/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/mkl/include;/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/pstl/include;/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/tbb/include;/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/daal/include;/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/compiler/include/intel64;/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/compiler/include/icc;/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/compiler/include;/usr/local/include;/usr/lib/gcc/x86_64-redhat-linux/8/include;/usr/include")
set(CMAKE_Fortran_IMPLICIT_LINK_LIBRARIES "ifport;ifcoremt;imf;svml;m;ipgo;irc;pthread;svml;c;gcc;gcc_s;irc_s;dl;c")
set(CMAKE_Fortran_IMPLICIT_LINK_DIRECTORIES "/common/software/install/spack/linux-centos7-ivybridge/gcc-13.1.0/openssl-1.1.1t-hdhinvb6wyp7tg3bofnhxa6kuj7evqqj/lib;/common/software/install/spack/linux-centos7-ivybridge/gcc-13.1.0/zlib-1.2.13-2los5xuw5qm5xlkcra34jsqrbz4xnjut/lib;/common/software/install/spack/linux-centos7-ivybridge/gcc-13.1.0/ncurses-6.4-bwuoiyb47bp5o7bjpkml32m7zl72vsig/lib;/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/mpi/intel64/libfabric/lib;/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/ipp/lib/intel64;/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/tbb/lib/intel64_lin/gcc4.7;/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/compiler/lib/intel64_lin;/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/mkl/lib/intel64_lin;/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/tbb/lib/intel64/gcc4.7;/common/software/install/migrated.intel/x86_64/2019/parallel_studio_xe_msi/compilers_and_libraries_2019.1.144/linux/daal/lib/intel64_lin;/usr/lib/gcc/x86_64-redhat-linux/8;/usr/lib64;/lib64;/usr/lib;/lib")
set(CMAKE_Fortran_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")
