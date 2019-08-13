//
//  ChapterView.swift
//  CACartoon
//
//  Created by Cary on 2019/8/13.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

typealias toRead = (_ index:Int)->Void

class ChapterView: UIView {
    
    private var isPositive: Bool = true
    var detailStatic: LBUDetailStaticModel?
    var pushToRead:toRead?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: floor((xScreenWidth - 30) / 2), height: 40)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.register(supplementaryViewType: ChapterHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(cellType: ChapterCollectionViewCell.self)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex: "#000000").alpha(0.5)
        setupLayout()
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeView))
        self.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(){
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints{ make in
          //  make.edges.equalToSuperview()
            make.top.equalToSuperview().offset(xScreenHeight/2)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc func removeView(){
        
        UIView.animate(withDuration: 1.0) {
           self.removeFromSuperview()
        }
        
    }
}

extension ChapterView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailStatic?.chapter_list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: xScreenWidth, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: ChapterHeaderView.self)
        head.model = detailStatic
        head.sortClosure { [weak self] (button) in
            if self?.isPositive == true {
                self?.isPositive = false
                button.setTitle("正序", for: .normal)
            } else {
                self?.isPositive = true
                button.setTitle("倒序", for: .normal)
            }
            self?.collectionView.reloadData()
        }
        return head
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ChapterCollectionViewCell.self)
        if isPositive {
            cell.chapterStatic = detailStatic?.chapter_list?[indexPath.row]
        } else {
            cell.chapterStatic = detailStatic?.chapter_list?.reversed()[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = isPositive ? indexPath.row : ((detailStatic?.chapter_list?.count)! - indexPath.row - 1)
        pushToRead!(index)
    }
}

extension ChapterView:UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
//        if String(describing: touch.view?.classForCoder) == "UITableViewCellContentView" {
//            return false
//        }
        if (touch.view?.isDescendant(of: self.collectionView))! {
            return false
        } else {
             return true
        }
    }
}
