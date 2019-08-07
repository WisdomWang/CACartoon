//
//  SpecialTVCell.swift
//  CACartoon
//
//  Created by Cary on 2019/8/7.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

class SpecialTVCell: BaseTableViewCell {

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        return titleLabel
    }()
    
    private lazy var coverView: UIImageView = {
        let coverView = UIImageView()
        coverView.contentMode = .scaleAspectFill
        coverView.layer.cornerRadius = 5
        coverView.layer.masksToBounds = true
        return coverView
    }()
    
    private lazy var tipLabel: UILabel = {
        let tipLabel = UILabel()
        tipLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 9)
        return tipLabel
    }()
    
    override func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            make.height.equalTo(40)
        }
        
        contentView.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10))
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        coverView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.background
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
    var model: LBUComicModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.title
            let url = URL(string: model.cover!)
            coverView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [.transition(.fade(1)), .loadDiskFileSynchronously],
                progressBlock: { receivedSize, totalSize in
            },
                completionHandler: { result in
                    // print(result)
            })
            tipLabel.text = "    \(model.subTitle ?? "")"
        }
    }
}
