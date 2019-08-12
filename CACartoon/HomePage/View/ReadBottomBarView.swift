//
//  ReadBottomBarView.swift
//  CACartoon
//
//  Created by Cary on 2019/8/9.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

class ReadBottomBarView: UIView {

    lazy var menuSlider: UISlider = {
        let menuSlider = UISlider()
        menuSlider.thumbTintColor = UIColor.navColor
        menuSlider.minimumTrackTintColor = UIColor.navColor
        menuSlider.isContinuous = false
        return menuSlider
    }()
    
    lazy var deviceDirectionButton: UIButton = {
        let deviceDirectionButton = UIButton(type: .system)
        deviceDirectionButton.setImage(UIImage(named: "readerMenu_changeScreen_horizontal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return deviceDirectionButton
    }()
    
    lazy var lightButton: UIButton = {
        let lightButton = UIButton(type: .system)
        lightButton.setImage(UIImage(named: "readerMenu_luminance")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return lightButton
    }()
    
    lazy var chapterButton: UIButton = {
        let chapterButton = UIButton(type: .system)
        chapterButton.setImage(UIImage(named: "readerMenu_catalog")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return chapterButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(menuSlider)
        menuSlider.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 40))
            make.height.equalTo(30)
            
        }
        
        addSubview(deviceDirectionButton)
        addSubview(lightButton)
        addSubview(chapterButton)
        
        deviceDirectionButton.snp.makeConstraints { make in
            
            make.top.equalTo(menuSlider.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(60)
            make.bottom.equalToSuperview()
        }
        
        lightButton.snp.makeConstraints { make in
            
            make.top.equalTo(menuSlider.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        chapterButton.snp.makeConstraints { make in
            
            make.top.equalTo(menuSlider.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-60)
            make.bottom.equalToSuperview()
        }
    }
}
