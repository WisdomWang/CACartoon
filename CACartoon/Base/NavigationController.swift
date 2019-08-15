//
//  NavigationController.swift
//  CACartoon
//
//  Created by Cary on 2019/8/15.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import Foundation

// 定义一个protocol，实现它的类，自定义pop规则、逻辑或方法
protocol NavigationControllerBackButtonDelegate {
    func shouldPopOnBackButtonPress() -> Bool
}

class NavigationController: UINavigationController,UINavigationBarDelegate{

    // 实现navigationBar(_: shouldPop:)
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        var shouldPop = true
        
        // 已修改（标记1）
        let viewControllersCount = self.viewControllers.count
        let navigationItemsCount = navigationBar.items?.count
        
        if(viewControllersCount < navigationItemsCount!){
            return shouldPop
        }
        if let topViewController: UIViewController = self.topViewController {
            if(topViewController is NavigationControllerBackButtonDelegate){
                let delegate = topViewController as! NavigationControllerBackButtonDelegate
                shouldPop = delegate.shouldPopOnBackButtonPress()
            }
        }
        if(shouldPop == false){
            isNavigationBarHidden = true
            isNavigationBarHidden = false
        }else{
            if(viewControllersCount >= navigationItemsCount!){
                DispatchQueue.main.async { () -> Void in
                    self.popViewController(animated: true)
                }
            }
        }
        return shouldPop
    }
}
