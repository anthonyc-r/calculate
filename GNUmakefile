#
# GNUmakefile - Generated by ProjectCenter
#
ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif
ifeq ($(GNUSTEP_MAKEFILES),)
 $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

#
# Application
#
VERSION = 0.1
PACKAGE_NAME = Calculate
APP_NAME = Calculate
Calculate_APPLICATION_ICON = Calculate.tiff


#
# Resource files
#
Calculate_RESOURCE_FILES = \
Resources/Calculate.gorm \
Resources/Calculate.tiff


#
# Header files
#
Calculate_HEADER_FILES = \
CalculateManager.h \
Calculator.h

#
# Class files
#
Calculate_OBJC_FILES = \
CalculateManager.m \
Calculator.m

#
# Other sources
#
Calculate_OBJC_FILES += \
Calculate_main.m 

#
# Makefiles
#
-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/aggregate.make
include $(GNUSTEP_MAKEFILES)/application.make
-include GNUmakefile.postamble
