//
//  BaseNetworkRequest.swift
//  YTKNetwork-Swift
//
//  Created by liuhongnian on 9/8/17.
//  Copyright © 2017 liuhongnian. All rights reserved.
//

import UIKit

typealias YTKRequestCompletionBlock = (BaseNetworkRequest) -> ()

class BaseNetworkRequest: NSObject {

    private var successCompletionBlock: YTKRequestCompletionBlock
    private var failureCompletionBlock: YTKRequestCompletionBlock
    
    override init() {
        successCompletionBlock = {_ in }
        failureCompletionBlock = {_ in }
        
        super.init()
    }
    
    func start() {
        
        //通知外部请求即将开始喽
        NetworkAgent.sharedAgent
        
    }
    
    func startWithCompletionBlockWithSuccess(success: @escaping YTKRequestCompletionBlock, failure: @escaping YTKRequestCompletionBlock)  -> Void {
        
        self.successCompletionBlock = success
        self.failureCompletionBlock = failure
    }
    
    
}
