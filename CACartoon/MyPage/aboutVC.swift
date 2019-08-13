//
//  aboutVC.swift
//  CACartoon
//
//  Created by Cary on 2019/8/13.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

class aboutVC: UIViewController {

    private lazy var textArr:Array = {
        return ["简书地址","GitHub地址","我的邮箱"]
    }()
    
    private lazy var detailTextArr:Array = {
        return ["https://www.jianshu.com/u/77851f4c0f5b","https://github.com/WisdomWang","294814110@qq.com"]
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: xScreenWidth, height: xScreenHeight), style: .plain)
        tableView.backgroundColor = UIColor.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AboutCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.background
        self.navigationItem.title = "关于"
        view.addSubview(tableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}

extension aboutVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return textArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "AboutCell")
        cell.textLabel?.text = textArr[indexPath.row]
        cell.detailTextLabel?.text = detailTextArr[indexPath.row]
        cell.textLabel?.textColor = UIColor(hex: "#333333")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.detailTextLabel?.textColor = UIColor(hex: "#999999")
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.selectionStyle = .none
        return cell
    }
    
    
    
}
