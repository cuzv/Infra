import Foundation

@propertyWrapper
public struct FileStorage<Value: Codable> {
    private let directory: FileManager.SearchPathDirectory
    private let fileName: String
    private let defaultValue: () -> Value
    private var value: Value?
    private let queue = DispatchQueue(label: "FileStorage")

    public init(directory: FileManager.SearchPathDirectory, fileName: String, defaultValue: @autoclosure @escaping () -> Value) {
        self.directory = directory
        self.fileName = fileName
        self.defaultValue = defaultValue
        self.value = try? FileUtils.loadJSON(from: directory, fileName: fileName)
    }

    public var wrappedValue: Value {
        get { value ?? defaultValue() }
        set {
            value = newValue

            let directory = self.directory
            let fileName = self.fileName
            let json = newValue

            queue.async {
                try? FileUtils.writeJSON(json, to: directory, fileName: fileName)
            }
        }
    }

    public func reset() {
        try? FileUtils.delete(from: directory, fileName: fileName)
    }
}

private struct FileUtils {
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    fileprivate static func writeJSON<T: Encodable>(
        _ value: T,
        to directory: FileManager.SearchPathDirectory,
        fileName: String) throws {
        guard let url = FileManager.default.urls(for: directory, in: .userDomainMask).first else { return }
        try writeJSON(value, to: url.appendingPathComponent(fileName))
    }

    private static func writeJSON<T: Encodable>(_ value: T, to url: URL) throws {
        let data = try encoder.encode(value)
        try data.write(to: url)
    }

    fileprivate static func delete(from directory: FileManager.SearchPathDirectory, fileName: String) throws {
        guard let url = FileManager.default.urls(for: directory, in: .userDomainMask).first else { return }
        try FileManager.default.removeItem(at: url.appendingPathComponent(fileName))
    }

    fileprivate static func loadJSON<T: Decodable>(
        from directory: FileManager.SearchPathDirectory,
        fileName: String) throws -> T {
        guard let url = FileManager.default.urls(for: directory, in: .userDomainMask).first else {
            throw NSError(domain: "FileStorage", code: 1024, userInfo: nil)
        }
        return try loadJSON(from: url.appendingPathComponent(fileName))
    }

    private static func loadJSON<T: Decodable>(from url: URL) throws -> T {
        let data = try Data(contentsOf: url)
        return try decoder.decode(T.self, from: data)
    }
}
