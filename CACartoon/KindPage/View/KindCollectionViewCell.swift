//
//  KindCollectionViewCell.swift
//  CACartoon
//
//  Created by Cary on 2019/8/7.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

class KindCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        return iw
    }()
    
    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textColor = .black
        return tl
    }()
    
    override func setupLayout() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints{ make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(0.75)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom)
        }
    }
    
    var model: LBURankingModel? {
        didSet {
            guard let model = model else { return }
            let url = URL(string: model.cover!)
            iconView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [.transition(.fade(1)), .loadDiskFileSynchronously],
                progressBlock: { receivedSize, totalSize in
            },
                completionHandler: { result in
                    // print(result)
            })
            titleLabel.text = model.sortName
        }
    }
}
