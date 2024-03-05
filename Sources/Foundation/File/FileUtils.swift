import Foundation

public enum FileUtils {
  enum Failure: Error {
    case fileNotExist
  }

  private static let decoder: JSONDecoder = .init()
  private static let encoder: JSONEncoder = .init()

  public static func writeJSON(
    _ value: some Encodable,
    to directory: FileManager.SearchPathDirectory,
    fileName: String
  ) throws {
    guard let url = FileManager.default.urls(
      for: directory, in: .userDomainMask
    ).first else { return }
    try writeJSON(value, to: url.appendingPathComponent(fileName))
  }

  public static func writeJSON(_ value: some Encodable, to url: URL) throws {
    let data = try encoder.encode(value)
    try data.write(to: url)
  }

  public static func delete(
    from directory: FileManager.SearchPathDirectory,
    fileName: String
  ) throws {
    guard let url = FileManager.default.urls(
      for: directory,
      in: .userDomainMask
    ).first else { return }
    try FileManager.default.removeItem(at: url.appendingPathComponent(fileName))
  }

  public static func loadJSON<T: Decodable>(
    from directory: FileManager.SearchPathDirectory,
    fileName: String
  ) throws -> T {
    guard let url = FileManager.default.urls(
      for: directory,
      in: .userDomainMask
    ).first else {
      throw Failure.fileNotExist
    }
    return try loadJSON(from: url.appendingPathComponent(fileName))
  }

  public static func loadJSON<T: Decodable>(from url: URL) throws -> T {
    let data = try Data(contentsOf: url)
    return try decoder.decode(T.self, from: data)
  }
}
