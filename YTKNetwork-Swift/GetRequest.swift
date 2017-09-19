//
//  GetRequest.swift
//  YTKNetwork-Swift
//
//  Created by liuhongnian on 9/19/17.
//  Copyright © 2017 liuhongnian. All rights reserved.
//

import UIKit

class GetRequest: NetworkRequest {
    
    override func requestUrl() -> String {
        return "https://httpbin.org/get"
    }
    
    override func requestMethod() -> BaseNetworkRequest.YTKRequestMethod {
        return .GET
    }
    
}
