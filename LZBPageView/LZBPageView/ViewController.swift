//
//  ViewController.swift
//  LZBPageView
//
//  Created by zibin on 2017/5/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        let pageFrame = CGRect(x : 0, y : 64, width : view.bounds.size.width, height : view.bounds.size.height-64)
        //1.创建标题
        let titles = ["英雄联盟","火蓝","提姆队长","史前巨鳄","洛克萨斯之手","狗头","武器"]
        //2.创建控制器数组
        var childvcs = [UIViewController]()
        for _ in 0..<titles.count
        {
           let vc  = UIViewController()
           let  backgroundcolor = UIColor.getRandomColor()
            vc.view.backgroundColor = backgroundcolor
            childvcs.append(vc)
        }
        
        //3.创建样式
        var  pageStyleModel = LZBPageStyleModel()
        pageStyleModel.titleViewIsScrollEnable = true
        
        //4.创建pageView
        let pageView = LZBPageView(frame: pageFrame, titles: titles, pageStyle: pageStyleModel, childVcs: childvcs, parentVc: self)
        
        view.addSubview(pageView)
        
    }

   

}

