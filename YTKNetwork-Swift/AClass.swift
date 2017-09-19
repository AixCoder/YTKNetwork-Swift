//
//  AClass.swift
//  YTKNetwork-Swift
//
//  Created by liuhongnian on 9/14/17.
//  Copyright © 2017 liuhongnian. All rights reserved.
//

import UIKit

class AClass: NSObject {
    let b: BClass
    override init() {
        b = BClass()

        super.init()
        b.a = self
    }
    
    deinit {
        print("A deinit")
    }
}

class BClass: NSObject {
    weak var a: AClass?
    override init() {
        a = nil
    }
    deinit {
        print("B deinit")
    }
}
