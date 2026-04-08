ARCHS = arm64
TARGET = iphone:clang:latest:14.5
DEBUG = 0
FINALPACKAGE = 1
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KandoshV7

# -fobjc-arc + ignores warnings
KandoshV7_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG \
                    -I. -I./LoadView -I./Security -I./Security/oxorany -I./imgui -I./Utils -I./Other -I./hook -I./drawEsp \
                    -w -Wno-everything -fobjc-arc

# Explicitly including all potential source files to fix "symbol(s) not found"
KandoshV7_FILES = ImGuiDrawView.mm $(wildcard *.mm) $(wildcard Security/*.mm) $(wildcard Security/oxorany/*.mm) $(wildcard Security/oxorany/*.cpp) $(wildcard LoadView/*.mm) $(wildcard imgui/*.cpp) $(wildcard imgui/*.mm) $(wildcard Utils/*.mm) $(wildcard Other/*.mm) $(wildcard hook/*.mm) $(wildcard hook/*.cpp) $(wildcard drawEsp/*.mm)

KandoshV7_FRAMEWORKS = UIKit Foundation Security QuartzCore CoreGraphics CoreText Metal MetalKit
KandoshV7_LIBRARIES = substrate c++

include $(THEOS_MAKE_PATH)/tweak.mk
