//
//  BookVC.swift
//  CACartoon
//
//  Created by Cary on 2019/7/31.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import ESPullToRefresh

class BookVC: UIViewController {
    
    private var page: Int = 1
    private var argCon: Int = 0
    private var specialList = [LBUComicModel]()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.background
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(cellType: SpecialTVCell.self)
        tableView.es.addPullToRefresh(animator: header) {
            self.loadData(more: false)
        }
        tableView.es.addInfiniteScrolling(animator: footer) {
            self.loadData(more: true)
        }
       
        return tableView
    }()
    
    convenience init(argCon: Int = 0) {
        self.init()
        self.argCon = argCon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "书架"
        setupLayout()
        loadData(more: false)
    }
    private func loadData(more: Bool) {
        page = (more ? ( page + 1) : 1)
        ApiLoadingProvider.request(LBUApi.special(argCon: 4, page: page), model: LBUComicListModel.self) { [weak self] (returnData) in
            
            self?.tableView.es.stopPullToRefresh()
            if returnData?.hasMore == false {
                self?.tableView.es.noticeNoMoreData()
            } else {
                self?.tableView.es.stopLoadingMore()
            }
            if !more { self?.specialList.removeAll() }
            self?.specialList.append(contentsOf: returnData?.comics ?? [])
            self?.tableView.reloadData()
            
            guard let defaultParameters = returnData?.defaultParameters else { return }
            self?.argCon = defaultParameters.defaultArgCon
        }
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}

extension BookVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specialList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SpecialTVCell.self)
        cell.model = specialList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = specialList[indexPath.row]
        var html: String?
        if item.specialType == 1 {
            html = "http://www.u17.com/z/zt/appspecial/special_comic_list_v3.html"
        } else if item.specialType == 2{
            html = "http://www.u17.com/z/zt/appspecial/special_comic_list_new.html"
        }
        guard let host = html else { return }
        let path = "special_id=\(item.specialId)&is_comment=\(item.isComment)"
        let url = [host, path].joined(separator: "?")
        print(url)
        let vc = WebViewController(url: url)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

