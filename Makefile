# Cấu hình SDK
TARGET := iphone:clang:14.5:15.0
ARCHS = arm64e
THEOS_PACKAGE_SCHEME = rootless
GO_EASY_ON_ME = 1

# Tắt Prefix mặc định
THEOS_PREFIX_HEADER =

# --- CẤU HÌNH QUAN TRỌNG NHẤT ---
# Ép buộc cờ biên dịch là arm64e trực tiếp
# Ép buộc trình liên kết (Linker) dùng arm64e
ADDITIONAL_CFLAGS = -fmodules -Wno-error -include Prefix.pch -arch arm64e
ADDITIONAL_CXXFLAGS = -fmodules -Wno-error -include Prefix.pch -stdlib=libc++ -arch arm64e
ADDITIONAL_LDFLAGS = -fuse-ld=lld -Wl,-undefined,dynamic_lookup -arch arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = VolumeMixer
VolumeMixer_FILES = Tweak.xm VMHookInfo.mm VMHookAudioUnit.mm MRYIPC/MRYIPCCenter.m TweakSB.xm VMHUDView.m VMHUDWindow.m VMHUDRootViewController.m VMLAListener.m VMLAVolumeDownListener.m VMLAVolumeUpListener.m
VolumeMixer_CFLAGS = -fobjc-arc
VolumeMixer_LIBRARIES = substrate activator
VolumeMixer_FRAMEWORKS = UIKit Foundation AudioToolbox CoreMedia AVFoundation
VolumeMixer_PRIVATE_FRAMEWORKS = BackBoardServices MediaRemote

BUNDLE_NAME = volumemixer CCVolumeMixer

volumemixer_FILES = volumemixerpref/VMPrefRootListController.m volumemixerpref/BDInfoListController.m volumemixerpref/VMAuthorListController.m volumemixerpref/VMLicenseViewController.m
volumemixer_INSTALL_PATH = /Library/PreferenceBundles
volumemixer_FRAMEWORKS = UIKit
volumemixer_PRIVATE_FRAMEWORKS = Preferences
volumemixer_CFLAGS = -fobjc-arc
volumemixer_RESOURCE_DIRS = volumemixerpref/Resources

CCVolumeMixer_BUNDLE_EXTENSION = bundle
CCVolumeMixer_FILES = ccvolumemixer/CCVolumeMixer.m
CCVolumeMixer_CFLAGS = -fobjc-arc
CCVolumeMixer_PRIVATE_FRAMEWORKS = ControlCenterUIKit
CCVolumeMixer_INSTALL_PATH = /Library/ControlCenter/Bundles/
CCVolumeMixer_RESOURCE_DIRS = ccvolumemixer/Resources

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp volumemixerpref/entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/volumemixer.plist$(ECHO_END)

after-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/DEBIAN$(ECHO_END)
	$(ECHO_NOTHING)chmod 0755 $(THEOS_STAGING_DIR)/DEBIAN$(ECHO_END)
