import Combine
import Foundation
import Network

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public final class NetworkMonitor: ObservableObject {
  public static let shared = NetworkMonitor()

  @Published
  public private(set) var isConnected: Bool

  @Published
  private var status: NWPath.Status
  private let networkMonitor = NWPathMonitor()
  private let workerQueue = DispatchQueue(label: "Monitor")
  private var bags = [AnyCancellable]()

  private init() {
    let currentStatus = networkMonitor.currentPath.status
    status = currentStatus
    isConnected = currentStatus.isConnected

    networkMonitor.pathUpdateHandler = { path in
      self.status = path.status
    }
    networkMonitor.start(queue: workerQueue)

    $status
      .map(\.isConnected)
      .removeDuplicates()
      .assignWeakSafely(to: \.isConnected, on: self)
      .store(in: &bags)
  }
}

extension NWPath.Status {
  var isConnected: Bool {
    self == .satisfied
  }
}
