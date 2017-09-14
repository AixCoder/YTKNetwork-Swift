//
//  NetworkAgent.swift
//  YTKNetwork-Swift
//
//  Created by liuhongnian on 9/8/17.
//  Copyright © 2017 liuhongnian. All rights reserved.
//

import UIKit

class NetworkAgent: NSObject {

    static let sharedAgent = NetworkAgent.init()
    
    private var manager: SessionManager
    private var requestsRecord: [NSNumber : BaseNetworkRequest]
    private let requestRecordQueue: DispatchQueue
    private override init() {
        
        manager = SessionManager.default
        self.requestsRecord = Dictionary()
        
        requestRecordQueue = DispatchQueue(label:"com.swift3.record_request.queue", attributes: .concurrent)
        
        super.init()
    }
    
    func add(request: BaseNetworkRequest) {
        
        //生成sessionTask
        let task = self.sessionTaskFor(request: request)
        request.requestTask = task;
        
        //设置优先级
        if ((request.requestTask?.priority) != nil) {
            switch request.requestPriority {
            case .YTKRequestPriorityHight:
                request.requestTask?.priority = URLSessionTask.highPriority
            case .YTKRequestPriorityLow:
                request.requestTask?.priority = URLSessionTask.lowPriority
            default:
                request.requestTask?.priority = URLSessionTask.defaultPriority
            }
        }
        
        //保存task
        self.recordRequest(request)
    }
    
    func remove(request: BaseNetworkRequest) {
        
    }
    
    private func sessionTaskFor(request: BaseNetworkRequest) -> URLSessionTask {
        
        let method = request.requestMethod()
        let url = request.requestUrl()
        let param = request.requestArgument()
        
        let af_request = self.requestFor(url,
                                         method: method,
                                         parameters: param!)
        
        return af_request.task!
        
    }
    
    private func requestFor(_ url: String,
                            method: BaseNetworkRequest.YTKRequestMethod,
                            parameters: [String :Any]) -> Request
    {
        var request: Request? = nil
        
        switch method {
        case .GET:
            //下载文件get
            //普通get
            request = manager.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).rejson
        case .POST:
            return manager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        case .HEAD:
            print()
        case .DELETE:
            print()
        case .PATCH:
            print()
        case .PUT:
            print()
            
        }

        
        return request!
    }
    
    private func recordRequest(_ request: BaseNetworkRequest) {
        
        requestRecordQueue.async(flags: .barrier) {
            self.requestsRecord[NSNumber.init(value: (request.requestTask?.taskIdentifier)!)] = request
        }
    }
    
}
