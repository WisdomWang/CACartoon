//
//  ChapterReadVC.swift
//  CACartoon
//
//  Created by Cary on 2019/8/9.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

class ChapterReadVC: UIViewController {

    private var isBarHidden: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.5) {
                self.topBar.snp.updateConstraints { make in
                    make.top.equalTo(self.backScrollView).offset(self.isBarHidden ? -(self.edgeInsets.top + 44) : 0)
                }
                self.bottomBar.snp.updateConstraints { make in
                    make.bottom.equalTo(self.backScrollView).offset(self.isBarHidden ? (self.edgeInsets.bottom + 120) : 0)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    var edgeInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            return .zero
        }
    }
    
    private var isLandscapeRight: Bool! {
        didSet {
            UIApplication.changeOrientationTo(landscapeRight: isLandscapeRight)
            collectionView.reloadData()
        }
    }
    
    private var chapterList = [LBUChapterModel]()
    
    private var detailStatic: LBUDetailStaticModel?
    
    private var selectIndex: Int = 0
    
    private var previousIndex: Int = 0
    
    private var nextIndex: Int = 0
    
    lazy var backScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.5
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        tap.require(toFail: doubleTap)
        return scrollView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.sectionInset = .zero
        lt.minimumLineSpacing = 10
        lt.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: lt)
        collectionView.backgroundColor = UIColor.background
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: ReadCollectionViewCell.self)
        collectionView.es.addPullToRefresh {
            let previousIndex = self.previousIndex
            self.loadData(with: previousIndex, isPreious: true, needClear: false, finished: { (Bool) in
                self.previousIndex = previousIndex - 1
            })
        }
        collectionView.es.addInfiniteScrolling {
            let nextIndex = self.nextIndex
            self.loadData(with: nextIndex, isPreious: false, needClear: false, finished: { (Bool) in
                self.nextIndex = nextIndex + 1
            })
        }
        return collectionView
    }()
    
    lazy var topBar: ReadTopBarView = {
        let topBar = ReadTopBarView()
        topBar.backgroundColor = UIColor.white
        topBar.backButton.addTarget(self, action: #selector(pressBack), for: .touchUpInside)
        return topBar
    }()
    
    lazy var bottomBar: ReadBottomBarView = {
        let bottomBar = ReadBottomBarView()
        bottomBar.backgroundColor = UIColor.white
        bottomBar.deviceDirectionButton.addTarget(self, action: #selector(changeDeviceDirection(_:)), for: .touchUpInside)
        bottomBar.chapterButton.addTarget(self, action: #selector(changeChapter(_:)), for: .touchUpInside)
        return bottomBar
    }()
    
    convenience init(detailStatic: LBUDetailStaticModel?, selectIndex: Int) {
        self.init()
        self.detailStatic = detailStatic
        self.selectIndex = selectIndex
        self.previousIndex = selectIndex - 1
        self.nextIndex = selectIndex + 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        edgesForExtendedLayout = .all
        setupLayout()
        loadData(with: selectIndex, isPreious: false, needClear: false)
    }
    
    func loadData(with index: Int, isPreious: Bool, needClear: Bool, finished: ((_ finished: Bool) -> Void)? = nil) {
        guard let detailStatic = detailStatic else { return }
        topBar.titleLabel.text = detailStatic.comic?.name
        
        if index <= -1 {
            collectionView.es.stopPullToRefresh()
        } else if index >= detailStatic.chapter_list?.count ?? 0 {
            collectionView.es.stopLoadingMore()
            collectionView.es.noticeNoMoreData()
        } else {
            guard let chapterId = detailStatic.chapter_list?[index].chapter_id else { return }
            ApiLoadingProvider.request(LBUApi.chapter(chapter_id: chapterId), model: LBUChapterModel.self) { (returnData) in
                
                self.collectionView.es.stopPullToRefresh()
                self.collectionView.es.stopLoadingMore()
                
                guard let chapter = returnData else { return }
                if needClear { self.chapterList.removeAll() }
                if isPreious {
                    self.chapterList.insert(chapter, at: 0)
                } else {
                    self.chapterList.append(chapter)
                }
                guard chapter.image_list != nil else {
                    
                    let alert = UIAlertController(title: "该章节暂不支持阅读哟", message: "", preferredStyle: .alert)
                    let actionRead = UIAlertAction(title: "知道了", style: .default) { (UIAlertAction) in
                        
                        for controller in self.navigationController!.viewControllers {
                            if controller.isKind(of: ChapterVC.self) {
                               self.navigationController?.popViewController(animated: true)
                            } else {
                               
                            }
                        }
                    }
                    alert.addAction(actionRead)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.collectionView.reloadData()
                guard let finished = finished else { return }
                finished(true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        isLandscapeRight = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         navigationController?.setNavigationBarHidden(false, animated: true)
         isLandscapeRight = false
    }
    
    @objc func tapAction() {
        isBarHidden = !isBarHidden
    }
    
    @objc func doubleTapAction() {
        var zoomScale = backScrollView.zoomScale
        zoomScale = 2.5 - zoomScale
        let width = view.frame.width / zoomScale
        let height = view.frame.height / zoomScale
        let zoomRect = CGRect(x: backScrollView.center.x - width / 2 , y: backScrollView.center.y - height / 2, width: width, height: height)
        backScrollView.zoom(to: zoomRect, animated: true)
    }
    
    @objc func changeDeviceDirection(_ button: UIButton) {
        isLandscapeRight = !isLandscapeRight
        if isLandscapeRight {
            button.setImage(UIImage(named: "readerMenu_changeScreen_vertical")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            button.setImage(UIImage(named: "readerMenu_changeScreen_horizontal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    @objc func pressBack() {
        navigationController?.popViewController(animated: true)
    }

    
    @objc func changeChapter(_ button: UIButton) {
        
        let chapterAlert = ChapterView(frame: .zero)
        chapterAlert.detailStatic = self.detailStatic
        chapterAlert.collectionView.reloadData()
        UIView.animate(withDuration: 1.0) {
             self.view.insertSubview(chapterAlert, aboveSubview: self.view)
        }

        chapterAlert.pushToRead = { index  in
            
            chapterAlert.removeView()
            self.selectIndex = index
            self.previousIndex = self.selectIndex - 1
            self.nextIndex = self.selectIndex + 1
            self.loadData(with: self.selectIndex, isPreious: false, needClear: true)
        }
        
        chapterAlert.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupLayout() {
        
        view.backgroundColor = UIColor.white
        view.addSubview(backScrollView)
        backScrollView.snp.makeConstraints { make in
            
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalTo(self.view.snp.edges)
            }
        }
        
        backScrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(backScrollView)
        }
        
        view.addSubview(topBar)
        topBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(backScrollView)
            make.height.equalTo(44)
        }
        
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(backScrollView)
            make.height.equalTo(80)
        }
    }
}


extension ChapterReadVC:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return chapterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapterList[section].image_list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let image = chapterList[indexPath.section].image_list?[indexPath.row] else { return CGSize.zero }
        let width = backScrollView.frame.width
        let height = floor(width / CGFloat(image.width) * CGFloat(image.height))
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType:ReadCollectionViewCell.self)
        cell.model = chapterList[indexPath.section].image_list?[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isBarHidden == false { isBarHidden = true }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == backScrollView {
            return collectionView
        } else {
            return nil
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView == backScrollView {
            scrollView.contentSize = CGSize(width: scrollView.frame.width * scrollView.zoomScale, height: scrollView.frame.height)
        }
    }
}
