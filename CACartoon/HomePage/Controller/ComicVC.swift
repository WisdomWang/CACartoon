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
    
    private let  xDetailOneCell = "DetailOneCell"
    private let  xDetailTwoCell = "DetailTwoCell"
     private let  xDetailThreeCell = "DetailThreeCell"

    private var comicid: Int = 0
    
    private lazy var navigationBarY: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    
    private lazy var headView: ComicHeadView = {
        return ComicHeadView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
    }()
    
    private lazy var footView:UIView = {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: xScreenWidth, height: 80))
        let footButton = UIButton()
        footButton.backgroundColor = UIColor.navColor
        footButton.setTitle("阅读第一话", for: .normal)
        footButton.setTitleColor(UIColor.white, for: .normal)
        footButton.layer.cornerRadius = 20
        footButton.layer.masksToBounds = true
        footButton.addTarget(self, action: #selector(gotoReadPage), for: .touchUpInside)
        headerView.addSubview(footButton)
        footButton.snp.makeConstraints{ make in
            
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(xScreenWidth-60)
        }
        return headerView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = self.headView
        return tableView
    }()
    
    private var detailStatic: LBUDetailStaticModel?
    private var detailRealtime: LBUDetailRealtimeModel?
    
    convenience init(comicid: Int) {
        self.init()
        self.comicid = comicid
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        edgesForExtendedLayout = .top
        setupLayout()
        loadData()
    }
    
    @objc func gotoReadPage (){
        
  
    let vc = ChapterReadVC(detailStatic: self.detailStatic, selectIndex: 0)
    self.navigationController?.pushViewController(vc, animated: true)
        
//        let alert = UIAlertController(title: "", message: "请选择", preferredStyle: .actionSheet)
//        let actionCancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
//        }
//        let actionRead = UIAlertAction(title: "从头阅读", style: .default) { (UIAlertAction) in
//
//            let vc = ChapterReadVC(detailStatic: self.detailStatic, selectIndex: 0)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        let actionChapter = UIAlertAction(title: "按章节阅读", style: .default) { (UIAlertAction) in
//            let vc = ChapterVC()
//            vc.detailStatic = self.detailStatic
//            vc.detailRealtime = self.detailRealtime
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        alert.addAction(actionCancel)
//        alert.addAction(actionRead)
//        alert.addAction(actionChapter)
//        alert.view.tintColor = UIColor(hex: "#333333")
//        self.present(alert, animated: true, completion: nil)
    }
    
    private func loadData() {
        
        let grpup = DispatchGroup()
        
        grpup.enter()
        ApiLoadingProvider.request(LBUApi.detailStatic(comicid: comicid),
                                   model: LBUDetailStaticModel.self) { [weak self] (detailStatic) in
                                    self?.detailStatic = detailStatic
                                    grpup.leave()
        }
        
        grpup.enter()
        ApiProvider.request(LBUApi.detailRealtime(comicid: comicid),
                            model: LBUDetailRealtimeModel.self) { [weak self] (returnData) in
                                self?.detailRealtime = returnData
                                grpup.leave()
        }
        
        grpup.notify(queue: DispatchQueue.main) {
      
            self.tableView .reloadData()
            self.headView.detailStatic = self.detailStatic?.comic
            self.headView.detailRealtime = self.detailRealtime?.comic
            self.navigationItem.title = self.detailStatic?.comic?.name
            self.tableView.tableFooterView = self.footView
        }
    }
    
    private func setupLayout(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
}

extension ComicVC:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard (self.detailStatic != nil) else {
            return 0
        }
        if section == 0 {
            return 2
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: xDetailOneCell)
                cell.textLabel?.text = "作品介绍"
                cell.detailTextLabel?.text = "【\(self.detailStatic?.comic?.cate_id ?? "")】\(self.detailStatic?.comic?.description ?? "")"
                cell.textLabel?.textColor = UIColor(hex: "#333333")
                cell.detailTextLabel?.numberOfLines = 0
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
                cell.detailTextLabel?.textColor = UIColor(hex: "#999999")
                cell.selectionStyle = .none
                return cell
                }
            else {
                let cell = UITableViewCell.init(style: .value1, reuseIdentifier: xDetailTwoCell)
                cell.textLabel?.text = "本月月票:\(self.detailRealtime?.comic?.total_ticket ?? "")"
                cell.detailTextLabel?.text = "累计月票:\(self.detailRealtime?.comic?.monthly_ticket ?? "")"
                cell.textLabel?.textColor = UIColor(hex: "#999999")
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell.detailTextLabel?.textColor = UIColor(hex: "#999999")
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
                cell.selectionStyle = .none
                return cell
            }
            }
        else if indexPath.section == 1 {
            let cell = UITableViewCell.init(style: .default, reuseIdentifier: xDetailThreeCell)
            cell.textLabel?.textColor = UIColor(hex: "#333333")
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "去目录"
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell = UITableViewCell.init(style: .default, reuseIdentifier: xDetailThreeCell)
            cell.textLabel?.textColor = UIColor(hex: "#333333")
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "去评论区"
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let vc = ChapterVC()
            vc.detailStatic = self.detailStatic
            vc.detailRealtime = self.detailRealtime
            vc.navigationItem.title = self.detailStatic?.comic?.name
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.section == 2 {
            
            let vc = CommentVC()
            vc.detailStatic = self.detailStatic
            vc.navigationItem.title = "评论"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
