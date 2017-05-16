//
//  LZBContentView.swift
//  LZBPageView
//
//  Created by zibin on 2017/5/12.
//  Copyright © 2017年 项目共享githud地址：https://github.com/lzbgithubcode/LZBPageView 简书详解地址：http://www.jianshu.com/p/3170d0d886a2  作者喜欢分享技术与开发资料，如果你也是喜欢分享的人可以加入我们iOS资料demo共享群：490658347. All rights reserved.
//

import UIKit

protocol LZBContentViewDelegate : class  {
    func contentView(contentView : LZBContentView , didScrollEnd index : Int)
    func contentView(contentView : LZBContentView , soureIndex : Int, targetIndex : Int, progress : CGFloat)
}

private let kLZBContentViewCellID = "kLZBContentViewCellID"

class LZBContentView: UIView{

    weak var delegate : LZBContentViewDelegate?
    fileprivate var childVcs : [UIViewController]
    fileprivate var style : LZBPageStyleModel
    fileprivate var parentVc  : UIViewController
    fileprivate var  startOffsetX : CGFloat = 0
    fileprivate var isForbidDelegate : Bool = false
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
   
    //滚动完成监听 - 减速完成
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
          self.contentViewScrollDidEnd()
    }
     //滚动完成监听 - 拖拽完成
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
          self.contentViewScrollDidEnd()
        }
    }
    
    //滚动完成
    fileprivate func contentViewScrollDidEnd(){
        let currentIndex = Int(collectionView.contentOffset.x/collectionView.bounds.width)
         delegate?.contentView(contentView: self, didScrollEnd: currentIndex)
    }
    
    //记录起始位置的offsetX
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
          self.startOffsetX = collectionView.contentOffset.x
         isForbidDelegate = false
    }
    
    //滚动进度
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        //当前偏移量
        let currentOffsetX = collectionView.contentOffset.x
        
        guard !isForbidDelegate else {
            return
        }
        
        //如果相等就是没有动
        guard currentOffsetX != startOffsetX else {
            return
        }
        
        var  soureIndex = 0
        var  targetIndex = 0
        var  progress : CGFloat = 0
        let collectionViewWidth = collectionView.bounds.width
        
        //判断左右滑动
        if currentOffsetX > startOffsetX{  //左滑
            soureIndex = Int(currentOffsetX/collectionViewWidth)
            targetIndex = soureIndex + 1
            if targetIndex >= self.childVcs.count{
               targetIndex = self.childVcs.count - 1
            }
            //进度
            progress = (currentOffsetX - startOffsetX)/collectionViewWidth
            
            if (currentOffsetX - startOffsetX) == collectionViewWidth{
               targetIndex = soureIndex
            }
        }
        else  //右滑
        {
            targetIndex = Int(currentOffsetX/collectionViewWidth)
            soureIndex = targetIndex + 1
            progress = (startOffsetX - currentOffsetX)/collectionViewWidth
            
        }
        delegate?.contentView(contentView: self, soureIndex: soureIndex, targetIndex: targetIndex, progress: progress)
    }
}

//MARK:- 遵守titleView点击协议
extension LZBContentView : LZBTitleViewDelegate{
    func  titleView(_ titleView: LZBTitleView, targetIndex: NSInteger) {
        
        //点击禁止代理
        self.isForbidDelegate = true
        
        //1.选中标题对应的indexPath
        let indexPath = IndexPath(item: targetIndex, section: 0)
        
        //2.滚动到对应的cell
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}
