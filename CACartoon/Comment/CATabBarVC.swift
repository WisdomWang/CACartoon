//
//  CATabBarVC.swift
//  CACartoon
//
//  Created by Cary on 2019/7/31.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

class CATabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabBar.isTranslucent = false
        setupLayout()
    }
    
    func setupLayout () {
        
        let homeVC = HomeVC()
        addChildController(childController: homeVC,
                           title: "首页",
                           image: UIImage(named: "tab_home"),
                           selectedImage: UIImage(named: "tab_home_S"))
        
        let KindVC = KindVC()
        addChildController(childController: KindVC,
                           title: "首页",
                           image: UIImage(named: "tab_home"),
                           selectedImage: UIImage(named: "tab_home_S"))
        
        let homeVC = HomeVC()
        addChildController(childController: homeVC,
                           title: "首页",
                           image: UIImage(named: "tab_home"),
                           selectedImage: UIImage(named: "tab_home_S"))
        
        let homeVC = HomeVC()
        addChildController(childController: homeVC,
                           title: "首页",
                           image: UIImage(named: "tab_home"),
                           selectedImage: UIImage(named: "tab_home_S"))
        
        
    }
    
    func addChildController(childController:UIViewController,title:String?,image:UIImage?,selectedImage:UIImage?){
        childController.title = title;
        childController.tabBarItem = UITabBarItem(title: nil, image: image?.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
