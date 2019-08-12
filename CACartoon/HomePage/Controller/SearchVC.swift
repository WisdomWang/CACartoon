
//
//  SearchVC.swift
//  CACartoon
//
//  Created by Cary on 2019/8/12.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import Moya



class SearchVC: UIViewController {

    private var currentRequest: Cancellable?
    private var hotItems: [LBUSearchItemModel]?
    private var relative: [LBUSearchItemModel]?
    private var comics: [LBUComicModel]?
    
    
    private  lazy var searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.backgroundColor = UIColor.white
        searchBar.textColor = UIColor.gray
        searchBar.tintColor = UIColor.darkGray
        searchBar.font = UIFont.systemFont(ofSize: 15)
        searchBar.placeholder = "输入漫画名称/作者"
        searchBar.layer.cornerRadius = 15
        searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        searchBar.leftViewMode = .always
        searchBar.clearsOnBeginEditing = true
        searchBar.clearButtonMode = .whileEditing
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFiledTextDidChange(noti:)), name: UITextField.textDidChangeNotification, object: searchBar)
        return searchBar
    }()
    
    lazy var searchTableView: UITableView = {
        let searchTableView = UITableView(frame: CGRect.zero, style: .plain)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(cellType: BaseTableViewCell.self)
        //searchTableView.tableFooterView = UIView()
        return searchTableView
    }()
    
    lazy var resultTableView: UITableView = {
        let resultTableView = UITableView(frame: CGRect.zero, style: .plain)
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(cellType: ComicTVCell.self)
       // resultTableView.tableFooterView = UIView()
        return resultTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.background
        
        self.searchBar.frame = CGRect(x: 0, y: 0, width: xScreenWidth - 50, height: 30)
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil,
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(cancelAction))
        
        setupLayout()
        searchTableView.isHidden = true
        resultTableView.isHidden = true
        searchTableView.tableFooterView = UIView()
        resultTableView.tableFooterView = UIView()
        
    }
    
    private func searchRelative(_ text: String) {
        if text.count > 0 {
            searchTableView.isHidden = false
            resultTableView.isHidden = true
            currentRequest?.cancel()
            currentRequest = ApiProvider.request(LBUApi.searchRelative(inputText: text), model: [LBUSearchItemModel].self) { (returnData) in
                self.relative = returnData
                self.searchTableView.reloadData()
            }
        } else {
            searchTableView.isHidden = true
            resultTableView.isHidden = true
        }
    }
    
    private func
        searchResult(_ text: String) {
        if text.count > 0 {
            searchTableView.isHidden = true
            resultTableView.isHidden = false
            searchBar.text = text
            ApiLoadingProvider.request(LBUApi.searchResult(argCon: 0, q: text), model: LBUSearchResultModel.self) { (returnData) in
                self.comics = returnData?.comics
                self.resultTableView.reloadData()
            }
        } else {
            searchTableView.isHidden = true
            resultTableView.isHidden = true
        }
    }
    
    private func setupLayout() {
        
        view.addSubview(searchTableView)
        searchTableView.snp.makeConstraints { make in make.edges.equalToSuperview() }
    
        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints { make in make.edges.equalToSuperview() }
    }
    
    @objc private func cancelAction() {
        searchBar.resignFirstResponder()
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .reveal
        transition.subtype = .fromBottom
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: false)
    }
    
}

extension SearchVC:UITextFieldDelegate {
    
    @objc func textFiledTextDidChange(noti: Notification) {
        guard let textField = noti.object as? UITextField,
            let text = textField.text else { return }
        searchRelative(text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

extension SearchVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == searchTableView {
            return relative?.count ?? 0
        } else {
            return comics?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == searchTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BaseTableViewCell.self)
            cell.textLabel?.text = relative?[indexPath.row].name
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.separatorInset = .zero
            return cell
        } else if tableView == resultTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicTVCell.self)
            cell.model = comics?[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BaseTableViewCell.self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == resultTableView {
            return 180
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == searchTableView {
            searchResult(relative?[indexPath.row].name ?? "")
        } else if tableView == resultTableView {
            guard let model = comics?[indexPath.row] else { return }
            let vc = ComicVC(comicid: model.comicId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
