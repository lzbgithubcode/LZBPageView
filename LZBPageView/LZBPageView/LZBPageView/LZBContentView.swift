//
//  LZBContentView.swift
//  LZBPageView
//
//  Created by zibin on 2017/5/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit


private let kLZBContentViewCellID = "kLZBContentViewCellID"

class LZBContentView: UIView{

    fileprivate var childVcs : [UIViewController]
    fileprivate var style : LZBPageStyleModel
    fileprivate var parentVc  : UIViewController
    //懒加载collectionView
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
           collectionView.dataSource = self
           collectionView.delegate = self
           collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:kLZBContentViewCellID)
           collectionView.isPagingEnabled = true
           collectionView.showsHorizontalScrollIndicator = false
           collectionView.bounces = false
           collectionView.scrollsToTop = false
        return collectionView
    }()
    
    
    init(frame : CGRect, childVcs : [UIViewController], parentVc : UIViewController, style : LZBPageStyleModel) {
        self.childVcs = childVcs
        self.style = style
        self.parentVc = parentVc
        super.init(frame: frame)
        self.setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//MARK:- 初始化UI界面
extension LZBContentView {
    fileprivate func setupUI(){
       //1.将子控制器加入到父控制器
        for childVC in self.childVcs {
            self.parentVc.addChildViewController(childVC)
        }
        
        addSubview(self.collectionView)
    }
}

//MARK:- 遵守数据协议UICollectionViewDataSource
extension LZBContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kLZBContentViewCellID, for: indexPath)
        //移除之前的Veiw
        for subview in cell.contentView.subviews {
              subview.removeFromSuperview()
        }
        //增加新的View
        let subChildvc =  self.childVcs[indexPath.item]
        cell.contentView.addSubview(subChildvc.view)
        
        return cell
    }
}


//MARK:- 遵守代理协议UICollectionViewDelegate
extension LZBContentView : UICollectionViewDelegate{
 
}
