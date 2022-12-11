# notarize-app
Notarizes OSX apps built outside of Xcode, and optionally packages them into .dmgs for easy distribution.

## About
This tool was made to make notarizing Unity3D .apps easier. It should still work with other .apps, and I'll try fixing errors to keep it general, but Unity games are what I test it on.
You do need a Mac running a recent version of Xcode, and an up to date, paid, Apple developer account. Please direct complaints to Apple, there's no reason this shouldn't be possible on older Macs and without paying Apple.

Big thanks to the maintainers of [create-dmg](https://github.com/create-dmg/create-dmg/blob/master/README.md), and to @dpid for [this](https://gist.github.com/dpid/270bdb6c1011fe07211edf431b2d0fe4) great gist guide to notarizing Unity builds (the manual way)

If you run into trouble, read that guide (and maybe the comments) in detail, a lot of common issues are discussed.

## Install
- Install with [Homebrew](https://brew.sh/):
```sh
brew install eddiecameron/things/notarize-app
```
OR
- Download or clone repo, then run:
```sh
make install
``` 

## How 2 Use
```sh
notarize-app [options] <folder containing .app, or . to use current directory>
*** wait up to several hours for Apple ***
```
**NOTE:** By default this tool will wait for successful notarization and then "staple" the notarization to the .app/.dmg. If you choose to skip the waiting step (*--skip-wait-for-notarization*), you need to wait for the approval email from Apple, which can take up to an hour, then run `xcrun stapler staple "test.app/test.dmg"` (Instructions are given after a successful notarization submission)

By default, notarize-app looks for a .app in the given folder, signs it, along with any libraries inside it, then notarizes it and uploads to Apple.
Optionally, it can also package the .app along with any other files in the same folder into a .dmg.

#### Credentials
You need a valid Developer ID Application Certificate installed on your machine, this can be generated and downloaded using the Apple developer portal.
On the first run, notarize-app will look for a valid installed Developer ID and use that to sign the app. If multiple are found it will ask you which to use.

If notarizing, it will also ask for your Apple ID credentials and save them to the keychain. You can use a private key or your AppleID + an App Specific Password. It will validate these credentials the first time you provide them, but if they become invalidated later (e.g: you reset the password), you can reset them with the `--reset-credentials` flag

#### Notarization Options
- Entitlements (--entitlements)
  By default, the tool uses a bare bones entitlements file to support a minimal Unity3d Mono build (with entitlements `disable-library-validation`, and `disable-executable-page-protection`). If you need more (or less), you can provide a path to your own entitlements file, in the standard format https://developer.apple.com/documentation/bundleresources/entitlements

- Replacement Mono library (--replace-mono-lib)
  This is a hack to allow notarization of older Unity mono builds, which include a mono library that is built against a too-old version of OSX. This lets you provide a path to a replacement, working, mono framework. If you aren't making a unity 5.x app, you don't need to worry about this. If you are, read this: https://asmaloney.com/2020/03/howto/notarizing-older-unity-games-on-macos/

#### DMG options
If you plan to distribute your app as a DMG, it must also be notarized. Add the (--make-dmg) flag to make a basic "Drag to applications folder" DMG, with the following options:
- DMG name (--dmg-name)
  The name of the output dmg file (without .dmg). Defaults to the same as the .app if not provided

- Window size (--window)
  The width and height of the dmg window when mounted

- Background (--background)
  Path to an image to show as the background to the mounted dmg in finder. Defaults to a rather handsome arrow

- App icon position (--icon-position)
  X and Y position of the .app's icon in the DMG. Defaults to the left hand side of the handsome arrow

- Application shortcut position (--app-drop-link)
  X and Y position of the shortcut to the /Applications folder in the dmg. Defaults to the, oh yes, the right side of the handsome arrow

## Example
```sh
notarize-app \
    --entitlements "~/MyApp/MyFancyEntitlements.entitlements" \
    --background "VeryGoodBackground.png" \
    --dmg-name "MyApp" \
    "~/MyApp/ThisFolderContainsAllMyAppFiles"
```

## Options
```sh
Creates, signs, and notarizes a .app into a DMG
Usage:  notarize-app [options] <src folder to make into dmg (containing .app & any other files)>

Options:
== Apple Notarization Credientials ==
  --reset-credentials
    forces any saved credentials to be ignored. Will re-prompt you for valid Apple ID credentials

== Notarization Options ==
  --entitlements <file.entitlements>
      path to non-default entitlements file
  --replace-mono-lib <path_to_lib_folder>
		provide a patched mono framework for Unity 5 (replaces MonoEmbedRuntime under .app/Contents/Frameworks)

== DMG Packaging ==
If none of these options are set, a DMG will not be made, and only the .app will be signed
  --make-dmg
	  add this flag to make a dmg package with default options
  --dmg-name <name (without .dmg)>
		name of the dmg package. Defaults to the same filename as the .app
  --window <x> <y>
      size of the DMG window
  --background <file_name> 
      image file to use as background of DMG window
  --icon-position <x> <y>
    position of app icon in DMG window
  --app-drop-link <x> <y>
      make a drop link to Applications, at location x,y

  -h, --help
	    display this help screen

==============
```
