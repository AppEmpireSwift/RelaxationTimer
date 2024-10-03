import Foundation
import UIKit
import MessageUI

class SettingsViewModel: NSObject, ObservableObject, MFMailComposeViewControllerDelegate {
    
    let email = ""
    let appID = ""
    
    func sendEmail() {
        guard let url = URL(string: "mailto:\(email)") else { return }
        UIApplication.shared.open(url)
    }
    
    func rateApp() {
        guard let url = URL(string: "itms-apps://apple.com/app/id\(appID)") else { return }
        UIApplication.shared.open(url)
    }
    
    func shareApp() {
        let items = ["Check out this amazing app!"]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let rootViewController = UIApplication.shared.getKeyWindow()?.rootViewController {
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}

extension UIApplication {
    func getKeyWindow() -> UIWindow? {
        return self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }.first
    }
}
