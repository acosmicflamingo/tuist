import ProjectDescription
import ProjectDescriptionHelpers

func includeTuistCloud() -> Bool {
    Environment.includeTuistCloud.getBoolean(default: false)
}

func mapDependenciesOfSourcesTargetDependentOnTuistCloud(_ dependencies: [TargetDependency]) -> [TargetDependency] {
    var dependencies = dependencies
    if includeTuistCloud() {
        dependencies.append(.target(name: "TuistCloud"))
    }
    return dependencies
}

func mapDependenciesOfTestsTargetDependentOnTuistCloud(_ dependencies: [TargetDependency]) -> [TargetDependency] {
    var dependencies = dependencies
    if includeTuistCloud() {
        dependencies.append(.target(name: "TuistCloud"))
        dependencies.append(.target(name: "TuistCloudTesting"))
    }
    return dependencies
}

let baseSettings: SettingsDictionary = [:]

func debugSettings() -> SettingsDictionary {
    var settings = baseSettings
    settings["ENABLE_TESTABILITY"] = "YES"
    return settings
}

func releaseSettings() -> SettingsDictionary {
    baseSettings
}

func targets() -> [Target] {
    let executableTargets = [
        Target.target(
            name: "tuistenv",
            product: .commandLineTool,
            dependencies: [
                .target(name: "TuistEnvKit"),
            ]
        ),
        Target.target(
            name: "tuist",
            product: .commandLineTool,
            dependencies: [
                .target(name: "TuistKit"),
                .target(name: "ProjectDescription"),
                .target(name: "ProjectAutomation"),
            ]
        ),
        Target.target(
            name: "tuistbenchmark",
            product: .commandLineTool,
            dependencies: [
                .external(name: "ArgumentParser"),
                .external(name: "SwiftToolsSupport"),
            ]
        ),
        Target.target(
            name: "tuistfixturegenerator",
            product: .commandLineTool,
            dependencies: [
                .external(name: "ArgumentParser"),
                .external(name: "SwiftToolsSupport"),
            ]
        ),
        Target.target(
            name: "TuistIntegrationTests",
            product: .unitTests,
            dependencies: [
                .target(name: "TuistGenerator"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistSupport"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistLoaderTesting"),
            ]
        ),
    ]
    var moduleTargets = [
        Target.module(
            name: "TuistSupport",
            hasIntegrationTests: true,
            dependencies: [
                .external(name: "AnyCodable"),
                .external(name: "ArgumentParser"),
                .external(name: "Checksum"),
                .external(name: "CombineExt"),
                .external(name: "CryptoSwift"),
                .external(name: "GraphViz"),
                .external(name: "KeychainAccess"),
                .external(name: "Logging"),
                .external(name: "PathKit"),
                .external(name: "Queuer"),
                .external(name: "Stencil"),
                .external(name: "StencilSwiftKit"),
                .external(name: "SwiftToolsSupport"),
                .external(name: "Swifter"),
                .external(name: "XcodeProj"),
                .external(name: "ZIPFoundation"),
                .target(name: "ProjectDescription"),
            ],
            testingDependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
            ]
        ),
        Target.module(
            name: "TuistKit",
            hasTesting: false,
            hasIntegrationTests: true,
            dependencies: mapDependenciesOfSourcesTargetDependentOnTuistCloud([
                .target(name: "TuistSupport"),
                .target(name: "TuistGenerator"),
                .target(name: "TuistAutomation"),
                .target(name: "ProjectDescription"),
                .target(name: "ProjectAutomation"),
                .target(name: "TuistLoader"),
                .target(name: "TuistScaffold"),
                .target(name: "TuistSigning"),
                .target(name: "TuistDependencies"),
                .target(name: "TuistMigration"),
                .target(name: "TuistAsyncQueue"),
                .target(name: "TuistAnalytics"),
                .target(name: "TuistPlugin"),
                .target(name: "TuistGraph"),
            ]),
            testDependencies: mapDependenciesOfTestsTargetDependentOnTuistCloud([
                .target(name: "TuistAutomation"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "ProjectDescription"),
                .target(name: "ProjectAutomation"),
                .target(name: "TuistLoaderTesting"),
                .target(name: "TuistGeneratorTesting"),
                .target(name: "TuistScaffoldTesting"),
                .target(name: "TuistAutomationTesting"),
                .target(name: "TuistSigningTesting"),
                .target(name: "TuistDependenciesTesting"),
                .target(name: "TuistMigrationTesting"),
                .target(name: "TuistAsyncQueueTesting"),
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistPlugin"),
                .target(name: "TuistPluginTesting"),
            ]),
            integrationTestsDependencies: mapDependenciesOfTestsTargetDependentOnTuistCloud([
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistSupportTesting"),
                .target(name: "ProjectDescription"),
                .target(name: "ProjectAutomation"),
                .target(name: "TuistLoaderTesting"),
                .target(name: "TuistGraphTesting"),
            ])
        ),
        Target.module(
            name: "TuistEnvKit",
            hasTesting: false,
            dependencies: [
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistSupportTesting"),
            ]
        ),
        Target.module(
            name: "TuistGraph",
            dependencies: [
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistSupport"),
                .target(name: "TuistSupportTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistSupport"),
                .target(name: "TuistSupportTesting"),
            ]
        ),
        Target.module(
            name: "TuistCore",
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "ProjectDescription"),
                .target(name: "TuistSupport"),
                .target(name: "TuistGraph"),
            ],
            testDependencies: [
                .target(name: "TuistSupport"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistSupport"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistSupportTesting"),
            ]
        ),
        Target.module(
            name: "TuistGenerator",
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
                .external(name: "SwiftGenKit"),
            ],
            testDependencies: [
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistSigningTesting"),
            ]
        ),
        Target.module(
            name: "TuistScaffold",
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistGraphTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ]
        ),
        Target.module(
            name: "TuistLoader",
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
                .target(name: "ProjectDescription"),
            ],
            testDependencies: [
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistCore"),
                .target(name: "ProjectDescription"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistSupportTesting"),
                .target(name: "ProjectDescription"),
            ]
        ),
        Target.module(
            name: "TuistAsyncQueue",
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistGraphTesting"),
            ]
        ),
        Target.module(
            name: "TuistPlugin",
            dependencies: [
                .target(name: "TuistGraph"),
                .target(name: "TuistLoader"),
                .target(name: "TuistSupport"),
                .target(name: "TuistScaffold"),
            ],
            testDependencies: [
                .target(name: "ProjectDescription"),
                .target(name: "TuistLoader"),
                .target(name: "TuistLoaderTesting"),
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistSupport"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistScaffoldTesting"),
                .target(name: "TuistCoreTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistGraph"),
            ]
        ),
        Target.module(
            name: "ProjectDescription",
            hasTesting: false,
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistSupport"),
            ]
        ),
        Target.module(
            name: "ProjectAutomation",
            hasTests: false,
            hasTesting: false,
            dependencies: []
        ),
        Target.module(
            name: "TuistSigning",
            hasIntegrationTests: false,
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistGraphTesting"),
            ]
        ),
        Target.module(
            name: "TuistAnalytics",
            hasTesting: false,
            dependencies: mapDependenciesOfSourcesTargetDependentOnTuistCloud([
                .target(name: "TuistAsyncQueue"),
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistLoader"),
                .target(name: "TuistSupport"),
            ]),
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistCoreTesting"),
            ]
        ),
        Target.module(
            name: "TuistMigration",
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistGraphTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ]
        ),
        Target.module(
            name: "TuistDependencies",
            dependencies: [
                .target(name: "ProjectDescription"),
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
                .target(name: "TuistLoaderTesting"),
                .target(name: "TuistSupportTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistGraphTesting"),
            ]
        ),
        Target.module(
            name: "TuistAutomation",
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
            ],
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistCoreTesting"),
                .target(name: "ProjectDescription"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistGraphTesting"),
            ]
        ),
    ].flatMap { $0 }
    if includeTuistCloud() {
        moduleTargets.append(contentsOf: Target.module(
            name: "TuistCloud",
            hasIntegrationTests: true,
            dependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
                .external(name: "OpenAPIRuntime"),
                .external(name: "OpenAPIURLSession"),
            ],
            testDependencies: [
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ],
            testingDependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraphTesting"),
            ],
            integrationTestsDependencies: [
                .target(name: "TuistCore"),
                .target(name: "TuistGraph"),
                .target(name: "TuistSupport"),
                .target(name: "TuistSupportTesting"),
                .target(name: "TuistCoreTesting"),
                .target(name: "TuistGraphTesting"),
            ]
        ).compactMap { $0 })
    }
    return executableTargets + moduleTargets
}

let project = Project(
    name: "Tuist",
    options: .options(
        textSettings: .textSettings(usesTabs: false, indentWidth: 4, tabWidth: 4)
    ),
    settings: .settings(
        configurations: [
            .debug(name: "Debug", settings: debugSettings(), xcconfig: nil),
            .release(name: "Release", settings: releaseSettings(), xcconfig: nil),
        ]
    ),
    targets: targets(),
    additionalFiles: [
        "CHANGELOG.md",
        "README.md",
    ]
)
