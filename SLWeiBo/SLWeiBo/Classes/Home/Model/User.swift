//
//  User.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/14.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class User: NSObject {
    // MARK:- 属性
    /// 用户的头像
    var profile_image_url : String?
    /// 用户的昵称
    var screen_name : String?
    /// 用户的认证类型
    var verified_type : Int = -1
    /// 用户的会员等级
    var mbrank : Int = 0
    
    // MARK:- 自定义构造函数
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
