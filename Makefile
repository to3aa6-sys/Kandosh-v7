ARCHS = arm64
TARGET = iphone:clang:latest:14.5
DEBUG = 0
FINALPACKAGE = 1
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KandoshV7

KandoshV7_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG \
                    -I. -I./LoadView -I./Security -I./Security/oxorany -I./imgui -I./Utils -I./Other -I./hook -I./drawEsp \
                    -w -Wno-everything -fobjc-arc

KandoshV7_FILES = ImGuiDrawView.mm $(wildcard *.mm) $(wildcard Security/*.mm) $(wildcard Security/oxorany/*.mm) $(wildcard LoadView/*.mm) $(wildcard imgui/*.cpp) $(wildcard imgui/*.mm) $(wildcard Utils/*.mm) $(wildcard Other/*.mm) $(wildcard hook/*.mm) $(wildcard drawEsp/*.mm)
KandoshV7_FRAMEWORKS = UIKit Foundation Security QuartzCore CoreGraphics CoreText Metal MetalKit

include $(THEOS_MAKE_PATH)/tweak.mk
