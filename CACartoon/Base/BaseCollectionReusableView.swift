//
//  BaseCollectionReusableView.swift
//  CACartoon
//
//  Created by Cary on 2019/8/2.
//  Copyright © 2019 Cary. All rights reserved.
//

import Reusable

class BaseCollectionReusableView: UICollectionReusableView,Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupLayout() {}
}
