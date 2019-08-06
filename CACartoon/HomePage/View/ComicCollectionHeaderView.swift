//
//  ComicCollectionHeaderView.swift
//  CACartoon
//
//  Created by Cary on 2019/8/2.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

// 回调 相当于 OC中的Block (闭包)
typealias LBUComicCollectionHeaderMoreActionBlock = ()->Void

// 代理
protocol LBUComicCollecHeaderViewDelegate: class {
    func comicCollectionHeaderView(_ comicCHead: ComicCollectionHeaderView, moreAction button: UIButton)
}


class ComicCollectionHeaderView: BaseCollectionReusableView {

    // 代理声明 弱引用
    weak var delegate: LBUComicCollecHeaderViewDelegate?
    // 回调声明 相当于 OC中的Block
    private var moreActionClosure: LBUComicCollectionHeaderMoreActionBlock?
    
    lazy var iconView: UIImageView = {
        return UIImageView()
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor(hex: "#333333")
        return titleLabel
    }()
    
    lazy var moreButton: UIButton = {
        let mn = UIButton(type: .system)
        mn.setTitle("更多", for: .normal)
        mn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
        mn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        mn.addTarget(self, action: #selector(moreActionClick), for: .touchUpInside)
        return mn
    }()
    
    @objc func moreActionClick(button: UIButton) {
        delegate?.comicCollectionHeaderView(self, moreAction: button)
        
        guard let closure = moreActionClosure else { return }
        closure()
    }
    
    func moreActionClosure(_ closure: LBUComicCollectionHeaderMoreActionBlock?) {
        moreActionClosure = closure
    }
    
    // 继承父类方法 布局
    override func setupLayout() {
        
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right)
            make.centerY.height.equalTo(iconView)
            make.width.equalTo(200)
        }
        
        addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-5)
            make.width.equalTo(40)
        }
    }
}
