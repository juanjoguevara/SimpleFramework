# SimpleFramework
How create a Framework for iOS using Swift. Based on a mix of [Elad Nava](https://eladnava.com/publish-a-universal-binary-ios-framework-in-swift-using-cocoapods/) and [Zaid Pathan](https://medium.com/captain-ios-experts/develop-a-swift-framework-1c7fdda27bf1)  posts. Modified to work with XCode 9 

## 1.Create a Project
Create a new Xcode project for your framework and select the Cocoa Touch Framework template:
![alt text](https://github.com/juanjoguevara/SimpleFramework/blob/master/XCode%20add%20framework.png)

Enter a Product Name and choose Swift as the project language. For the purpose of writing this guide, I've chosen to create a framework called JJMRSDK that exposes a method which simply prints a String to the console.

Feel free to replace this dummy implementation with your own functionality, and replace JJMRSDK with your own framework name whenever mentioned in the rest of this guide.

## 2. Create framework for both iOS Device and Simulator add new Aggregate target to your project.

Add 3 new targets:

File> New > Target...

First add Agregate target called JJMRSDK-Universal

![alt text](https://github.com/juanjoguevara/SimpleFramework/blob/master/targets.png)

![alt text](https://github.com/juanjoguevara/SimpleFramework/blob/master/targets2.png)

In Build phases add New Run Script Phases

![alt text](https://github.com/juanjoguevara/SimpleFramework/blob/master/script2.png)

Paste the following script

```
#!/bin/sh
UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal
# make sure the output directory exists
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"
# Step 1. Build Device and Simulator versions
xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
xcodebuild -target "${PROJECT_NAME}" -configuration ${CONFIGURATION} -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
# Step 2. Copy the framework structure (from iphoneos build) to the universal folder
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"
# Step 3. Copy Swift modules from iphonesimulator build (if it exists) to the copied framework directory
SIMULATOR_SWIFT_MODULES_DIR="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule/."
if [ -d "${SIMULATOR_SWIFT_MODULES_DIR}" ]; then
cp -R "${SIMULATOR_SWIFT_MODULES_DIR}" "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule"
fi
# Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework/${PROJECT_NAME}"
# Step 5. Convenience step to copy the framework to the project's directory
cp -R "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework" "${PROJECT_DIR}"
# Step 6. Convenience step to open the project's directory in Finder
open "${UNIVERSAL_OUTPUTFOLDER}"
```

![alt text](https://github.com/juanjoguevara/SimpleFramework/blob/master/script.png)




After add a demo target with Single View Application called JJMRSDK-Demo for example
