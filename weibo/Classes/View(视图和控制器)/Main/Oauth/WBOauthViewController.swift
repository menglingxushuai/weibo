//
//  WBOauthViewController.swift
//  weibo
//
//  Created by 孟令旭 on 2018/10/18.
//  Copyright © 2018年 xiaotong. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 通过webView 加载新浪微博授权页面控制器
class WBOauthViewController: UIViewController {

    private lazy var webView = UIWebView()

    override func loadView() {
        view = webView
        webView.delegate = self
        webView.scrollView.isScrollEnabled = false
        view.backgroundColor = UIColor.white
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", target: self, action: #selector(close), isBack: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "自动填充", target: self, action: #selector(autoFill))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        
        webView.loadRequest(URLRequest(url: URL(string: urlStr)!))
    }
    
    // MARK : - 监听
    @objc private func close() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func autoFill() {
        let js = "document.getElementById('userId').value = '778683342@qq.com';" + "document.getElementById('passwd').value = 'mlx123';"
        webView.stringByEvaluatingJavaScript(from: js)

    }
    
}

// MARK : - UIWebViewDelegate
extension WBOauthViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let requestUrlStr = request.url?.absoluteString
        
        if requestUrlStr?.hasPrefix(WBRedirectURI) == false {
            return true
        }
        // query就是url中？后面的参数部分
        var queryStr = request.url?.query ?? ""
        if queryStr.hasPrefix("code") == false {
            close()
            return false
        }
        print("queryStr==\(queryStr)")
        queryStr = String(queryStr.suffix(from: "code=".endIndex))
        print("queryStr==\(queryStr)")
        
        WBNetworkManager.shared.loadAccessToken(code: queryStr) { (isSuccess) in
            
            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginSuccessNotificaiton), object: nil)
            }
            self.close()
        }
        return true
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
}
