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
let barH: CGFloat = isFullScreen ? 80.0:50.0  //是否是刘海屏的 tabBar 的高
let statusBarH :CGFloat = UIApplication.shared.statusBarFrame.size.height






