#!/bin/sh
APPBUNDLE=ioUrbanTerror.app
BINARY=ioUrbanTerror.ub
PKGINFO=APPLIOURT
ICNS=code/unix/MacSupport/iourbanterror.icns
DESTDIR=build/release-darwin-ub
BASEDIR=baseq3
MPACKDIR=missionpack
Q3_VERSION=`grep "\#define Q3_VERSION" code/qcommon/q_shared.h | \
	sed -e 's/.*".* \([^ ]*\)"/\1/'`;

BIN_OBJ="
	build/release-darwin-ppc/ioUrbanTerror.ppc
	build/release-darwin-i386/ioUrbanTerror.i386
"
BASE_OBJ="
	build/release-darwin-ppc/$BASEDIR/cgameppc.dylib
	build/release-darwin-i386/$BASEDIR/cgamei386.dylib
	build/release-darwin-ppc/$BASEDIR/uippc.dylib
	build/release-darwin-i386/$BASEDIR/uii386.dylib
	build/release-darwin-ppc/$BASEDIR/qagameppc.dylib
	build/release-darwin-i386/$BASEDIR/qagamei386.dylib
"
MPACK_OBJ="
	build/release-darwin-ppc/$MPACKDIR/cgameppc.dylib
	build/release-darwin-i386/$MPACKDIR/cgamei386.dylib
	build/release-darwin-ppc/$MPACKDIR/uippc.dylib
	build/release-darwin-i386/$MPACKDIR/uii386.dylib
	build/release-darwin-ppc/$MPACKDIR/qagameppc.dylib
	build/release-darwin-i386/$MPACKDIR/qagamei386.dylib
"
if [ ! -f Makefile ]; then
	echo "This script must be run from the ioUrbanTerror build directory";
fi

#if [ ! -d /Developer/SDKs/MacOSX10.2.8.sdk ]; then
#	echo "
#/Developer/SDKs/MacOSX10.2.8.sdk/ is missing.
#The installer for this SDK is included with XCode 2.2 or newer"
#	exit 1;
#fi
#
#if [ ! -d /Developer/SDKs/MacOSX10.4u.sdk ]; then
#	echo "
#/Developer/SDKs/MacOSX10.4u.sdk/ is missing.   
#The installer for this SDK is included with XCode 2.2 or newer"
#	exit 1;
#fi

(BUILD_MACOSX_UB=ppc make && BUILD_MACOSX_UB=i386 make) || exit 1;

echo "Creating .app bundle $DESTDIR/$APPBUNDLE"
if [ ! -d $DESTDIR/$APPBUNDLE/Contents/MacOS/$BASEDIR ]; then
	mkdir -p $DESTDIR/$APPBUNDLE/Contents/MacOS/$BASEDIR || exit 1;
fi
if [ ! -d $DESTDIR/$APPBUNDLE/Contents/MacOS/$MPACKDIR ]; then
	mkdir -p $DESTDIR/$APPBUNDLE/Contents/MacOS/$MPACKDIR || exit 1;
fi
if [ ! -d $DESTDIR/$APPBUNDLE/Contents/Resources ]; then
	mkdir -p $DESTDIR/$APPBUNDLE/Contents/Resources
fi
cp $ICNS $DESTDIR/$APPBUNDLE/Contents/Resources/iourbanterror.icns || exit 1;
echo $PKGINFO > $DESTDIR/$APPBUNDLE/Contents/PkgInfo
echo "
	<?xml version=\"1.0\" encoding="UTF-8"?>
	<!DOCTYPE plist
		PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\"
		\"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
	<plist version=\"1.0\">
	<dict>
		<key>CFBundleDevelopmentRegion</key>
		<string>English</string>
		<key>CFBundleExecutable</key>
		<string>$BINARY</string>
		<key>CFBundleGetInfoString</key>
		<string>ioUrbanTerror $Q3_VERSION</string>
		<key>CFBundleIconFile</key>
		<string>iourbanterror.icns</string>
		<key>CFBundleIdentifier</key>
		<string>net.urbanterror.www</string>
		<key>CFBundleInfoDictionaryVersion</key>
		<string>6.0</string>
		<key>CFBundleName</key>
		<string>ioUrbanTerror</string>
		<key>CFBundlePackageType</key>
		<string>APPL</string>
		<key>CFBundleShortVersionString</key>
		<string>$Q3_VERSION</string>
		<key>CFBundleSignature</key>
		<string>$PKGINFO</string>
		<key>CFBundleVersion</key>
		<string>$Q3_VERSION</string>
		<key>NSExtensions</key>
		<dict/>
		<key>NSPrincipalClass</key>
		<string>NSApplication</string>
	</dict>
	</plist>
	" > $DESTDIR/$APPBUNDLE/Contents/Info.plist

lipo -create -o $DESTDIR/$APPBUNDLE/Contents/MacOS/$BINARY $BIN_OBJ
cp $BASE_OBJ $DESTDIR/$APPBUNDLE/Contents/MacOS/$BASEDIR/
cp $MPACK_OBJ $DESTDIR/$APPBUNDLE/Contents/MacOS/$MPACKDIR/
cp code/libs/macosx/*.dylib $DESTDIR/$APPBUNDLE/Contents/MacOS/

