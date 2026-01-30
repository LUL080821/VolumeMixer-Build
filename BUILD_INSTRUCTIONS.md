# VolumeMixer Build & Installation Guide

## Target Device Specifications

- **Device**: iPad M2
- **iOS Version**: 16.0 (20A8372)
- **Jailbreak**: Dopamine2-roothide
- **Architecture**: arm64e
- **Package Scheme**: rootless

## Build Configuration

This project is configured to build a rootless-compatible .deb package specifically optimized for:
- iOS 16.0+ devices
- arm64e architecture (M2 chip)
- Dopamine2-roothide jailbreak environment

### Key Build Settings

```makefile
TARGET = iphone:clang:16.5:16.0
ARCHS = arm64e
THEOS_PACKAGE_SCHEME = rootless
```

## GitHub Actions Build

The repository is configured with automated builds via GitHub Actions:

1. **Push to main branch** triggers automatic build
2. **Manual trigger** via Actions tab → "Build VolumeMixer" → Run workflow
3. **Download artifact** from successful build under "Artifacts" section

### Artifacts Produced

- `VolumeMixer_iOS16_arm64e_rootless_M2` - The compiled .deb package
- `build-logs` - Detailed compilation logs for debugging

## Manual Build Instructions

### Prerequisites

1. **Theos Installation**
   ```bash
   git clone --recursive https://github.com/theos/theos.git $THEOS
   ```

2. **iOS SDK**
   ```bash
   cd $THEOS
   curl -LO https://github.com/theos/sdks/archive/master.zip
   unzip master.zip && mv sdks-master sdks
   ```

3. **Dependencies**
   - ldid (code signing)
   - LibActivator headers
   - AltList framework
   - Preferences framework headers

### Build Commands

```bash
# Clean previous builds
make clean

# Build package
make package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=rootless DEBUG=0

# Package will be created in packages/ directory
```

## Installation on Device

### Method 1: Via Package Manager (Recommended)

1. Copy the .deb file to your device
2. Install using your package manager:
   - Sileo: Add to queue and install
   - Zebra: Install from file
   - Filza: Tap .deb → Install

### Method 2: Manual Installation via SSH

```bash
# Copy package to device
scp packages/*.deb root@<device-ip>:/var/root/

# SSH into device
ssh root@<device-ip>

# Install package
dpkg -i /var/root/com.brend0n.volumemixer_*.deb

# Fix dependencies if needed
apt-get install -f

# Respring
killall -9 SpringBoard
```

## Dependencies

The package requires the following to be installed:

- `mobilesubstrate` - Tweak injection framework
- `preferenceloader` - Preferences integration
- `com.opa334.altlist` - Application list framework
- `firmware (>= 16.0)` - iOS 16.0 or higher

## Rootless Compatibility

This build is specifically configured for rootless jailbreaks (Dopamine2-roothide):

- Uses rootless package scheme
- Proper file paths for rootless environment
- Compatible with roothide injection

### Installation Paths (Rootless)

```
/var/jb/Library/MobileSubstrate/DynamicLibraries/VolumeMixer.dylib
/var/jb/Library/MobileSubstrate/DynamicLibraries/VolumeMixer.plist
/var/jb/Library/PreferenceBundles/volumemixer.bundle/
/var/jb/Library/ControlCenter/Bundles/CCVolumeMixer.bundle/
```

## Troubleshooting

### Build Fails

1. **Check Theos installation**:
   ```bash
   echo $THEOS
   ls $THEOS/makefiles/
   ```

2. **Verify SDK**:
   ```bash
   ls $THEOS/sdks/
   ```

3. **Check dependencies**:
   ```bash
   ls $THEOS/include/libactivator/
   ls $THEOS/include/AltList/
   ls $THEOS/include/Preferences/
   ```

### Package Installation Fails

1. **Check architecture**:
   ```bash
   dpkg --print-architecture
   # Should show: iphoneos-arm64
   ```

2. **Verify dependencies**:
   ```bash
   dpkg -l | grep mobilesubstrate
   dpkg -l | grep preferenceloader
   ```

3. **Check jailbreak type**:
   - Ensure you're using Dopamine2-roothide
   - Other rootless jailbreaks should also work

### Tweak Not Loading

1. **Verify installation**:
   ```bash
   ls -la /var/jb/Library/MobileSubstrate/DynamicLibraries/VolumeMixer.*
   ```

2. **Check filter**:
   ```bash
   cat /var/jb/Library/MobileSubstrate/DynamicLibraries/VolumeMixer.plist
   ```

3. **Respring properly**:
   ```bash
   killall -9 SpringBoard
   ```

4. **Check crash logs**:
   ```bash
   cat /var/mobile/Library/Logs/CrashReporter/Latest/*.ips
   ```

## Features

- Individual app volume control
- Volume HUD interface
- Control Center module
- Preferences panel for configuration
- LibActivator integration

## Configuration

After installation:

1. Open **Settings** app
2. Navigate to **VolumeMixer**
3. Enable/disable per-app volume control
4. Configure individual app volumes

## Support

- **Original Repository**: [brendonjkding/VolumeMixer](https://github.com/brendonjkding/VolumeMixer)
- **Build Issues**: Check GitHub Actions logs
- **Installation Issues**: Verify dependencies and jailbreak compatibility

## License

MIT License - See [LICENSE](LICENSE) file for details

## Credits

- **Author**: Brend0n
- **Contributors**: onewayticket255
- **Build Configuration**: Optimized for iOS 16.0 rootless by LUL080821
