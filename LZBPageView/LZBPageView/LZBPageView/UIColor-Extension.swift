//
//  UIColor-Extension.swift
//  LZBPageView
//
//  Created by zibin on 2017/5/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
extension UIColor {
    
    //类函数 class  func   func  函数
    class  func getRandomColor() ->UIColor
    {
        return UIColor(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1.0)
    }
    //特性：1、在extension扩展，必须使用convenience便利构造函数
    // 2.必须调用self.init,构造默认没有返回值，但是系统会自动返回但是不能返回nil
    convenience init(r : CGFloat , g : CGFloat, b : CGFloat, a : CGFloat = 1.0){
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    //颜色转换
    convenience init?(colorHexString : String) {
        //1.判断字符串长度是否大于6
        guard colorHexString.characters.count >= 6 else {
            return nil
        }
        //2.将字符串转化为大写
        var hextempString = colorHexString.uppercased()
        
        //3.判断字符串是否是颜色字符串
        if hextempString.hasPrefix("0X") || hextempString.hasPrefix("##"){
            hextempString = (hextempString as NSString).substring(to: 2)
        }
        
        //4.分离出rgb的十六进制
        var  range = NSRange(location: 0, length: 2)
        let rhex = (hextempString as NSString).substring(with: range)
        range.location = 2
        let ghex = (hextempString as NSString).substring(with: range)
        range.location = 4
        let bhex = (hextempString as NSString).substring(with: range)
        
        //5.scaner转化
        var  r : UInt32 = 0
        var  g : UInt32 = 0
        var  b : UInt32 = 0
        Scanner(string: rhex).scanHexInt32(&r)
        Scanner(string: ghex).scanHexInt32(&g)
        Scanner(string: bhex).scanHexInt32(&b)
        
        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
    }
    
    //获取颜色的RGB值
    func getRGBValue() -> (CGFloat , CGFloat , CGFloat){
        guard let components = self.cgColor.components else {
            fatalError("获取颜色的RGB值失败")
        }
        return (components[0] * 255,components[1] * 255,components[2] * 255)
    }
    
}
