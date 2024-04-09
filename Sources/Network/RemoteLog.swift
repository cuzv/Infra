import Foundation

// MARK: - RemoteLogging

public protocol RemoteLogging {
  func screenview(_ view: RemoteLog.Screenview)
  func event(_ event: RemoteLog.Event)
  func action(_ action: RemoteLog.Action)
}

// MARK: - RemoteLog

public final class RemoteLog: RemoteLogging {
  private var providers: [any RemoteLogging]

  public init(
    providers: [any RemoteLogging] = []
  ) {
    self.providers = providers
  }

  public func register(provider: any RemoteLogging) {
    providers.append(provider)
  }

  public func screenview(_ view: Screenview) {
    providers.forEach { $0.screenview(view) }
  }

  public func event(_ event: Event) {
    providers.forEach { $0.event(event) }
  }

  public func action(_ action: Action) {
    providers.forEach { $0.action(action) }
  }
}

// MARK: - RemoteLog Subtypes

public extension RemoteLog {
  typealias Action = [String: Any]

  struct Event {
    public let name: String
    public let parameters: [String: Any]

    public init(
      name: String,
      parameters: [String: Any]
    ) {
      self.parameters = parameters
      self.name = name
    }
  }

  struct Screenview {
    public let name: String
    public let type: String

    public init(
      name: String,
      type: String
    ) {
      self.type = type
      self.name = name
    }
  }
}
