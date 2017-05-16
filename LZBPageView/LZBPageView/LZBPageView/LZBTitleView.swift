//
//  LZBTitleView.swift
//  LZBPageView
//
//  Created by zibin on 2017/5/12.
//  Copyright © 2017年 项目共享githud地址：https://github.com/lzbgithubcode/LZBPageView 简书详解地址：http://www.jianshu.com/p/3170d0d886a2  作者喜欢分享技术与开发资料，如果你也是喜欢分享的人可以加入我们iOS资料demo共享群：490658347. All rights reserved.
//

import UIKit

//用class表示只有类可以继承协议，本来不需要声明什么的
protocol LZBTitleViewDelegate : class {
    func titleView(_ titleView : LZBTitleView, targetIndex : NSInteger)
}


class LZBTitleView: UIView {
    weak var delegate : LZBTitleViewDelegate?
    fileprivate var titles : [String]
    fileprivate var style : LZBPageStyleModel
    
    fileprivate var currentIndex : NSInteger = 0
    
    fileprivate lazy  var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy  var normalColor : (CGFloat, CGFloat, CGFloat) = self.style.titleViewTitleNormalColor.getRGBValue()
    fileprivate lazy  var selectColor : (CGFloat, CGFloat, CGFloat) = self.style.titleViewTitleSelectColor.getRGBValue()
    
    //懒加载
    fileprivate lazy  var deltaColor : (CGFloat, CGFloat, CGFloat) = {
        let rdelta = self.selectColor.0 - self.normalColor.0
        let gdelta = self.selectColor.1 - self.normalColor.1
        let bdelta = self.selectColor.2 - self.normalColor.2
        return (rdelta , gdelta , bdelta)
    }()
    fileprivate lazy var scrollView : UIScrollView = {
         let scrollView = UIScrollView(frame: self.bounds)
           scrollView.showsHorizontalScrollIndicator = false
           scrollView.scrollsToTop = false
          return scrollView
    }()
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        return bottomLine
    }()
    fileprivate lazy var lableMaskView : UIView  = {
        let lableMaskView = UIView()
        lableMaskView.backgroundColor = self.style.maskColor
        return lableMaskView
    }()
    
    //Mark:- 构造函数
    init(frame : CGRect, titles : [String], style : LZBPageStyleModel) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK:- 初始化UI
extension LZBTitleView {
    
   fileprivate func setupUI(){
     addSubview(scrollView)
     setupTitles()
    if self.style.isShowBottomLine{
      self.setupBottomLine()
    }
    
    if self.style.isNeedMask{
      self.setupMaskView()
    }
    
   }
    
    
    private func setupBottomLine(){
       scrollView.addSubview(self.bottomLine)
        guard let titleLabel = self.titleLabels.first else {
             return
        }
       bottomLine.frame = titleLabel.frame
       bottomLine.frame.size.height = self.style.bottomLineHeight
       bottomLine.frame.origin.y = bounds.height - self.style.bottomLineHeight
    }
    
    private func setupMaskView(){
        scrollView.addSubview(self.lableMaskView)
        guard let titleLabel = self.titleLabels.first else {
            return
        }
        
        let maskH : CGFloat = style.maskHeight
        let maskY : CGFloat = (titleLabel.frame.height - maskH) * 0.5
        var maskX : CGFloat = titleLabel.frame.origin.x
        var maskW : CGFloat = titleLabel.frame.width
        
        if self.style.isScrollEnable {
           maskX = maskX - self.style.maskInsetMargin
           maskW = maskW + self.style.maskInsetMargin * 2
        }
        
        lableMaskView.layer.frame = CGRect(x: maskX, y: maskY, width: maskW, height: maskH)
        lableMaskView.layer.cornerRadius = style.maskLayerRadius
        lableMaskView.layer.masksToBounds = true 
    }
    
    private func setupTitles(){
        //1.初始化标题
        let  count = self.titles.count
        for i in 0..<count {
           let tilteLabel = UILabel()
           let title = self.titles[i]
            tilteLabel.tag = i
            tilteLabel.text = title
            tilteLabel.textAlignment = .center
            tilteLabel.textColor = i == 0 ? style.titleViewTitleSelectColor :style.titleViewTitleNormalColor
            tilteLabel.font = style.titleViewTitleFont
            tilteLabel.isUserInteractionEnabled = true
            scrollView.addSubview(tilteLabel)
            titleLabels.append(tilteLabel)
            
            //增加手势
            let  tapGester = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            tilteLabel.addGestureRecognizer(tapGester)
            
        }
        
        //2.布局frame
        var   titleLabX : CGFloat = 0
        let   titleLabY : CGFloat = 0
        var   titleLabW : CGFloat =  bounds.width/CGFloat(count)
        let   titleLabH : CGFloat = style.titleViewHeight
        
        for (i, titleLabel) in titleLabels.enumerated() {
            if style.isScrollEnable   //可以滚动
            {
                titleLabW = (titleLabel.text! as NSString).size(attributes: [NSFontAttributeName : titleLabel.font]).width
                //计算位置
                titleLabX = i == 0 ? style.titleViewMargin : titleLabels[i-1].frame.maxX + style.titleViewMargin
            }
            else   //不可以滚动
            {
               titleLabX = titleLabW * CGFloat(i)
            }
            titleLabel.frame = CGRect(x: titleLabX, y: titleLabY, width: titleLabW, height: titleLabH)
        }
        
        //3.设置contensize
        if style.isScrollEnable{
            self.scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + style.titleViewMargin, height: 0)
        }
        else{
            self.scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: 0)
        }
        
         //4、设置初始位置方法
            if self.style.isNeedScale{
                guard let titleLabel = titleLabels.first else {
                    return
                }
                titleLabel.transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
            }
    }
  
}


//MARK:-监听标题点击
extension LZBTitleView {
  
  @objc fileprivate  func titleLabelClick(_ tapGester : UITapGestureRecognizer){
    
      //1.检验lable 是否为nil
        guard let targetLabel = tapGester.view as? UILabel else{
          return
        }
        guard targetLabel.tag != currentIndex else {
             return
        }
    
      //2.选中三部曲
      let lastLabel = self.titleLabels[currentIndex]
      lastLabel.textColor = style.titleViewTitleNormalColor
      targetLabel.textColor = style.titleViewTitleSelectColor
      currentIndex = targetLabel.tag
    
      //3.调整到中心位置
       self.adjustTargetOffset()
    
      //4.调用代理
     delegate?.titleView(self, targetIndex: currentIndex)
    
     //5.点击滚动下滑线
     if self.style.isShowBottomLine {
        UIView.animate(withDuration: 0.25, animations: { 
              self.bottomLine.frame.size.width = targetLabel.frame.width
              self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
        })
     }
    
    //6.点击放大字体
     if self.style.isNeedScale {
        UIView.animate(withDuration: 0.25, animations: {
            lastLabel.transform = CGAffineTransform.identity
            targetLabel.transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
        })
     }
    
    //7.点击mask滚动
    if self.style.isNeedMask {
        UIView.animate(withDuration: 0.25, animations: { 
            self.lableMaskView.frame.size.width = self.style.isScrollEnable ? targetLabel.frame.width + 2 * self.style.maskInsetMargin :  targetLabel.frame.width
            self.lableMaskView.frame.origin.x = self.style.isScrollEnable ? targetLabel.frame.origin.x - self.style.maskInsetMargin :  targetLabel.frame.origin.x
        })
    }
    
    }
   
    //调整位置
    func adjustTargetOffset(){
        let  targetLabel = self.titleLabels[currentIndex]
        var  offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
        if offsetX < 0{
            offsetX = 0
        }
        let  maxOffsetX = self.scrollView.contentSize.width - scrollView.bounds.width
        if offsetX > maxOffsetX{
            offsetX = maxOffsetX
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
}

//MARK:- 遵守LZBContentViewDelegate协议
extension LZBTitleView : LZBContentViewDelegate{
    func contentView(contentView: LZBContentView, didScrollEnd index: Int) {
        guard index <= self.titleLabels.count else {
            return
        }
         currentIndex = index
         self.adjustTargetOffset()
    }
    
    func contentView(contentView: LZBContentView, soureIndex: Int, targetIndex: Int, progress: CGFloat) {
        
        //1.获取变化的label
        let soureLabel = self.titleLabels[soureIndex]
        let targetLabel = self.titleLabels[targetIndex]
        
        //2.颜色渐变
        soureLabel.textColor = UIColor(r: (self.selectColor.0 - deltaColor.0) * progress, g: (self.selectColor.1 - deltaColor.1) * progress, b: (self.selectColor.2 - deltaColor.2) * progress)
        targetLabel.textColor = UIColor(r: (self.normalColor.0 + deltaColor.0) * progress, g: (self.normalColor.1 + deltaColor.1) * progress, b: (self.normalColor.2 + deltaColor.2) * progress)
        
        //4.拖动contentView，改变字体大小
        if self.style.isNeedScale {
            let deltaScale = self.style.maxScale - 1.0
            soureLabel.transform = CGAffineTransform(scaleX: self.style.maxScale - deltaScale * progress, y: self.style.maxScale - deltaScale * progress)
            targetLabel.transform =  CGAffineTransform(scaleX: 1.0 + deltaScale * progress, y: 1.0 + deltaScale * progress)
        }
        
        let deltaWidth = targetLabel.frame.width - soureLabel.frame.width
        let deltaX = targetLabel.frame.origin.x - soureLabel.frame.origin.x
        //3.拖动contentView,下划线渐变
        if self.style.isShowBottomLine {
            bottomLine.frame.size.width = soureLabel.frame.width + deltaWidth * progress
            bottomLine.frame.origin.x = soureLabel.frame.origin.x + deltaX * progress
        }
        
        //4.拖动contenView，mask渐变
        if self.style.isNeedMask {
            self.lableMaskView.frame.size.width = self.style.isScrollEnable ? soureLabel.frame.width + 2 * self.style.maskInsetMargin + deltaWidth * progress : soureLabel.frame.width + deltaWidth * progress
            self.lableMaskView.frame.origin.x = self.style.isScrollEnable ? soureLabel.frame.origin.x -  self.style.maskInsetMargin + deltaX * progress : soureLabel.frame.origin.x + deltaX * progress

        }
       
    }


}
