//
//  LZBTitleView.swift
//  LZBPageView
//
//  Created by zibin on 2017/5/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class LZBTitleView: UIView {
    var titles : [String]
    var style : LZBPageStyleModel
    
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
        var titleLabels : [UILabel] = [UILabel]()
        let  count = self.titles.count
        for i in 0..<count {
           let tilteLabel = UILabel()
           let title = self.titles[i]
            tilteLabel.text = title
            tilteLabel.textAlignment = .center
            tilteLabel.textColor = i == 0 ? style.titleViewTitleSelectColor :style.titleViewTitleNormalColor
            tilteLabel.font = style.titleViewTitleFont
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
  
    func titleLabelClick(_ tapGester : UITapGestureRecognizer){
        guard let  tapView = tapGester.view as? UILabel else{
          return
        }
       tapView.sizeToFit()
    }
   
}
