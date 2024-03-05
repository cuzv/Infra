import Foundation
import Security

public class Keychain {
  public let service: String

  public init(service: String) {
    self.service = service
  }
}

public extension Keychain {
  subscript(key: String) -> Data? {
    get {
      let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: service,
        kSecAttrAccount as String: key,
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnData as String: true,
      ]

      var result: AnyObject?
      let status = SecItemCopyMatching(query as CFDictionary, &result)

      if status == errSecSuccess, let data = result as? Data {
        return data
      } else {
        return nil
      }
    }
    set(newValue) {
      if let newValue {
        let query: [String: Any] = [
          kSecClass as String: kSecClassGenericPassword,
          kSecAttrService as String: service,
          kSecAttrAccount as String: key,
        ]

        let attributes: [String: Any] = [
          kSecValueData as String: newValue,
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status == errSecItemNotFound {
          let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: newValue,
          ]

          let status = SecItemAdd(query as CFDictionary, nil)
          if status != errSecSuccess {
            print("Error adding to Keychain: \(status)")
          }
        } else if status != errSecSuccess {
          print("Error updating to Keychain: \(status)")
        }
      } else {
        let query: [String: Any] = [
          kSecClass as String: kSecClassGenericPassword,
          kSecAttrService as String: service,
          kSecAttrAccount as String: key,
        ]
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
          print("Error deleting to Keychain: \(status)")
        }
      }
    }
  }

  subscript(string key: String) -> String? {
    get {
      if let data: Data = self[key] {
        return String(data: data, encoding: .utf8)
      }
      return nil
    }
    set {
      self[key] = newValue?.data(using: .utf8)
    }
  }

  subscript(bool key: String) -> Bool? {
    get {
      self[key].flatMap { data in
        data.withUnsafeBytes {
          $0.load(as: Bool.self)
        }
      }
    }
    set {
      self[key] = newValue.flatMap { value in
        withUnsafeBytes(of: value) { Data($0) }
      }
    }
  }

  subscript(integer key: String) -> Int? {
    get {
      self[key].flatMap { data in
        data.withUnsafeBytes {
          $0.load(as: Int.self)
        }
      }
    }
    set {
      self[key] = newValue.flatMap { value in
        withUnsafeBytes(of: value) { Data($0) }
      }
    }
  }

  subscript(double key: String) -> Double? {
    get {
      self[key].flatMap { data in
        data.withUnsafeBytes {
          $0.load(as: Double.self)
        }
      }
    }
    set {
      self[key] = newValue.flatMap { value in
        withUnsafeBytes(of: value) { Data($0) }
      }
    }
  }
}
