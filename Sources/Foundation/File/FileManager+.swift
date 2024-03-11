import Foundation

public extension FileManager {
  @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
  var iCloudDocumentsDirectory: URL? {
    url(forUbiquityContainerIdentifier: nil)?.appending(component: "Documents")
  }
}

public extension FileManager {
  enum ListFileType {
    case raw
    case regularFile
    case directory

    var keys: [URLResourceKey] {
      switch self {
      case .raw:
        []
      case .regularFile:
        [.isRegularFileKey]
      case .directory:
        [.isDirectoryKey]
      }
    }

    var isIncluded: (URL) -> Bool {
      { url -> Bool in
        switch self {
        case .raw:
          true
        case .regularFile:
          !((try? url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? true)
        case .directory:
          (try? url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
        }
      }
    }
  }

  func list(
    at url: URL,
    fileType: ListFileType = .raw,
    options: FileManager.DirectoryEnumerationOptions = []
  ) -> [URL] {
    if let enumerator = enumerator(
      at: url,
      includingPropertiesForKeys: [.isRegularFileKey],
      options: options
    ) {
      Array(
        enumerator.lazy.compactMap { $0 as? URL }
          .filter(fileType.isIncluded)
      )
    } else {
      []
    }
  }
}

public extension FileManager.DirectoryEnumerationOptions {
  static let common: Self = [
    .skipsHiddenFiles,
    .skipsPackageDescendants,
  ]
}

/// Copied from https://github.com/wvdk/FileManagerCopyAllChildren/blob/main/Sources/FileManagerCopyAllChildren/FileManager%2BcopyAllChildren.swift
public extension FileManager {
  func sizeOfEntireFolder(
    at target: URL,
    ignoreHiddenFiles shouldIgnoreHiddenFiles: Bool = false
  ) throws -> Int64 {
    let contents = list(
      at: target,
      fileType: .raw,
      options: shouldIgnoreHiddenFiles ? [.skipsHiddenFiles] : []
    )

    var total = Int64(0)
    for itemURL in contents {
      if
        let attr = try? attributesOfItem(atPath: itemURL.path),
        let size = attr[FileAttributeKey.size] as? NSNumber
      {
        total += size.int64Value
      }
    }

    return total
  }

  func deleteEntireFolder(
    at target: URL,
    ignoreHiddenFiles shouldIgnoreHiddenFiles: Bool = false
  ) throws {
    let contents = try contentsOfEntireFolder(
      at: target,
      ignoreHiddenFiles: shouldIgnoreHiddenFiles
    )
    for itemURL in contents {
      if fileExists(atPath: itemURL.path) {
        try removeItem(at: itemURL)
      }
    }
  }

  private func contentsOfEntireFolder(
    at target: URL,
    ignoreHiddenFiles shouldIgnoreHiddenFiles: Bool = false
  ) throws -> [URL] {
    // Check that the target is a directory and not empty.
    var isDirectory: ObjCBool = false
    guard fileExists(atPath: target.path, isDirectory: &isDirectory) else {
      throw ReadEntireFolderError.targetDoesNotExist
    }
    guard isDirectory.boolValue else {
      throw ReadEntireFolderError.targetIsNotADirectory
    }

    let contents = try contentsOfDirectory(
      at: target,
      includingPropertiesForKeys: nil,
      options: shouldIgnoreHiddenFiles ? [.skipsHiddenFiles] : []
    )

    return contents
  }

  enum ReadEntireFolderError: Error {
    case targetDoesNotExist
    case targetIsNotADirectory
  }

  /// A method which copies all files and subdirectories from a given orgin into a given target directory.
  ///
  /// The origin must be a local directory which contain at least one file or subdirectory. The target directory will be created if it does not already exist. This method can also delete the origin directory (and all it's children) when finished copying. You can specify if hidden files should be ignored or included in the copy.
  ///
  /// - Parameters:
  ///   - origin: The `URL` of a local directory to who's contents (files and directories) will be copied.
  ///   - target: The `URL` of a local directory into which the contents of `origin` should be copied. If there is no directory at the target URL this method will attempt to create one. If the target URL already contains files they will be left alone or overridden by anything in origin with the same name.
  ///   - shouldDeleteOrigin: Pass `true` to `deleteOriginWhenDone` to force the deletion
  ///   - ignoreHiddenFiles: Pass `true ` to ignore any hidden files in the origin directory and only copy the non-hidden files and directories.
  ///
  /// - Throws: Can throw a `FileManagerCopyAllChildrenError` if something goes wrong or is impossible.
  func copyEntireFolder(
    from origin: URL,
    to target: URL,
    deleteOriginWhenDone shouldDeleteOrigin: Bool = false,
    ignoreHiddenFiles shouldIgnoreHiddenFiles: Bool = false
  ) throws {
    // First check that the origin is a directory and not empty.
    var originIsDirectory: ObjCBool = false
    guard fileExists(atPath: origin.path, isDirectory: &originIsDirectory) else {
      throw CopyEntireFolderError.originDoesNotExist
    }
    guard originIsDirectory.boolValue else {
      throw CopyEntireFolderError.originIsNotADirectory
    }

    let originContents: [URL]
    do {
      originContents = try contentsOfDirectory(
        at: origin,
        includingPropertiesForKeys: nil,
        options: shouldIgnoreHiddenFiles ? [.skipsHiddenFiles] : []
      )
    } catch {
      throw CopyEntireFolderError.originIsEmpty
    }

    guard !originContents.isEmpty else {
      throw CopyEntireFolderError.originIsEmpty
    }

    // Lets check that the origin and target are not the same location.
    guard origin.path != target.path else {
      throw CopyEntireFolderError.originAndTargetAreTheSame
    }

    // Now either create a new target or make sure the existing one is a directory
    var targetIsDirectory: ObjCBool = false
    if fileExists(atPath: target.path, isDirectory: &targetIsDirectory) {
      // Check that it's a directory
      if !targetIsDirectory.boolValue {
        throw CopyEntireFolderError.targetExistsButIsNotADirectory
      }
    } else {
      do {
        try createDirectory(at: target, withIntermediateDirectories: true, attributes: nil)
      } catch {
        throw CopyEntireFolderError.couldNotCreateDirectoryForTarget
      }
    }
    guard originIsDirectory.boolValue else {
      throw CopyEntireFolderError.originIsNotADirectory
    }

    // Finally copy all the contents of origin into target
    for originItemURL in originContents {
      let targetItemURL = target.appendingPathComponent(originItemURL.lastPathComponent)

      // Delete the existing target file if needed
      if fileExists(atPath: targetItemURL.path) {
        do {
          try removeItem(at: targetItemURL)
        } catch {
          throw CopyEntireFolderError.failedToDeleteExistingTargetItem
        }
      }

      do {
        try copyItem(at: originItemURL, to: targetItemURL)
      } catch {
        throw CopyEntireFolderError.failedToCopyItem
      }
    }

    // Delete the origin directory if needed
    if shouldDeleteOrigin {
      do {
        try removeItem(at: origin)
      } catch {
        throw CopyEntireFolderError.failedToDeleteOrigin
      }
    }
  }

  /// An `Error` returned by the `copyAllChildren(from:to:)` method to indicate that something went wrong or was not possible.
  enum CopyEntireFolderError: Error {
    /// The URL provided for the origin directory does not point to a valid file.
    case originDoesNotExist

    /// The origin directory does not contain any files or subdirectories.
    case originIsEmpty

    /// The origin URL does not point to a valid directory.
    case originIsNotADirectory

    /// The origin and target URLs cannot be the same.
    case originAndTargetAreTheSame

    /// The target URL points to a file not a directory.
    case targetExistsButIsNotADirectory

    /// Unable to create a new directory at the target URL.
    case couldNotCreateDirectoryForTarget

    /// Failed to copy on of the items in the origin directory.
    case failedToCopyItem

    /// Failed to delete the origin directory.
    case failedToDeleteOrigin

    /// Failed to delete an existing item in the target directory.
    case failedToDeleteExistingTargetItem
  }
}
