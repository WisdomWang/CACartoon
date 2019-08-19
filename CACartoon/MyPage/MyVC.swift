//
//  MyVC.swift
//  CACartoon
//
//  Created by Cary on 2019/7/31.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

class MyVC: UIViewController {

    private let headerViewH:CGFloat = xScreenWidth * 0.6
    private lazy var myArray: Array = {
        return [
                [
                 ["icon":"mine_author", "title": "关于"],
                 ["icon":"mine_setting", "title": "清除缓存"]
            ]
        ]
    }()
    
    private lazy var headerImage = UIImageView()
    
    lazy var headerView:UIView = {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: xScreenWidth, height:headerViewH))
        headerView.backgroundColor = UIColor.navColor
        headerImage = UIImageView(frame: headerView.bounds)
        headerImage.image = UIImage(named: "mine_bg_for_girl")
        headerImage.clipsToBounds = true
        headerImage.contentMode = .scaleAspectFill
        headerView.addSubview(headerImage)
        
        return headerView
        
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: xScreenWidth, height: xScreenHeight-barH), style: .plain)
        tableView.backgroundColor = UIColor.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        view.addSubview(headerView)
        tableView.tableHeaderView = headerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension MyVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArray = myArray[section]
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell")
            cell?.accessoryType = .disclosureIndicator
            cell?.selectionStyle = .none
            let sectionArray = myArray[indexPath.section]
            let dict: [String: String] = sectionArray[indexPath.row]
            cell?.imageView?.image =  UIImage(named: dict["icon"] ?? "")
            cell?.textLabel?.text = dict["title"]
            return cell!
        } else {
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "Mycell")
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            let sectionArray = myArray[indexPath.section]
            let dict: [String: String] = sectionArray[indexPath.row]
            cell.imageView?.image =  UIImage(named: dict["icon"] ?? "")
            cell.textLabel?.text = dict["title"]
            cell.detailTextLabel?.text = getCacheSize()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
        let vc = aboutVC()
        vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true) }
        else if indexPath.row == 1 {
            
                    let alert = UIAlertController(title: "您确定清除么", message: "", preferredStyle: .alert)
                    let actionCancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
                    }
                    let actionRead = UIAlertAction(title: "确认", style: .default) { (UIAlertAction) in
            
                        clearCache()
                        let cell = tableView.cellForRow(at: indexPath)
                        cell?.detailTextLabel?.text = getCacheSize()
                    }
                    alert.addAction(actionCancel)
                    alert.addAction(actionRead)
                    DispatchQueue.main.async { () -> Void in
                        self.present(alert, animated: true, completion: nil)
                    }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let imageHeight = self.headerView.frame.size.height
        let imageWidth = xScreenWidth
        let imageOffsetY = scrollView.contentOffset.y
        
        if imageOffsetY < 0 {
            let totalOffset = imageHeight + abs(imageOffsetY)
            let f = totalOffset/imageHeight
            headerImage.frame = CGRect(x: -(imageWidth * f - imageWidth) * 0.5, y: imageOffsetY, width: imageWidth * f, height: totalOffset)
        }
        if imageOffsetY > 0 {
            
            headerView.frame = CGRect(x: 0, y: 0, width: xScreenWidth, height:headerViewH)
        }
    }
}
