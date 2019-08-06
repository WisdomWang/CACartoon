//
//  SystemCommon.swift
//  CACartoon
//
//  Created by Cary on 2019/7/31.
//  Copyright © 2019 Cary. All rights reserved.
//

import Foundation
import UIKit

let xScreenWidth = UIScreen.main.bounds.size.width
let xScreenHeight = UIScreen.main.bounds.size.height

var isFullScreen: Bool {
    if #available(iOS 11, *) {
        guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
            return false
        }
        
        if unwrapedWindow.safeAreaInsets.bottom > 0 {
            print(unwrapedWindow.safeAreaInsets)
            return true
        }
    }
    return false
}

let navH: CGFloat = isFullScreen ? 88.0:64.0  //是否是刘海屏的导航高
let barH: CGFloat = isFullScreen ? 83.0:49.0  //是否是刘海屏的 tabBar 的高
let statusBarH :CGFloat = UIApplication.shared.statusBarFrame.size.height
let bottomSafeH:CGFloat = isFullScreen ? 34.0:0.0   //底部安全区域高度


extension UIColor{
    
    class var background: UIColor {
        return UIColor(hex: "#f8f8f8")
    }
    class var navColor: UIColor {
        return UIColor(hex: "#68DA96")
    }
}

var topVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC = _topVC(UIApplication.shared.keyWindow?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)
    }
    return resultVC
}

private  func _topVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        return _topVC((vc as? UINavigationController)?.topViewController)
    } else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)
    } else {
        return vc
    }
}








