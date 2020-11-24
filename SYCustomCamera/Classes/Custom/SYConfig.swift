//
//  Config.swift
//  SYTexDemo
//
//  Created by bsoshy on 2020/11/17.
//  Copyright © 2020 bsy. All rights reserved.
//

import Foundation

//屏幕宽度
let kScreenWidth = UIScreen.main.bounds.size.width
//屏幕高度
let kScreenHeight = UIScreen.main.bounds.size.height
// 导航栏高度
let kNavBarHeight: CGFloat = isIPhoneX ? 88.0 : 64.0
// TabBar高度
let kTabBarHeight: CGFloat = isIPhoneX ? 83.0 : 49.0
//状态栏高度
let kStatusBarHeight:CGFloat = isIPhoneX ? 44.0 : 20.0
/// iPhone 5
let isIPhone5 = kScreenHeight == 568 ? true : false
/// iPhone 6
let isIPhone6 = kScreenHeight == 667 ? true : false
/// iPhone 6P
let isIPhone6P = kScreenHeight == 736 ? true : false
/// iPhone X
let isIPhoneX = kScreenHeight >= 812 ? true : false

let kWindow = UIApplication.shared.keyWindow
