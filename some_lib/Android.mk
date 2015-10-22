#============================================================
# project settings
#============================================================

# module name
# use System.loadLibrary("module_name"); to load it
ZF_MODULE_NAME          = module_name

# source directories to search, under project_path,
# set to "jni" to search whole project_path/jni path
# support relative path
# path must not contain spaces
# may contain more than one directories, separated by space
# use '\' or '/' as path separator
ZF_SRC_DIRS             = jni

# source extensions, separated by space
ZF_SRC_EXTS             = c cpp cxx

# true or false
ZF_BUILD_SHARED         = true

# extra include path setting, separated by space
ZF_INCLUDES             = 

# compiler flags
ZF_CFLAGS               = 

# linker flags
ZF_LFLAGS               = -llog

# third-party libs to load
ZF_LOAD_STATIC_LIB      = 
ZF_LOAD_SHARED_LIB      = 


#============================================================
# LOCAL_PATH need be set only once, before any other code,
# in top-level Android.mk only
#============================================================
LOCAL_PATH := $(call my-dir)

#============================================================
# other custom settings
#============================================================
#include $(CLEAR_VARS)
#LOCAL_MODULE := YourDepModule
#LOCAL_SRC_FILES := path/$(TARGET_ARCH_ABI)/libYourDepModule.so
#include $(PREBUILT_SHARED_LIBRARY)







#============================================================
# no need to change these
#============================================================

#============================================================
# find source files recursively
# usage: $(call zf_find_src_files,$(src_dirs),$(src_exts))
# e.g.:
#   # dirs to search, relative to project_path
#   # set to jni to use whole project_path/jni path
#   SRCDIRS := dir1 dir2
#   # file exts to search
#   SRCEXTS := c cpp
#   # result
#   FILES   := $(call zf_find_src_files, $(SRCDIRS), $(SRCEXTS))
# note:
#   * assume your project is under "c:\project\",
#     with jni lib whose path is "c:\project\jni\some_path\my_lib",
#     then you should cd to "c:\project\",
#     and set SRCDIRS to "jni\some_path\my_lib",
#     then ndk-build
ifeq ($(OS),Windows_NT)
_zf_ls = $(shell dir $(subst /,\,$(1)) /a-d /b /s)
else
_zf_ls = $(shell find $(1) -type f)
endif
_zf_find_src_files = $(subst \,/,$(filter %.$(2),$(call _zf_ls, $(1))))
zf_find_src_files = $(foreach srcdir,$(1),$(foreach srcext,$(2),$(call _zf_find_src_files,$(subst \,/,$(srcdir)),$(srcext))))
#============================================================

include $(CLEAR_VARS)

LOCAL_MODULE := $(ZF_MODULE_NAME)
LOCAL_C_INCLUDES := $(ZF_INCLUDES)
LOCAL_SRC_FILES := $(call zf_find_src_files,$(ZF_SRC_DIRS),$(ZF_SRC_EXTS))
LOCAL_CFLAGS := $(ZF_CFLAGS)
LOCAL_LDLIBS := $(ZF_LFLAGS)

LOCAL_STATIC_LIBRARIES := $(ZF_LOAD_STATIC_LIB)
LOCAL_SHARED_LIBRARIES := $(ZF_LOAD_SHARED_LIB)
ifeq ($(ZF_BUILD_SHARED),true)
include $(BUILD_SHARED_LIBRARY)
else
include $(BUILD_STATIC_LIBRARY)
endif
