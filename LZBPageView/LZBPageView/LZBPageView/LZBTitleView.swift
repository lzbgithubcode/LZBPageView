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
    
    
    init(frame : CGRect, titles : [String], style : LZBPageStyleModel) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
