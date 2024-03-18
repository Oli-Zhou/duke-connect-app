//
//  WebPageLoader.swift
//  DukeEventCalendar
//
//  Created by Fall2023 on 11/7/23.
//

import Foundation
import WebKit

class WebPageLoader: NSObject, WKNavigationDelegate {
    private var webView: WKWebView?
    private var selectElementID: String? // Save the select element ID
    private var optionsCompletion: (([String]?, Error?) -> Void)?

    override init() {
        super.init()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.navigationDelegate = self
    }
    
    func loadOptions(from url: URL, selectElementID id: String, completion: @escaping ([String]?, Error?) -> Void) {
        self.selectElementID = id // Save the ID to the property
        self.optionsCompletion = completion
        let request = URLRequest(url: url)
        webView?.load(request)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let selectElementID = selectElementID else {
            print("Select element ID not set.")
            return
        }
        
        // JavaScript to get all options from the select element with the specified ID
        let javascript = "Array.from(document.querySelectorAll('#\(selectElementID) option')).map(option => option.value);"
        
        webView.evaluateJavaScript(javascript) { [weak self] (result, error) in
            guard let strongSelf = self else { return }

            if let error = error {
                strongSelf.optionsCompletion?(nil, error)
            } else if let options = result as? [String] {
                strongSelf.optionsCompletion?(options, nil)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.optionsCompletion?(nil, error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.optionsCompletion?(nil, error)
    }
    
    // If your web view is intended to support redirects, you may also want to handle this method
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        // Handle if needed
    }
    
    // Handle the situation where web content starts to load, but the process is terminated
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        // Call the completion handler with an error or do any other necessary cleanup
        let error = NSError(domain: "WebContentProcessTerminated", code: -1, userInfo: nil)
        self.optionsCompletion?(nil, error)
    }
}
