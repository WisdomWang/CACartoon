//
//  SystemCommon.swift
//  CACartoon
//
//  Created by Cary on 2019/7/31.
//  Copyright © 2019 Cary. All rights reserved.
//

import Foundation
import UIKit
import PKHUD
import Kingfisher
import ESPullToRefresh

let xScreenWidth = UIScreen.main.bounds.size.width
let xScreenHeight = UIScreen.main.bounds.size.height

//是否刘海儿屏
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
let statusBarH :CGFloat = UIApplication.shared.statusBarFrame.size.height  //状态栏高度
let bottomSafeH:CGFloat = isFullScreen ? 34.0:0.0   //底部安全区域高度

extension UIColor{
    
    //View背景色
    class var background: UIColor {
        return UIColor(hex: "#f8f8f8")
    }
    
    //导航栏背景色
    class var navColor: UIColor {
        return UIColor(hex: "#68DA96")
       // return UIColor(hex: "#A2CC70")
    }    
}

//顶部视图
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

//获取缓存大小
public func getCacheSize() -> String {
    //cache文件夹
    let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    //文件夹下所有文件
    let files = FileManager.default.subpaths(atPath: cachePath!)!
    //遍历计算大小
    var size = 0
    for file in files {
        //文件名拼接到路径中
        let path = cachePath! + "/\(file)"
        //取出文件属性
        do {
            let floder = try FileManager.default.attributesOfItem(atPath: path)
            for (key, fileSize) in floder {
                //累加
                if key == FileAttributeKey.size {
                    size += (fileSize as AnyObject).integerValue
                }
            }
        } catch {
            print("出错了！")
        }
        
    }
    
    let totalSize = Double(size) / 1024.0 / 1024.0
    return String(format: "%.1fM", totalSize)
}

//删除缓存
 public func clearCache() {
    
    PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width:100.0, height: 100.0)))
    PKHUD.sharedHUD.dimsBackground = true
    PKHUD.sharedHUD.show()
    
    //cache文件夹
    let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    //文件夹下所有文件
    let files = FileManager.default.subpaths(atPath: cachePath!)!
    
    //遍历删除
    for file in files {
        //文件名
        let path = cachePath! + "/\(file)"
        //存在就删除
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                print("出错了！")
            }
        }
    }
    
    KingfisherManager.shared.cache.clearDiskCache {
        
         PKHUD.sharedHUD.hide(animated: true)
    }
}


 //下拉 上拉刷新
public var header: ESRefreshHeaderAnimator {
    get {
        let h = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        h.pullToRefreshDescription = "下拉刷新"
        h.releaseToRefreshDescription = "松开获取最新数据"
        h.loadingDescription = "下拉刷新..."
        return h
    }
}
public var footer: ESRefreshFooterAnimator {
    get {
        let f = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        f.loadingMoreDescription = "上拉加载更多"
        f.noMoreDataDescription = "数据已加载完"
        f.loadingDescription = "加载更多..."
        return f
    }
}
