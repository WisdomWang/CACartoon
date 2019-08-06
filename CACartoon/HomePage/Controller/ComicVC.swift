//
//  ComicVC.swift
//  CACartoon
//
//  Created by Cary on 2019/8/6.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import Pageboy
import Tabman

class ComicVC: UIViewController {

    private var comicid: Int = 0
    
    private lazy var mainScrollView: UIScrollView = {
        let mainScrollView = UIScrollView()
       // mainScrollView.delegate = self
        return mainScrollView
    }()
    
    private lazy var navigationBarY: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    
    private lazy var pageVC:TabmanViewController = {
        let pageVC = TabmanViewController()
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        pageVC.addBar(bar, dataSource: self as! TMBarDataSource, at: .top)
        return pageVC
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
}
