//
//  WebViewController.swift
//  CACartoon
//
//  Created by Cary on 2019/8/7.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var request: URLRequest!
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        return webView
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackImage = UIImage.init(named: "nav_bg")
        progressView.progressTintColor = UIColor.white
        return progressView
    }()
    
    // 构造器
    convenience init(url: String?) {
        self.init()
        self.request = URLRequest(url: URL(string: url ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configNavigationBar()
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.load(request)  
    }
    
    private func setupLayout() {
        view.addSubview(webView)
        webView.snp.makeConstraints{ make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    private func configNavigationBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_reload"), style: .plain, target: self, action: #selector(reload))
        
        navigationItem.hidesBackButton = true
        let back =  UIBarButtonItem(image: UIImage(named: "nav_back_white"), style: .done, target:self, action: #selector(backFun))
        let close = UIBarButtonItem(image: UIImage(named: "nav_close"), style: .done, target:self, action: #selector(closeFun))
        navigationItem.leftBarButtonItems = [back,close]
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    @objc func reload() {
        webView.reload()
    }
    
    @objc func backFun() {
        
        if(webView.canGoBack == true){
            webView.goBack()
        }
        else {
            reload()
        }
    }
    
    @objc func closeFun() {
        
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

extension WebViewController: WKNavigationDelegate, WKUIDelegate {
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress >= 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        progressView.setProgress(0.0, animated: false)
        navigationItem.title = title ?? (webView.title ?? webView.url?.host)
    }
}
