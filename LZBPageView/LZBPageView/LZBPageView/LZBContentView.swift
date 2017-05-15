//
//  LZBContentView.swift
//  LZBPageView
//
//  Created by zibin on 2017/5/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class LZBContentView: UIView {

    var childVcs : [UIViewController]
    var style : LZBPageStyleModel
    var parentVc  : UIViewController
    
    
    init(frame : CGRect, childVcs : [UIViewController], parentVc : UIViewController, style : LZBPageStyleModel) {
        self.childVcs = childVcs
        self.style = style
        self.parentVc = parentVc
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
