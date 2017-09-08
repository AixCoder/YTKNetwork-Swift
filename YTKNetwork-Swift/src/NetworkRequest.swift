//
//  NetworkRequest.swift
//  YTKNetwork-Swift
//
//  Created by liuhongnian on 9/8/17.
//  Copyright © 2017 liuhongnian. All rights reserved.
//

import UIKit

class NetworkRequest: BaseNetworkRequest {

    override func start() {
        
        //是否忽略缓存
        
        //有未完成的下载文件吗
        
        //尝试加载缓存
        self.startWithoutCache()
    }
    
    func startWithoutCache() {
        self.clearCacheVars()
        
        super.start()
    }
    
    func clearCacheVars() {
        
    }
}
