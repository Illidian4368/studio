import PackagePlugin

@main
struct MyBuildToolPlugin: BuildToolPlugin {
    /// Entry point for creating build commands for targets in Swift packages.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        // This plugin only runs for package targets that can have source files.
        guard let sourceFiles = target.sourceModule?.sourceFiles else { return [] }

        // Find the code generator tool to run (replace this with the actual one).
        let generatorTool = try context.tool(named: "my-code-generator")

        // Construct a build command for each source file with a particular suffix.
        return sourceFiles.map(\.url).compactMap {
            createBuildCommand(for: $0, in: context.pluginWorkDirectory, with: generatorTool.path)
        }
    }

    /// New function to create test commands for MyBuildToolPlugin
    func createTestCommands(context: PluginContext, target: Target) async throws -> [Command] {
        // This plugin only runs for package targets that can have source files.
        guard let sourceFiles = target.sourceModule?.sourceFiles else { return [] }

        // Find the test tool to run (replace this with the actual one).
        let testTool = try context.tool(named: "my-test-tool")

        // Construct a test command for each source file with a particular suffix.
        return sourceFiles.map(\.path).compactMap {
            createTestCommand(for: $0, in: context.pluginWorkDirectory, with: testTool.path)
        }
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension MyBuildToolPlugin: XcodeBuildToolPlugin {
    // Entry point for creating build commands for targets in Xcode projects.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        // Find the code generator tool to run (replace this with the actual one).
        let generatorTool = try context.tool(named: "my-code-generator")

        // Construct a build command for each source file with a particular suffix.
        return target.inputFiles.map(\.url).compactMap {
            createBuildCommand(for: $0, in: context.pluginWorkDirectory, with: generatorTool.path)
        }
    }
}

#endif

extension MyBuildToolPlugin {
    /// Shared function that returns a configured build command if the input files is one that should be processed.
    func createBuildCommand(for inputPath: Path, in outputDirectoryPath: Path, with generatorToolPath: Path) -> Command? {
        // Skip any file that doesn't have the extension we're looking for (replace this with the actual one).
        guard inputPath.extension == "my-input-suffix" else { return .none }
        
        // Return a command that will run during the build to generate the output file.
        let inputName = inputPath.lastComponent
        let outputName = inputPath.stem + ".swift"
        let outputPath = outputDirectoryPath.appending(outputName)
        return .buildCommand(
            displayName: "Generating \(outputName) from \(inputName)",
            executable: generatorToolPath,
            arguments: ["\(inputPath)", "-o", "\(outputPath)"],
            inputFiles: [inputPath],
            outputFiles: [outputPath]
        )
    }

    /// Shared function that returns a configured test command if the input files is one that should be processed.
    func createTestCommand(for inputPath: Path, in outputDirectoryPath: Path, with testToolPath: Path) -> Command? {
        // Skip any file that doesn't have the extension we're looking for (replace this with the actual one).
        guard inputPath.extension == "my-input-suffix" else { return .none }
        
        // Return a command that will run during the build to generate the output file.
        let inputName = inputPath.lastComponent
        let outputName = inputPath.stem + ".test"
        let outputPath = outputDirectoryPath.appending(outputName)
        return .buildCommand(
            displayName: "Testing \(outputName) from \(inputName)",
            executable: testToolPath,
            arguments: ["\(inputPath)", "-o", "\(outputPath)"],
            inputFiles: [inputPath],
            outputFiles: [outputPath]
        )
    }
}
