//
//  ChapterHeaderView.swift
//  CACartoon
//
//  Created by Cary on 2019/8/9.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

typealias ChapterCHeadSortClosure = (_ button: UIButton) -> Void

class ChapterHeaderView: BaseCollectionReusableView {

    private var sortClosure: ChapterCHeadSortClosure?
    
    private lazy var chapterLabel: UILabel = {
        let vl = UILabel()
        vl.textColor = UIColor(hex: "#999999")
        vl.numberOfLines = 0
        vl.font = UIFont.systemFont(ofSize: 13)
        return vl
    }()
    
    private lazy var sortButton: UIButton = {
        let sn = UIButton(type: .system)
        sn.setTitle("倒序", for: .normal)
        sn.setTitleColor(UIColor.gray, for: .normal)
        sn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        sn.addTarget(self, action: #selector(sortAction(for:)), for: .touchUpInside)
        return sn
    }()
    
    @objc private func sortAction(for button: UIButton) {
        guard let sortClosure = sortClosure else { return }
        sortClosure(button)
    }
    
    func sortClosure(_ closure: @escaping ChapterCHeadSortClosure) {
        sortClosure = closure
    }
    
    override func setupLayout() {
        
        addSubview(sortButton)
        sortButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(44)
        }
        
        addSubview(chapterLabel)
        chapterLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(sortButton.snp.left).offset(-10)
        }
    }
    
    var model: LBUDetailStaticModel? {
        didSet {
            guard let model = model else { return }
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            chapterLabel.text = "目录 \(format.string(from: Date(timeIntervalSince1970: model.comic?.last_update_time ?? 0))) 更新 \(model.chapter_list?.last?.name ?? "")"
        }
    }
}
