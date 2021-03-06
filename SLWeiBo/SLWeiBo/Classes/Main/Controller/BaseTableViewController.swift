//
//  BaseTableViewController.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/7.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    // MARK: - 懒加载属性
    /// 访客视图
    lazy var visitorView : VisitorView = VisitorView.visitorView()
    
    
    // MARK: - 自定义变量
    /// 定义标记记录用户登录状态
    var isLogin : Bool =  UserAccountViewModel.shareIntance.isLogin
    
    // MARK: - 系统回调函数
    
    override func loadView() {
        
        // 判断用户是否登录, 如果没有登录就显示访客界面, 如果已经登录就显示tableview
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
    }
}


// MARK: - 设置UI界面
extension BaseTableViewController {
    
    /**
     设置访客视图
     */
    fileprivate func setupVisitorView() {
        view = visitorView
        // 监听访客视图中`注册`和`登录`按钮的点击
        visitorView.registerBtn.addTarget(self, action: #selector(BaseTableViewController.registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseTableViewController.loginBtnClick), for: .touchUpInside)
    }
    
    /// 设置导航栏左右的Item
    fileprivate func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(BaseTableViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(BaseTableViewController.loginBtnClick))
    }
}


// MARK: - 监听事件处理
extension BaseTableViewController {
    /**
     点击注册按钮
     */
    @objc fileprivate func registerBtnClick() {
        myLog("registerBtnClick")
    }
    
    /**
     点击登录按钮
     */
    @objc fileprivate func loginBtnClick() {
        // 1.创建授权控制器
        let oauthVc = OAuthViewController()
        
        // 2.包装导航栏控制器
        let oauthNav = UINavigationController(rootViewController: oauthVc)
        
        // 3.弹出控制器
        present(oauthNav, animated: true, completion: nil)
    }
}

