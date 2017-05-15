//
//  LZBPageStyleModel.swift
//  LZBPageView
//
//  Created by zibin on 2017/5/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

struct LZBPageStyleModel {
    
    var  titleViewHeight : CGFloat = 44  //标题栏默认高度
    var  titleViewTitleNormalColor : UIColor = UIColor(r: 0, g: 0, b: 0)  //正常情况默认黑色
    var  titleViewTitleSelectColor : UIColor = UIColor(r: 255, g: 0, b: 7) //选中情况默认红色
    var  titleViewTitleFont : UIFont = UIFont.systemFont(ofSize: 14.0)  //默认字体
    var  titleViewIsScrollEnable : Bool = false   //默认不可以滚动
    var  titleViewMargin :  CGFloat = 20.0  //默认间距
    
}
