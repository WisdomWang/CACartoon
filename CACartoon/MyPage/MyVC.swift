//
//  MyVC.swift
//  CACartoon
//
//  Created by Cary on 2019/7/31.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

class MyVC: UIViewController {

    private lazy var myArray: Array = {
        return [[["icon":"mine_vip", "title": "我的VIP"],
                 ["icon":"mine_coin", "title": "充值妖气币"]],
                
                [["icon":"mine_accout", "title": "消费记录"],
                 ["icon":"mine_subscript", "title": "我的订阅"],
                 ["icon":"mine_seal", "title": "我的封印图"]],
                
                [["icon":"mine_message", "title": "我的消息/优惠券"],
                 ["icon":"mine_cashew", "title": "妖果商城"],
                 ["icon":"mine_freed", "title": "在线阅读免流量"]],
                
                [["icon":"mine_feedBack", "title": "帮助中心"],
                 ["icon":"mine_mail", "title": "我要反馈"],
                 ["icon":"mine_judge", "title": "给我们评分"],
                 ["icon":"mine_author", "title": "成为作者"],
                 ["icon":"mine_setting", "title": "设置"]]]
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "我的"
        setupLayout()

    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).offset(barH)
        }
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell")
        cell?.accessoryType = .disclosureIndicator
        cell?.selectionStyle = .none
        let sectionArray = myArray[indexPath.section]
        let dict: [String: String] = sectionArray[indexPath.row]
        cell?.imageView?.image =  UIImage(named: dict["icon"] ?? "")
        cell?.textLabel?.text = dict["title"]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
