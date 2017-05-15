//
//  LZBTitleView.swift
//  LZBPageView
//
//  Created by zibin on 2017/5/15.
//  Copyright © 2017年 Apple. All rights reserved.
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
    
    
    fileprivate lazy  var deltaColor : (CGFloat, CGFloat, CGFloat) = {
        let rdelta = self.selectColor.0 - self.normalColor.0
        let gdelta = self.selectColor.1 - self.normalColor.1
        let bdelta = self.selectColor.2 - self.normalColor.2
        return (rdelta , gdelta , bdelta)
    }()
    //懒加载
    fileprivate lazy var scrollView : UIScrollView = {
         let scrollView = UIScrollView(frame: self.bounds)
           scrollView.showsHorizontalScrollIndicator = false
           scrollView.scrollsToTop = false
          return scrollView
    }()
    
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
            if style.titleViewIsScrollEnable   //可以滚动
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
        if style.titleViewIsScrollEnable{
        self.scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + style.titleViewMargin, height: 0)
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
    }
   
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
    }


}
