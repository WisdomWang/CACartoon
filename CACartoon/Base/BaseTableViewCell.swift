//
//  BaseTableViewCell.swift
//  CACartoon
//
//  Created by Cary on 2019/8/6.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import Reusable

class BaseTableViewCell: UITableViewCell,Reusable {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupUI() {}

}
