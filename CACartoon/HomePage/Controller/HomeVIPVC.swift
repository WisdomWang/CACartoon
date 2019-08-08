//
//  HomeVIPVC.swift
//  CACartoon
//
//  Created by Cary on 2019/8/1.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

class HomeVIPVC: UIViewController {

    private var vipList = [LBUComicListModel]()
    
    private lazy var collectionView:UICollectionView = {
        let layout = UCollectionViewSectionBackgroundLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.background
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cellType: ComicCollectionViewCell.self)
        collectionView.register(supplementaryViewType: ComicCollectionHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        setupLayout()
        setupLoadData()
    }
    
    private func setupLoadData() {
        ApiLoadingProvider.request(LBUApi.vipList, model: LBUVipListModel.self) { (returnData) in
            
            self.vipList = returnData?.newVipList ?? []
            self.collectionView.reloadData()
        }
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).offset(barH)
        }
        
    }
    
}

extension HomeVIPVC:UCollectionViewSectionBackgroundLayoutDelegateLayout,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vipList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = vipList[section]
        return comicList.comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: ComicCollectionHeaderView.self)
            let comicList = vipList[indexPath.section]
            let url = URL(string: comicList.titleIconUrl!)
            head.iconView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [.transition(.fade(1)), .loadDiskFileSynchronously],
                progressBlock: { receivedSize, totalSize in
            },
                completionHandler: { result in
                    // print(result)
            }
            )
            head.titleLabel.text = comicList.itemTitle
            head.moreButton.isHidden = !comicList.canMore
//            head.moreActionClosure { [weak self] in
//
//            }
            return head
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = vipList[section]
        return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: xScreenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return vipList.count - 1 != section ? CGSize(width: xScreenWidth, height: 10) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ComicCollectionViewCell.self)
        cell.cellStyle = .withTitle
        let comicList = vipList[indexPath.section]
        cell.model = comicList.comics?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(xScreenWidth - 10.0) / 3.0)
        return CGSize(width: width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let comicList = vipList[indexPath.section]
        guard let model = comicList.comics?[indexPath.row] else { return }
        let vc = ComicVC(comicid: model.comicId)
        navigationController?.pushViewController(vc, animated: true)
    }
}
