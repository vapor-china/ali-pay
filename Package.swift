// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ali-pay",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "AliPay", targets: ["AliPay"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-rc"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "1.0.1"),
        .package(url: "https://github.com/vapor-china/ASN1Decoder.git", from: "1.3.4"),
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.0.0"),
        .package(url: "https://github.com/vapor-china/CryptorRSA.git", from: "1.0.35"),
    ],
    targets: [
        .target(name: "AliPay", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Crypto", package: "swift-crypto"),
            .product(name: "ASN1Decoder", package: "ASN1Decoder"),
            .product(name: "BigInt", package: "BigInt"),
            .product(name: "CryptorRSA", package: "CryptorRSA")
        ]),
        .testTarget(
            name: "AliPayTests",
            dependencies: ["AliPay"]
        )
    ]
)
