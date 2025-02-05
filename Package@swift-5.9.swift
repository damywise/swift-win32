// swift-tools-version:5.9

import PackageDescription

let SwiftWin32: Package =
  Package(name: "SwiftWin32",
          products: [
            .library(name: "SwiftWin32",
                      type: .dynamic,
                      targets: ["SwiftWin32"]),
            .library(name: "SwiftWin32UI",
                      type: .dynamic,
                      targets: ["SwiftWin32UI"]),
            .executable(name: "UICatalog", targets: ["UICatalog"]),
            .executable(name: "Calculator", targets: ["Calculator"]),
          ],
          dependencies: [
            .package(url: "https://github.com/apple/swift-log.git",
                     .upToNextMajor(from: "1.4.3")),
            .package(url: "https://github.com/apple/swift-collections.git",
                     .upToNextMinor(from: "1.0.0")),
            .package(url: "https://github.com/compnerd/cassowary.git",
                     branch: "main"),
            .package(url: "https://github.com/compnerd/swift-com.git",
                     revision: "ebbc617d3b7ba3a2023988a74bebd118deea4cc5"),
          ],
          targets: [
            .target(name: "CoreAnimation",
                    path: "Sources/SwiftWin32/CoreAnimation"),
            .target(name: "SwiftWin32",
                    dependencies: [
                      "CoreAnimation",
                      .product(name: "Logging", package: "swift-log"),
                      .product(name: "OrderedCollections",
                               package: "swift-collections"),
                      .product(name: "cassowary", package: "cassowary"),
                      .product(name: "SwiftCOM", package: "swift-com"),
                    ],
                    path: "Sources/SwiftWin32",
                    exclude: ["CoreAnimation", "CMakeLists.txt"],
                    swiftSettings: [
                        .enableExperimentalFeature("AccessLevelOnImport")
                    ],
                    linkerSettings: [
                      .linkedLibrary("User32"),
                      .linkedLibrary("ComCtl32"),
                    ]
                    ),
            .target(name: "SwiftWin32UI",
                    dependencies: ["SwiftWin32"],
                    path: "Sources/SwiftWin32UI",
                    exclude: ["CMakeLists.txt"]),
            .executableTarget(name: "Calculator",
                              dependencies: ["SwiftWin32"],
                              path: "Examples/Calculator",
                              exclude: [
                                "CMakeLists.txt",
                                "Calculator.exe.manifest",
                                "Info.plist",
                              ],
                              swiftSettings: [
                                .enableExperimentalFeature("AccessLevelOnImport"),
                                .unsafeFlags(["-parse-as-library"])
                              ]),
            .executableTarget(name: "UICatalog",
                              dependencies: ["SwiftWin32"],
                              path: "Examples/UICatalog",
                              exclude: [
                                "CMakeLists.txt",
                                "Info.plist",
                                "UICatalog.exe.manifest",
                              ],
                              resources: [
                                .copy("Assets/CoffeeCup.jpg")
                              ],
                              swiftSettings: [
                                .unsafeFlags(["-parse-as-library"])
                              ]),
            .target(name: "TestUtilities", path: "Tests/Utilities"),
            .testTarget(name: "AutoLayoutTests", dependencies: ["SwiftWin32"]),
            .testTarget(name: "CoreGraphicsTests", dependencies: ["SwiftWin32"]),
            .testTarget(name: "SupportTests", dependencies: ["SwiftWin32"]),
            .testTarget(name: "UICoreTests",
                        dependencies: ["SwiftWin32", "TestUtilities"])
          ])