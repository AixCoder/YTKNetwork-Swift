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
    
    fileprivate var _response: HTTPURLResponse?
    var response: HTTPURLResponse {
        get{
            return _response!
        }
    }
    fileprivate var _responseData: Data?
    var responseData: Data {
        get{
            return _responseData!
        }
    }
    
    fileprivate var _responseString: String?
    var responseString: String {
        get{
            return _responseString!
        }
    }
    
    fileprivate var _responseObject: AnyObject?
    var responseObject: AnyObject{
        get{
            return _responseObject!
        }
    }
    
    fileprivate var _error: NSError?
    var error: NSError{
        get{
            return _error!
        }
    }
    
    var successCompletionBlock: YTKRequestCompletionBlock
    var failureCompletionBlock: YTKRequestCompletionBlock
    

    override init() {
        successCompletionBlock = {_ in }
        failureCompletionBlock = {_ in }
        
        self.requestTask = nil
        self._response = nil
        self._responseData = nil
        self._responseString = nil
        self._responseObject = nil
        self._error = nil
        super.init()
    }
    
    func start() {
        
        //通知外部请求即将开始喽
        NetworkAgent.sharedAgent.add(request: self)
        
    }
    
    func startWithCompletionBlockWithSuccess(success: @escaping YTKRequestCompletionBlock, failure: @escaping YTKRequestCompletionBlock)  -> Void {
        
        self.successCompletionBlock = success
        self.failureCompletionBlock = failure
        
        self.start()
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
    
    func requestHeaderFieldDictionary() -> Dictionary<String, String>? {
        return nil
    }
    
    func jsonValidator() -> Any? {
        return nil
    }
    
    
}

class ChangeValue {
    
    class func changeResponse(_ response: HTTPURLResponse, forRequest: BaseNetworkRequest) {
        forRequest._response = response
    }
    
    class func changeResponseData(_ data: Data, forRequest: BaseNetworkRequest) {
        forRequest._responseData = data
    }
    
    class func changeResponseString(_ str: String, forRequest: BaseNetworkRequest) {
        
        forRequest._responseString = str
    }
    
    class func changeResponseObject(_ obj: AnyObject, forRequest: BaseNetworkRequest) {
        forRequest._responseObject = obj
    }
}

