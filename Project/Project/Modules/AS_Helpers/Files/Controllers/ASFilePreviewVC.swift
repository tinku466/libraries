//
//  ASFilePreviewVC.swift
//  ABBC
//
//  Created by Mr. X on 28/04/21.
//

import UIKit
import WebKit

/// Controller used to preview the files with url
class ASFilePreviewVC: ASBaseVC {
    /// Controller entry type
    ///
    /// - push: push into navigation
    /// - present: present on navigation
    enum StackType {
        case push
        case present
    }
    
    
    /// Url to preview
    var fileUrl: URL?
    
    /// Controller Entry type
    var entryType: StackType = .push
    
    /// Web View
    private lazy var webView: WKWebView = {
        let web = WKWebView()
        return web
    }()
    
    //MARK:- VIEW CYCLE
    
    /// Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        navBarButtons(left: #imageLiteral(resourceName: "nav_back"), right: nil, shouldBack: false)
        ///
        setupUI()
        ///
        kMainQueue.asyncAfter(deadline: .now() + 0.2) {[weak self] in
            self?.loadRequest()
        }
    }
    
    //MARK:- De-Init
    
    deinit {
        print("deinit ASFilePreviewVC")
        releaseMemory()
    }
    
    /// Release all memory of web view
    private func releaseMemory() {
        kAppDelegate.hideLoader()
        webView.stopLoading()
        webView.removeFromSuperview()
    }
    
    //MARK:- SETUP
    
    /// Setup the UI
    private func setupUI() {
        webView = WKWebView()
        self.view.addSubview(webView)
        webView.anchorAllEdgesToSuperview()
    }

    /// load url
    private func loadRequest() {
        weak var weakSelf = self
        
        guard let url = fileUrl else { return }
        let request = URLRequest.init(url: url)
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.109 Safari/537.36"
        webView.navigationDelegate = weakSelf
        webView.load(request)
        
        kAppDelegate.showLoader(interaction: true)
    }
    
    //MARK:- ACTIONs
    /// Left button clicked
    override func navLeftClicked(sender: UIButton) {
        releaseMemory()
        if entryType == .present {
            self.dismiss(animated: true, completion: nil)
        } else {
            goBack()
        }
    }
}

// MARK: - WKNavigationDelegate
extension ASFilePreviewVC: WKNavigationDelegate {
    /// Decides whether to allow or cancel a navigation.
    ///
    /// - Parameters:
    ///   - webView: The web view invoking the delegate method
    ///   - navigationAction: Descriptive information about the action triggering the navigation request.
    ///   - decisionHandler: The decision handler to call to allow or cancel the navigation. The argument is one of the constants of the enumerated type WKNavigationActionPolicy.
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("Should start load with : \(navigationAction.request.url?.absoluteString ?? "")")
        
        kAppDelegate.showLoader(interaction: true)
        decisionHandler(.allow)
    }
    
    /// Invoked when a main frame navigation starts.
    ///
    /// - Parameters:
    ///   - webView: webView The web view invoking the delegate method.
    ///   - navigation: The navigation.
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("did start load")
        kAppDelegate.showLoader(with: "", interaction: true)
    }
    
    /// Invoked when a main frame navigation completes.
    ///
    /// - Parameters:
    ///   - webView: The web view invoking the delegate method.
    ///   - navigation: The navigation.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("did Finish")
        kAppDelegate.hideLoader()
    }
    
    /// Invoked when an error occurs during a committed main frame navigation.
    ///
    /// - Parameters:
    ///   - webView: The web view invoking the delegate method.
    ///   - navigation: The navigation.
    ///   - error: The error that occurred.
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail: \(error.localizedDescription)")
        kAppDelegate.hideLoader()
    }
}
