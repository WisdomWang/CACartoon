//
//  ChapterCollectionViewCell.swift
//  CACartoon
//
//  Created by Cary on 2019/8/9.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

class ChapterCollectionViewCell: BaseCollectionViewCell {
    
    lazy var nameLabel: UILabel = {
        let nl = UILabel()
        nl.font = UIFont.systemFont(ofSize: 14)
        nl.textColor = UIColor(hex: "#333333")
        return nl
    }()
    
    override func setupLayout() {
        contentView.backgroundColor = UIColor.white
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) }
    }
    
    var chapterStatic: LBUChapterStaticModel? {
        didSet {
            guard let chapterStatic = chapterStatic else { return }
            nameLabel.text = chapterStatic.name
        }
    }
}
