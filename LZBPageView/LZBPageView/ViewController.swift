//
//  ViewController.swift
//  LZBPageView
//
//  Created by zibin on 2017/5/12.
//  Copyright © 2017年 项目共享githud地址：https://github.com/lzbgithubcode/LZBPageView 简书详解地址：http://www.jianshu.com/p/3170d0d886a2  作者喜欢分享技术与开发资料，如果你也是喜欢分享的人可以加入我们iOS资料demo共享群：490658347. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        let pageFrame = CGRect(x : 0, y : 64, width : view.bounds.size.width, height : view.bounds.size.height-64)
        //1.创建标题
        let titles = ["英雄联盟","火蓝","提姆队长","史前巨鳄"]
        //let titles = ["英雄联盟","火蓝","提姆队长","史前巨鳄","洛克萨斯之手","狗头","武器"]
        //2.创建控制器数组
        var childvcs = [UIViewController]()
        for i in 0..<titles.count
        {
           let vc  = UIViewController()
           let  backgroundcolor = UIColor.getRandomColor()
            vc.view.backgroundColor = backgroundcolor
            let label = UILabel()
            label.text = titles[i]
            label.textColor = UIColor.blue
            label.center = CGPoint(x: 150, y: 200)
            label.textAlignment = .center
            label.sizeToFit()
            vc.view.addSubview(label)
            childvcs.append(vc)
        }
        
        //3.创建样式
        var  pageStyleModel = LZBPageStyleModel()
        //pageStyleModel.isScrollEnable = true
       // pageStyleModel.isNeedScale = true
        pageStyleModel.isShowBottomLine = true
       // pageStyleModel.isNeedMask = true
        
        //4.创建pageView
        let pageView = LZBPageView(frame: pageFrame, titles: titles, pageStyle: pageStyleModel, childVcs: childvcs, parentVc: self)
        
        view.addSubview(pageView)
        
    }

   

}

