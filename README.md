# How to Create a Universal Framework for iOS
How create a Framework for iOS using Swift. Based on a mix of [Elad Nava](https://eladnava.com/publish-a-universal-binary-ios-framework-in-swift-using-cocoapods/) and [Zaid Pathan](https://medium.com/captain-ios-experts/develop-a-swift-framework-1c7fdda27bf1)  posts. Modified and updated to work with XCode 9. Include a example project.

## 1. Create a Project
Create a new Xcode project for your framework and select the Cocoa Touch Framework template:

![alt text](https://github.com/juanjoguevara/SimpleFramework/blob/master/XCode%20add%20framework.png)

Enter a Product Name and choose Swift as the project language. For the purpose of writing this guide, I've chosen to create a framework called JJMRSDK that exposes a method which simply prints a String to the console.

Feel free to replace this dummy implementation with your own functionality, and replace JJMRSDK with your own framework name whenever mentioned in the rest of this guide.

## 2. Create framework for both iOS Device and Simulator add new Aggregate target to your project.

Add a new target:

File > New > Target...

Add Agregate target called JJMRSDK-Universal

![alt text](https://github.com/juanjoguevara/SimpleFramework/blob/master/targets.png)

![alt text](https://github.com/juanjoguevara/SimpleFramework/blob/master/targets2.png)

In Build phases add New Run Script Phases

![alt text](https://github.com/juanjoguevara/SimpleFramework/blob/master/script2.png)

Paste the following script

```sh
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

## 3. Build your first framework by Choosing JJMRSDK-Universal target pressing ⌘ + B

After build completed,You will see Finder opening with Your Framework in that.

![alt text](https://github.com/juanjoguevara/SimpleFramework/blob/master/universalgenerated.png)

This is your Universal Framework you can import now in a separate project.

## 4. Test on Terminal

Verify that JJMRSDK.framework is indeed a universal framework by running file JJMRSDK directory:
Open The Terminal and type

```console
file JJMRSDK.framework/JJMRSDK 

```

![alt text](https://github.com/juanjoguevara/SimpleFramework/blob/master/verify.png)

The file contains binaries for the x86_64 and arm64 architectures, which makes it a universal-

## 5. Create a Demo Project

Create demo target with Single View Application called JJMRSDK-Demo for example

When the demo target is created, navigate to its project editor, scroll down to the Embedded Binaries section, click the + icon, and select JJMRSDK.framework:

![alt text](https://github.com/juanjoguevara/SimpleFramework/blob/master/add-library.png)

## 6. Test thats works

Create a simple Class and write some code:

```swift
import UIKit

open class JJMRSDK: NSObject {
    public static let shared = JJMRSDK()
    
    open func hello(){
        debugPrint("Hello World!")
    }
}

```
Import the library in any project and test:

```swift

import UIKit
import JJMRSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        JJMRSDK.shared.hello()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

```
## 7. Build universal framework for Carthage

Select your Universal Target, go to Build Settings and set these values:

![alt text](https://github.com/juanjoguevara/SimpleFramework/blob/master/archive1.png)

Add a new User-Defined Setting:

![alt text](https://github.com/juanjoguevara/SimpleFramework/blob/master/archive2.png)

And set a new value like this: 

![alt text](https://github.com/juanjoguevara/SimpleFramework/blob/master/archive3.png)

Make Build, Archive, upload to your repository and enjoy your new framework! 
