

//
//  CommentVC.swift
//  CACartoon
//
//  Created by Cary on 2019/8/9.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

class CommentVC: UIViewController {
    
    private var listArray = [LBUCommentViewModel]()
    
    var detailStatic: LBUDetailStaticModel?
    var commentList: LBUCommentListModel? {
        didSet {
            guard let commentList = commentList?.commentList else { return }
            let viewModelArray = commentList.compactMap { (comment) -> LBUCommentViewModel? in
                return LBUCommentViewModel(model: comment)
            }
            listArray.append(contentsOf: viewModelArray)
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: CommentTVCell.self)
        tableView.tableFooterView = UIView()
        tableView.es.addInfiniteScrolling {
            self.loadData()
        }
        return tableView
        
    }()
    
    func loadData() {
        
        ApiLoadingProvider.request(LBUApi.commentList(object_id: detailStatic?.comic?.comic_id ?? 0,
                                               thread_id: detailStatic?.comic?.thread_id ?? 0,
                                               page: commentList?.serverNextPage ?? 0),
                            model: LBUCommentListModel.self) { (returnData) in
                                if returnData?.hasMore == true {
                                    self.tableView.es.stopLoadingMore()
                                } else {
                                    self.tableView.es.noticeNoMoreData()
                                }
                                self.commentList = returnData
                                self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.background
        setupLayout()
        loadData()
    }
    
    private func setupLayout(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
}

extension CommentVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listArray[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CommentTVCell.self)
        cell.viewModel = listArray[indexPath.row]
        return cell
    }
}
