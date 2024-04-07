import Foundation
import Network

@available(iOS 14.0, *)
public final class LocalNetworkAuthorization: NSObject {
  private var browser: NWBrowser?
  private var netService: NetService?
  private var completion: ((Bool) -> Void)?

  public func requestAuthorization(completion: @escaping (Bool) -> Void) {
    self.completion = completion

    // 创建参数，允许通过点对点链接进行浏览
    let parameters = NWParameters()
    parameters.includePeerToPeer = true

    // 浏览自定义服务类型
    let browser = NWBrowser(for: .bonjour(type: "_bonjour._tcp", domain: nil), using: parameters)
    self.browser = browser

    browser.stateUpdateHandler = { newState in
      switch newState {
      case let .failed(error):
        Log.out("\(error)")
      case .ready, .cancelled:
        break
      case let .waiting(error):
        Log.out("本地网络权限已被拒绝：\(error)")
        self.reset()
        self.completion?(false)
      default:
        break
      }
    }

    netService = NetService(domain: "local.", type: "_lnp._tcp.", name: "LocalNetworkPrivacy", port: 1100)
    netService?.delegate = self

    browser.start(queue: .main)
    netService?.publish()
  }

  private func reset() {
    browser?.cancel()
    browser = nil
    netService?.stop()
    netService = nil
  }
}

@available(iOS 14.0, *)
extension LocalNetworkAuthorization: NetServiceDelegate {
  public func netServiceDidPublish(_ sender: NetService) {
    self.reset()
    Log.out("本地网络权限已被授予")
    completion?(true)
  }
}
