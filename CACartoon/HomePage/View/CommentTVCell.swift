//
//  CommentTVCell.swift
//  CACartoon
//
//  Created by Cary on 2019/8/15.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

class CommentTVCell: BaseTableViewCell {

    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        iconView.layer.cornerRadius = iconView.frame.size.width/2
        iconView.layer.masksToBounds = true
        return iconView
    }()
    
    lazy var nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.textColor = UIColor.gray
        nickNameLabel.font = UIFont.systemFont(ofSize: 13)
        return nickNameLabel
    }()
    
    lazy var contentTextView: UITextView = {
        let contentTextView = UITextView()
        contentTextView.isUserInteractionEnabled = false
        contentTextView.font = UIFont.systemFont(ofSize: 13)
        contentTextView.textColor = UIColor.black
        return contentTextView
    }()
    
    override func setupUI() {
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints{ make in
            make.left.top.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
        }
        
        contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.top.equalTo(iconView)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(15)
        }
        
        contentView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            make.left.right.equalTo(nickNameLabel)
            make.bottom.greaterThanOrEqualToSuperview().offset(-10)
        }
    }
    
    var viewModel: LBUCommentViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            let url = URL(string: viewModel.model!.face!)
            iconView.kf.setImage(
                with: url,
                placeholder: UIImage.init(named: "mine_author"),
                options: [.transition(.fade(1)), .loadDiskFileSynchronously],
                progressBlock: { receivedSize, totalSize in
            },
                completionHandler: { result in
                    // print(result)
            })
            nickNameLabel.text = viewModel.model?.nickname
            contentTextView.text = viewModel.model?.content_filter
        }
    }
}

class LBUCommentViewModel {
    
    var model: LBUCommentModel?
    var height: CGFloat = 0
    
    convenience init(model: LBUCommentModel) {
        self.init()
        self.model = model
        
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.text = model.content_filter
        let height = textView.sizeThatFits(CGSize(width: xScreenWidth - 70, height: CGFloat.infinity)).height
        self.height = max(60, height + 45)
    }
    
    required init() {}
}


