//
//  AsyncDisplayKitDemo.swift
//  ComponentDemo
//
//  Created by HuangPeng on 7/7/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit

class AsyncDisplayKitDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()                

        let node = ASTextNode()
        let font = UIFont.systemFontOfSize(16)
        let color = UIColor.redColor()
        let attributes = [ NSFontAttributeName: font, NSForegroundColorAttributeName: color ]
        let text = "搭搭撒撒地方水电费顺丰速递发撒的方法的说法舒服点撒发生的甲基硫菌灵空间看就两节课鹿角领框架六角恐龙接口流量监控捡垃圾啊水电费撒旦发撒的发水电费点撒复的萨芬as大法师东方时代"
        node.attributedString = NSAttributedString(string: text, attributes: attributes)
        node.maximumNumberOfLines = 2
        
        let constrainedSize = CGSize(width: view.width, height: CGFloat.max)
        node.measure(constrainedSize)
        node.frame = CGRect(origin: CGPointMake(0, 100), size: node.calculatedSize)
        
        
        let xxx = NISizeOfAttributedStringConstrainedToSize(node.attributedString, constrainedSize, Int(node.maximumNumberOfLines))
        let bounds = node.attributedString?.boundingRectWithSize(constrainedSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        
        // self.view isn't a node, so we can only use it on the main thread
        //dispatch_async(dispatch_get_main_queue()) {
        view.addSubview(node.view)
        //}
        
        let label = UILabel()
        label.attributedText = node.attributedString
        var size = node.calculatedSize
        size.height = 39
        label.frame = CGRect(origin: CGPointMake(0, 200), size: size)
        label.numberOfLines = Int(node.maximumNumberOfLines)
        view.addSubview(label)
        
        let l = NIAttributedLabel(frame: CGRect(origin: CGPointMake(0, 300), size: constrainedSize))
        l.attributedText = node.attributedString
        l.numberOfLines = Int(node.maximumNumberOfLines)
        l.sizeToFit()
        l.top = 300
        view.addSubview(l)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
