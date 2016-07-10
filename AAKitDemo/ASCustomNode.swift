//
//  ASCustomNode.swift
//  AAKitDemo
//
//  Created by HuangPeng on 7/10/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit

class ASCustomViewCreater {
    
}

class ASCustomNode: ASDisplayNode {
    
    override init() {
        super.init { () -> UIView in
            return NIAttributedLabel()
        }
    }
    
    override init(viewBlock: ASDisplayNodeViewBlock, didLoadBlock: ASDisplayNodeDidLoadBlock?) {
        super.init(viewBlock: viewBlock, didLoadBlock: didLoadBlock)
    }
    
    let asd_viewCreator = ASCustomViewCreater()
    
    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        return CGSizeMake(100, 30)
    }
}
