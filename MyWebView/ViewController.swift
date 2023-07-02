//
//  ViewController.swift
//  MyWebView
//
//  Created by Ritik Sharma on 02/01/23.
//

import UIKit
import WebKit
class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {

    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfig = WKWebViewConfiguration()
        webConfig.allowsInlineMediaPlayback = true
        webConfig.allowsAirPlayForMediaPlayback = true
        webConfig.allowsPictureInPictureMediaPlayback = true
        webConfig.mediaTypesRequiringUserActionForPlayback = []
        

        webView.configuration.userContentController.add(self, name: "getAppVersion")
        webView.configuration.userContentController.add(self, name: "navigateTo")
        guard let indexJsUrl = Bundle.main.url(forResource: "index", withExtension: "js") else { return }
        do{
            let script = WKUserScript(source: try String.init(contentsOf: indexJsUrl), injectionTime: .atDocumentStart, forMainFrameOnly: true)
            webView.configuration.userContentController.addUserScript(script)
        }
        catch{
            print("Script not found")
        }
        title = "Webview"
        webView.backgroundColor = .clear
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        
        webView.translatesAutoresizingMaskIntoConstraints=false
//        webView.addTopConstraint(with: 0.0, toView: webContainerView)
//        webView.addBottomConstraint(with: 0.0, toView: webContainerView)
//        webView.addLeadingConstraint(with: 0.0, toView: webContainerView)
//        webView.addTrailingConstraint(with: 0.0, toView: webContainerView)
        
        
        guard let indexHtmlUrl = Bundle.main.url(forResource: "index", withExtension: "html") else { return }
        
        do{
            print(try String.init(contentsOf: indexHtmlUrl))
        }
        catch{
            print("File not found")
        }
//        let url = URL(string:"https://github.com/nohana/NohanaImagePicker")
//        webView.load(URLRequest(url: url!))
        webView.loadFileURL(indexHtmlUrl, allowingReadAccessTo: indexHtmlUrl.deletingLastPathComponent())
        
    }
    private func openSettingsPage(){
        print(UIApplication.openSettingsURLString)
        if let url = URL(string: UIApplication.openSettingsURLString){
            UIApplication.shared.open(url)
            print("Opened path  \(url)")
        }
//        do{
//            try
//        }
//        catch{
//            print("Opening path \(UIApplication.openSettingsURLString)")
//            if let url = URL(string:UIApplication.openSettingsURLString) {
//                 if UIApplication.shared.canOpenURL(url) {
//                     print(url)
//                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                 }
//              }
//        }
    }
    func getAppVersion(body: Any) -> String{
        return "171.22.34.909:9998"
    }
    func callJavaScriptFunctions(withName name: String, body: Any){
        switch name{
        case "navigateTo":
            openSettingsPage()
        default:
            break
        }
    }
}

extension ViewController:WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        callJavaScriptFunctions(withName: message.name, body: message.body)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Web page  loaded")
    }
    
    
}
//extension ViewController:WKScriptMessageHandlerWithReply{
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) async -> (Any?, String?) {
//        print(message.name)
//        print(message.body)
//        print(callJavaScriptFunctions(withName: message.name, body: message.body))
//    }
//
//
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage, replyHandler: @escaping (String) -> Void) {
//        print(message.name)
//        print(message.body)
//        callJavaScriptFunctions(withName: message.name, body: message.body)
//        replyHandler(callJavaScriptFunctions(withName: message.name, body: message.body))
//
//    }
//
//
//
//
//}

