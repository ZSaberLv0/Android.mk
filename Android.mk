# set LOCAL_PATH in top-level Android.mk only
LOCAL_PATH := $(call my-dir)
include $(call all-subdir-makefiles)

clean:
	-rd /s/q obj
