//
//  OAuthViewController.swift
//  DS11WB
//
//  Created by xiaomage on 16/4/6.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    // MARK:- 控件的属性
    @IBOutlet weak var webView: UIWebView!
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置导航栏的内容
        setupNavigationBar()
        
        // 2.加载网页
        loadPage()
    }
    
}


// MARK:- 设置UI界面
extension OAuthViewController {
    private func setupNavigationBar() {
        // 1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(OAuthViewController.closeItemClick))
        
        // 2.设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .Plain, target: self, action: #selector(OAuthViewController.fillItemClick))
        
        // 3.设置标题
        title = "登录页面"
    }
    
    /**
     加载网页
     */
    private func loadPage() {
        // 1.获取登录页面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_URI)"
        
        // 2.创建对应NSURL
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        // 3.创建NSURLRequest对象
        let request = NSURLRequest(URL: url)
        
        // 4.加载request对象
        webView.loadRequest(request)
    }
}

// MARK:- 事件监听处理
extension OAuthViewController {
    @objc private func closeItemClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func fillItemClick() {
        // 1.书写js代码 : javascript / java --> 雷锋和雷峰塔
        let jsCode = "document.getElementById('userId').value='\(WB_APP_UserId)';document.getElementById('passwd').value='\(WB_APP_Passwd)';"
        
        // 2.执行js代码
        webView.stringByEvaluatingJavaScriptFromString(jsCode)

    }
}

// MARK: - UIWebView代理
extension OAuthViewController: UIWebViewDelegate
{
    /// webView开始加载网页
    func webViewDidStartLoad(webView: UIWebView) {
            SVProgressHUD.showInfoWithStatus("正在拼命加载网页...")
            SVProgressHUD.setDefaultMaskType(.Black)
    }
    
    /// webView网页加载完成
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
        
        
    }
    
    /// webView加载网页失败
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        SVProgressHUD.dismiss()
    }
    
    // 当准备加载某一个页面时,会执行该方法
    // 返回值: true -> 继续加载该页面 false -> 不会加载该页面
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        /*
         登录界面: https://api.weibo.com/oauth2/authorize?client_id=2550724916&redirect_uri=https://github.com/CoderSLZeng
         输入账号密码之后: https://api.weibo.com/oauth2/authorize
         取消授权: https://github.com/CoderSLZeng/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=
         授权:https://github.com/CoderSLZeng?code=63541580e8837a7f5ea054b59aea8c57
         通过观察
         1.如果是授权成功获取失败都会跳转到授权回调页面
         2.如果授权回调页面包含code=就代表授权成功, 需要截取code=后面字符串
         3.而且如果是授权回调页面不需要显示给用户看, 返回false
         */
        
        // 1.获取加载网页的NSURL
        guard let url = request.URL else {
            return true
        }
        
        // 2.获取url中的字符串
        let urlString = url.absoluteString
        
        
        // 3.判断该字符串中是否包含code
        guard urlString.containsString("code=") else {
            return true
        }
        
        // 4.将code截取出来
        let code = urlString.componentsSeparatedByString("code=").last!
        
        myLog(code)
        
        return false
    }    

}
