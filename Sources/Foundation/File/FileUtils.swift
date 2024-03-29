import Foundation

public enum FileUtils {
  enum Failure: Error {
    case fileNotExist
  }

  private static let decoder: JSONDecoder = .init()
  private static let encoder: JSONEncoder = .init()
}

public extension FileUtils {
  static func write(
    _ value: Data,
    to directory: FileManager.SearchPathDirectory,
    fileName: String
  ) throws {
    guard let url = FileManager.default.urls(
      for: directory, in: .userDomainMask
    ).first else { return }
    try write(value, to: url.appendingPathComponent(fileName))
  }

  static func write(
    _ value: some Encodable,
    to directory: FileManager.SearchPathDirectory,
    fileName: String
  ) throws {
    guard let url = FileManager.default.urls(
      for: directory, in: .userDomainMask
    ).first else { return }
    try write(value, to: url.appendingPathComponent(fileName))
  }

  static func write(_ value: some Encodable, to url: URL) throws {
    try write(encoder.encode(value), to: url)
  }

  static func write(_ data: Data, to url: URL) throws {
    try data.write(to: url)
  }

  static func delete(
    from directory: FileManager.SearchPathDirectory,
    fileName: String
  ) throws {
    guard let url = FileManager.default.urls(
      for: directory,
      in: .userDomainMask
    ).first else { return }
    try FileManager.default.removeItem(at: url.appendingPathComponent(fileName))
  }

  static func load(
    from directory: FileManager.SearchPathDirectory,
    fileName: String
  ) throws -> Data {
    guard let url = FileManager.default.urls(
      for: directory,
      in: .userDomainMask
    ).first else {
      throw Failure.fileNotExist
    }
    return try load(from: url)
  }

  static func load<T: Decodable>(
    from directory: FileManager.SearchPathDirectory,
    fileName: String
  ) throws -> T {
    guard let url = FileManager.default.urls(
      for: directory,
      in: .userDomainMask
    ).first else {
      throw Failure.fileNotExist
    }
    return try load(from: url.appendingPathComponent(fileName))
  }

  static func load<T: Decodable>(from url: URL) throws -> T {
    let data = try load(from: url)
    return try decoder.decode(T.self, from: data)
  }

  static func load(from url: URL) throws -> Data {
    try Data(contentsOf: url)
  }
}
