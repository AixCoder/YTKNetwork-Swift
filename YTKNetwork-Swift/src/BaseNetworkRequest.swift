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

    enum YTKRequestMethod {
        case GET
        case POST
        case HEAD
        case PUT
        case DELETE
        case PATCH
    }
    
    enum YTKRequestPriority {
        case YTKRequestPriorityLow
        case YTKRequestPriorityDefault
        case YTKRequestPriorityHight
    }
    var requestPriority: YTKRequestPriority = .YTKRequestPriorityDefault

    var requestTask: URLSessionTask?
    
    var currentRequest: URLRequest{
        get{
            return requestTask!.currentRequest!
        }
    }
    var originalRequest: URLRequest{
        get{
            return requestTask!.originalRequest!
        }
    }
    
    open var response: HTTPURLResponse?
    
    open var responseData: NSData?
    
    open var responseString: String?
    
    open var responseObject: AnyObject?
    
    open var error: NSError?
    
    private var successCompletionBlock: YTKRequestCompletionBlock
    private var failureCompletionBlock: YTKRequestCompletionBlock
    

    override init() {
        successCompletionBlock = {_ in }
        failureCompletionBlock = {_ in }
        
        self.requestTask = nil
        self.response = nil
        self.responseData = nil
        self.responseString = nil
        self.responseObject = nil
        self.error = nil
        super.init()
    }
    
    func start() {
        
        //通知外部请求即将开始喽
        NetworkAgent.sharedAgent.add(request: self)
        
    }
    
    func startWithCompletionBlockWithSuccess(success: @escaping YTKRequestCompletionBlock, failure: @escaping YTKRequestCompletionBlock)  -> Void {
        
        self.successCompletionBlock = success
        self.failureCompletionBlock = failure
    }
    
    //MARK: 子类复写方法
    
    ///  The URL path of request. This should only contain the path part of URL, e.g., /v1/user. See alse `baseUrl`.
    func requestUrl() -> String {
        return ""
    }
    
    ///  Optional CDN URL for request.
    func cndUrl() -> String {
        return ""
    }
    ///  Requset timeout interval. Default is 60s.

    func requestTimeoutInterval() -> TimeInterval {
        return 60
    }
    
    func requestArgument() -> [String :Any]? {
        return nil
    }
    
    func requestMethod() -> YTKRequestMethod {
        return YTKRequestMethod.GET
    }
    
    func jsonValidator() -> Any? {
        return nil
    }
    
    
}
