//
//  MTWebView.swift
//  MultiPay
//
//

import UIKit
import WebKit

protocol MTWebViewDelegate {
    func mtWebViewEmptyParameters()
    func mtWebViewNavigated(to url: String)
    func mtWebViewDidStartLoad()
}

class MTWebView: UIView {

    var delegate: MTWebViewDelegate?

    var activityIndicator: UIActivityIndicatorView!

    private var htmlString: String?
    private var urlString: String?

    func initWebView() {
        if #available(iOS 11.0, *) {
            let wkWebView = WKWebView()
            wkWebView.translatesAutoresizingMaskIntoConstraints = false

            wkWebView.navigationDelegate = self
            wkWebView.isOpaque = false
            wkWebView.backgroundColor = ColorPalette.webVC.webViewBackgroundColor

            self.addSubview(wkWebView)

            wkWebView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            wkWebView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            wkWebView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            wkWebView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

            self.initActivityIndicator()

            if self.urlString != nil,
                let url = URL(string: self.urlString!) {
                wkWebView.load(URLRequest(url: url))
                self.delegate?.mtWebViewDidStartLoad()
            } else if self.htmlString != nil {
                wkWebView.loadHTMLString(self.htmlString!, baseURL: nil)
                self.delegate?.mtWebViewDidStartLoad()
            } else {
                self.delegate?.mtWebViewEmptyParameters()
            }
        } else {
            let webView = UIWebView()
            webView.translatesAutoresizingMaskIntoConstraints = false

            webView.delegate = self
            webView.isOpaque = false
            webView.backgroundColor = ColorPalette.webVC.webViewBackgroundColor

            self.addSubview(webView)

            webView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            webView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            webView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

            self.initActivityIndicator()

            if self.urlString != nil,
                let url = URL(string: self.urlString!) {
                webView.loadRequest(URLRequest(url: url))
                self.delegate?.mtWebViewDidStartLoad()
            } else if self.htmlString != nil {
                webView.loadHTMLString(self.htmlString!, baseURL: nil)
                self.delegate?.mtWebViewDidStartLoad()
            } else {
                self.delegate?.mtWebViewEmptyParameters()
            }
        }
    }

    func initActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView()
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.color = ColorPalette.webVC.activityIndicatorColor

        self.addSubview(self.activityIndicator)

        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        self.activityIndicator.startAnimating()
    }

    func loadHtml(html: String) {
        self.htmlString = html
        self.initWebView()
    }

    func loadUrl(url: String) {
        self.urlString = url
        self.initWebView()
    }

}

extension MTWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse {
            if response.statusCode == 200, let url = response.url?.absoluteString {
                self.delegate?.mtWebViewNavigated(to: url)
            }
        }

        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityIndicator.stopAnimating()
    }
}

extension MTWebView: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.activityIndicator.stopAnimating()

        if let url = webView.request?.url {
            self.delegate?.mtWebViewNavigated(to: url.absoluteString)
        }
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.activityIndicator.stopAnimating()
    }
}
