//
//  HomeMainVC.swift
//  CACartoon
//
//  Created by Cary on 2019/8/5.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import Pageboy
import Tabman

class HomeMainVC: TabmanViewController {
    
    private var viewControllers = [HomeCommentVC(),HomeVIPVC(),HomeSubscibeVC(),HomeRankVC()]
    private var  titles = ["推荐","VIP","订阅","排行"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        
        self.dataSource = self
        let bar = TMBar.ButtonBar()
        bar.backgroundColor = UIColor.navColor
        bar.layout.interButtonSpacing = 30
        bar.indicator.weight = .medium
        bar.indicator.backgroundColor = UIColor.white
        bar.indicator.cornerStyle = .eliptical
        bar.fadesContentEdges = true
        bar.spacing = 16.0
        bar.backgroundView.style = .clear
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        bar.buttons.customize { (button) in
            button.tintColor = UIColor.white
            button.selectedTintColor = UIColor.white
        }
        
        let searchBtn = UIButton()
        searchBtn.setImage(UIImage(named: "nav_search"), for: .normal)
        searchBtn.addTarget(self, action: #selector(gotoSeatchView), for: .touchUpInside)
        
        bar.layout.transitionStyle = .snap
        addBar(bar, dataSource: self, at: .navigationItem(item: navigationItem))
        
        bar.addSubview(searchBtn)
        searchBtn.snp.makeConstraints { make in
            
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal:-200,vertical:0), for: .default)
    }
    
    @objc func gotoSeatchView () {
        
        let vc = SearchVC()
        vc.hidesBottomBarWhenPushed = true
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .moveIn
        transition.subtype = .fromTop
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(vc, animated: false)
    }
}

extension HomeMainVC: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = titles[index]
        return TMBarItem(title: title)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

}
