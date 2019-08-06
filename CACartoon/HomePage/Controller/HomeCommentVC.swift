//
//  HomeCommentVC.swift
//  CACartoon
//
//  Created by Cary on 2019/8/1.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import LLCycleScrollView
import SnapKit

class HomeCommentVC: UIViewController {

    private var galleryItems = [LBUGalleryItemModel]()
    private var textItems = [LBUTextItemModel]()
    private var comicLists = [LBUComicListModel]()
    
    
    private lazy var bannerView:LLCycleScrollView = {
        
        let cycleScrollView = LLCycleScrollView()
        cycleScrollView.backgroundColor = UIColor.background
        cycleScrollView.placeHolderImage = UIImage(named: "normal_placeholder")
        cycleScrollView.pageControlBottom = 20
        return cycleScrollView
    }()

    private lazy var collectionView: UICollectionView = {
        let lt = UCollectionViewSectionBackgroundLayout()
        lt.minimumInteritemSpacing = 5
        lt.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        collectionView.backgroundColor = UIColor.background
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: xScreenWidth * 0.5, left: 0, bottom: 0, right: 0)
        collectionView.addSubview(bannerView)
        bannerView.frame = CGRect(x: 0, y: -xScreenWidth * 0.5, width: xScreenWidth, height: xScreenWidth * 0.5)
        // 注册cell
        collectionView.register(cellType: ComicCollectionViewCell.self)
        collectionView.register(cellType: BoardCollectionViewCell.self)
        // 注册头部
        collectionView.register(supplementaryViewType: ComicCollectionHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        setupLayout()
        setupLoadData()
    }
    
    private func setupLoadData () {
        
        ApiLoadingProvider.request(LBUApi.boutiqueList(sexType: 1), model: LBUBoutiqueListModel.self) {(returnData) in
            
            self.galleryItems = returnData?.galleryItems ?? []
            self.textItems = returnData?.textItems ?? []
            self.comicLists = returnData?.comicLists ?? []
            self.bannerView.imagePaths = self.galleryItems.filter { $0.cover != nil }.map { $0.cover! }
            self.collectionView.reloadData()
            self.collectionView.contentOffset = CGPoint(x: 0, y: -xScreenWidth * 0.5)
            self.collectionView.layoutIfNeeded()
        }
    }
    
    private func setupLayout () {
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).offset(barH)
        }
    }
}

extension HomeCommentVC:UCollectionViewSectionBackgroundLayoutDelegateLayout,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comicLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = comicLists[section]
        return comicList.comics?.prefix(4).count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = comicLists[section]
        return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: xScreenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return comicLists.count - 1 != section ? CGSize(width: xScreenWidth, height: 10) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: BoardCollectionViewCell.self)
            cell.model = comicList.comics?[indexPath.row]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ComicCollectionViewCell.self)
            if comicList.comicType == .thematic {
                cell.cellStyle = .none
            } else {
                cell.cellStyle = .withTitieAndDesc
            }
            cell.model = comicList.comics?[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: ComicCollectionHeaderView.self)
            let comicList = comicLists[indexPath.section]
            let url = URL(string: comicList.newTitleIconUrl!)
            headerView.iconView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [.transition(.fade(1)), .loadDiskFileSynchronously],
                progressBlock: { receivedSize, totalSize in
            },
                completionHandler: { result in
                   // print(result)
            }
            )
            
            headerView.titleLabel.text = comicList.itemTitle
//            headerView.moreActionClosure { [weak self] in
//                if comicList.comicType == .thematic {
//
//                }
//                else if comicList.comicType == .animation {
//
//                } else if comicList.comicType == .update {
//
//                } else {
//
//                }
//            }
            return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let width = floor((xScreenWidth - 15.0) / 4.0)
            return CGSize(width: width, height: 80)
        }else {
            if comicList.comicType == .thematic {
                let width = floor((xScreenWidth - 5.0) / 2.0)
                return CGSize(width: width, height: 120)
            } else {
                let count = comicList.comics?.takeMax(4).count ?? 0
                let warp = count % 2 + 2
                let width = floor((xScreenWidth - CGFloat(warp - 1) * 5.0) / CGFloat(warp))
                return CGSize(width: width, height: CGFloat(warp * 80))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
}
