//
//  AANodeLabel.swift
//  AAKitDemo
//
//  Created by HuangPeng on 7/9/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit
import ObjectiveC

private var aaNodeTagKey = 0

extension UIView {
    var nodeTag: Int? {
        get {
            if let tag = objc_getAssociatedObject(self, &aaNodeTagKey) as? Int {
                return tag
            }
            return nil
        }
        set(newValue) {
            objc_setAssociatedObject(self, &aaNodeTagKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
