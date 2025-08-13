// swift-tools-version:6.0

import PackageDescription

/// # MyVaporPOC Package
/// The Swift Package Manifest for the MyVaporPOC backend.
///
/// - Defines all dependencies and build platforms
/// - Declares main API target, test suites, and their relationships
/// - Part of the Portkey: Tenant OAuth MVP (see project documentation)
let package = Package(
    /**
     The name of the package (module root).
     */
    name: "MyVaporPOC",

    /**
     Supported platforms and minimum OS versions.
     Adjust as needed to target other Apple platforms or Linux.
     */
    platforms: [
        .macOS(.v13)
    ],

    /**
     Dependencies for this project:
     - Vapor: Main web framework for server-side Swift
     - Fluent: ORM for SQL/NoSQL databases
     - FluentSQLiteDriver: SQLite driver for Fluent
     - Leaf: Templating language (if needed for web outputs)
     - swift-nio: Non-blocking networking, used by Vapor and for executors
     */
    dependencies: [
        // 💧 Server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // 🗄 ORM for SQL/NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        // 🪶 SQLite driver for Fluent ORM.
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.6.0"),
        // 🍃 Templating engine (for any server-side rendered pages/emails).
        .package(url: "https://github.com/vapor/leaf.git", from: "4.3.0"),
        // 🔵 Non-blocking networking (foundation of server).
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
    ],

    /**
     Package targets:
     - Main executable (App)
     - Test suite target with in-memory DB and API endpoint coverage
     */
    targets: [
        /**
         ## Main API Target
         - Depends on: Fluent, SQLite, Leaf, Vapor, swift-nio components
         - Build product is the server-side executable for the backend
         - Use this to implement business logic, routes, and DB operations.
         */
        .executableTarget(
            name: "MyVaporPOC",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "Leaf", package: "leaf"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
            ],
            swiftSettings: swiftSettings
        ),

        /**
         ## Test Target
         - Depends on: The main API target and Vapor's built-in testing support
         - Contains all API and integration tests, including those for endpoints,
            DB interactions, and authorization flows
         - Uses Testing/VaporTesting for isolated, in-memory tests (no live HTTP server needed)
         */
        .testTarget(
            name: "MyVaporPOCTests",
            dependencies: [
                .target(name: "MyVaporPOC"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)

/// Swift compiler feature flags for this project.
/// - Enables any upcoming Swift language features needed.
var swiftSettings: [SwiftSetting] {
    [
        .enableUpcomingFeature("ExistentialAny")
    ]
}
