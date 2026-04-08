ARCHS = arm64
TARGET = iphone:clang:latest:14.5
DEBUG = 0
FINALPACKAGE = 1
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KandoshV7

KandoshV7_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG -ILoadView -ISecurity -Iimgui -I.
KandoshV7_FILES = ImGuiDrawView.mm $(wildcard Security/*.mm) $(wildcard LoadView/*.mm) $(wildcard imgui/*.cpp) $(wildcard *.mm)
KandoshV7_FRAMEWORKS = UIKit Foundation Security QuartzCore CoreGraphics CoreText

include $(THEOS_MAKE_PATH)/tweak.mk
