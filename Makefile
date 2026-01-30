ifdef SIMULATOR
export TARGET = simulator:clang:latest:8.0
else
# iOS 16.0 targeting for M2 iPad with rootless jailbreak
# Use SDK 16.0 (available in theos/sdks) with minimum deployment target 16.0
export TARGET = iphone:clang:16.0:16.0
export ARCHS = arm64e
export THEOS_PACKAGE_SCHEME = rootless
endif

INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = VolumeMixer

VolumeMixer_FILES = Tweak.xm VMHookInfo.mm VMHookAudioUnit.mm 
VolumeMixer_FILES += MRYIPC/MRYIPCCenter.m
VolumeMixer_CFLAGS = -fobjc-arc -include Prefix.pch -Wno-error -Wno-unused-variable -Wno-unused-function -Wno-unused-value -Wno-deprecated-declarations
VolumeMixer_CCFLAGS = -std=c++17 -fno-aligned-allocation
VolumeMixer_LDFLAGS = -lc++ -fno-aligned-allocation
VolumeMixer_LIBRARIES += substrate
VolumeMixer_LOGOSFLAGS += -c generator=MobileSubstrate

VolumeMixer_FILES += TweakSB.xm VMHUDView.m VMHUDWindow.m VMHUDRootViewController.m VMLAListener.m VMLAVolumeDownListener.m VMLAVolumeUpListener.m
ifdef SIMULATOR
VolumeMixer_FILES += sim.x
endif

BUNDLE_NAME = volumemixer CCVolumeMixer

volumemixer_FILES = volumemixerpref/VMPrefRootListController.m volumemixerpref/BDInfoListController.m volumemixerpref/VMLicenseViewController.m volumemixerpref/VMAuthorListController.m
volumemixer_INSTALL_PATH = /Library/PreferenceBundles
volumemixer_FRAMEWORKS = UIKit
volumemixer_LIBRARIES = Preferences
volumemixer_CFLAGS = -fobjc-arc -include Prefix.pch -Wno-error -Wno-unused-variable
volumemixer_EXTRA_FRAMEWORKS += AltList
volumemixer_RESOURCE_DIRS = volumemixerpref/Resources

CCVolumeMixer_BUNDLE_EXTENSION = bundle
CCVolumeMixer_FILES = ccvolumemixer/CCVolumeMixer.m
CCVolumeMixer_CFLAGS = -fobjc-arc -Wno-error
CCVolumeMixer_PRIVATE_FRAMEWORKS = ControlCenterUIKit
CCVolumeMixer_INSTALL_PATH = /Library/ControlCenter/Bundles/
CCVolumeMixer_RESOURCE_DIRS = ccvolumemixer/Resources

# Additional flags for compatibility and error suppression
export ADDITIONAL_CFLAGS += -Wno-error=unused-variable -Wno-error=unused-function -Wno-error=unused-value -Wno-error=deprecated-declarations -Wno-error=incompatible-function-pointer-types -include Prefix.pch
export ADDITIONAL_LDFLAGS += -lc++ -Wl,-ld_classic

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp volumemixerpref/entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/volumemixer.plist$(ECHO_END)
