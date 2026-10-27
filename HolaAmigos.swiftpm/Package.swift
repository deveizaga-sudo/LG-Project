// swift-tools-version: 5.9

// This is a Swift Playgrounds app package. Open it in Xcode 15+ on a Mac
// or in Swift Playgrounds 4.4+ on an iPad or Mac.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Hola Amigos",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .iOSApplication(
            name: "Hola Amigos",
            targets: ["AppModule"],
            bundleIdentifier: "com.holaamigos.app",
            teamIdentifier: "",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .asset("AccentColor"),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)
