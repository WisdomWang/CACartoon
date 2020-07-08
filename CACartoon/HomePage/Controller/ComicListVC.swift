//
//  ComicListVC.swift
//  CACartoon
//
//  Created by Cary on 2019/8/1.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import ESPullToRefresh

class ComicListVC: UIViewController {
    
    private var argCon: Int = 0
    private var argName: String?
    private var argValue: Int = 0
    private var page: Int = 1
    private var comicList = [LBUComicModel]()
    private var spinnerName: String?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.background
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: ComicTVCell.self)
        tableView.es.addPullToRefresh(animator: header) {
            self.loadData(more: false)
        }
        tableView.es.addInfiniteScrolling(animator: footer) {
            self.loadData(more: true)
        }
        tableView.uempty = UEmptyView { [weak self] in self?.loadData(more: false) }
        return tableView
    }()
    
    convenience init(argCon: Int = 0, argName: String?, argValue: Int = 0) {
        self.init()
        self.argCon = argCon
        self.argName = argName
        self.argValue = argValue
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupLayout()
        loadData(more: false)
    }
    private func loadData(more: Bool) {
        page = (more ? ( page + 1) : 1)
        ApiLoadingProvider.request(LBUApi.comicList(argCon: argCon, argName: argName ?? "", argValue: argValue, page: page),
                                   model: LBUComicListModel.self) { [weak self] (returnData) in
                                    self?.tableView.es.stopPullToRefresh()
                                    if returnData?.hasMore == false {
                                        self?.tableView.es.noticeNoMoreData()
                                    } else {
                                        self?.tableView.es.stopLoadingMore()
                                    }
                                    
                                    self?.tableView.uempty?.allowShow = true
                                    
                                    if !more { self?.comicList.removeAll() }
                                    self?.comicList.append(contentsOf: returnData?.comics ?? [])
                                    self?.tableView.reloadData()
                                    
                                    
                                    guard let defaultParameters = returnData?.defaultParameters else { return }
                                    self?.argCon = defaultParameters.defaultArgCon
                                    self?.spinnerName = defaultParameters.defaultConTagType
        }
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
}

extension ComicListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicTVCell.self)
        cell.spinnerName = spinnerName
        cell.indexPath = indexPath
        cell.model = comicList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = comicList[indexPath.row]
        let vc = ComicVC(comicid: model.comicId)
        navigationController?.pushViewController(vc, animated: true)
    }
}

