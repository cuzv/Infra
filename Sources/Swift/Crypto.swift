import CryptoKit
import Foundation

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension Data {
  enum HashAlgorithm {
    case sha256
    case sha384
    case sha512

    var hashFunction: any HashFunction.Type {
      switch self {
      case .sha256: SHA256.self
      case .sha384: SHA384.self
      case .sha512: SHA512.self
      }
    }
  }

  func hashing(using hashAlgorithm: HashAlgorithm) -> String {
    hashing(using: hashAlgorithm.hashFunction)
  }

  func hashing(using hashFunction: any HashFunction.Type) -> String {
    let digest = hashFunction.hash(data: self)
    let hashString = digest.compactMap { String(format: "%02x", $0) }.joined()
    return hashString
  }

  func sha256() -> String {
    hashing(using: SHA256.self)
  }

  func sha384() -> String {
    hashing(using: SHA384.self)
  }

  func sha512() -> String {
    hashing(using: SHA512.self)
  }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension HMAC {
  static func authenticate(message: String, key: String) -> String? {
    guard
      let keyData = key.data(using: .utf8),
      let messageData = message.data(using: .utf8)
    else {
      return nil
    }

    let hmac = authenticationCode(
      for: messageData,
      using: SymmetricKey(data: keyData)
    )
    return Data(hmac).map { String(format: "%02hhx", $0) }.joined()
  }
}
