import Foundation

@propertyWrapper
public struct FileStorage<Value: Codable> {
    private let directory: FileManager.SearchPathDirectory
    private let fileName: String
    private var value: Value?

    public init(directory: FileManager.SearchPathDirectory, fileName: String) {
        self.directory = directory
        self.fileName = fileName
        self.value = try? FileUtils.loadJSON(from: directory, fileName: fileName)
    }

    public var wrappedValue: Value? {
        get { value }
        set {
            value = newValue

            let directory = self.directory
            let fileName = self.fileName

            DispatchQueue.fileStorage.async {
                if let value = newValue {
                    try? FileUtils.writeJSON(value, to: directory, fileName: fileName)
                } else {
                    try? FileUtils.delete(from: directory, fileName: fileName)
                }
            }
        }
    }
}

fileprivate extension DispatchQueue {
    static let fileStorage = DispatchQueue(label: "com.redrainlab.FileStorage")
}
