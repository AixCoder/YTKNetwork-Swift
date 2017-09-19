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
        let headers = request.requestHeaderFieldDictionary()
        let af_request = self.requestFor(url,
                                         method: method,
                                         httpHeaders: headers,
                                         parameters: param)
        
        return af_request.task!
        
    }
    
    private func requestFor(_ url: String,
                            method: BaseNetworkRequest.YTKRequestMethod,
                            httpHeaders: Dictionary<String, String>?,
                            parameters: [String :Any]?) -> Request
    {
        var request: Request? = nil
        
        switch method {
        case .GET:
            //下载文件get
            //普通get
            request = manager.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: httpHeaders).responseData(completionHandler: { [weak self] (responseData) in
                self?.handlerRequest(request!, responseData: responseData)
            })
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
    
    private func queryRequest(_ request: Request) -> BaseNetworkRequest? {
        var baseRequest = BaseNetworkRequest()
        
        requestRecordQueue.sync {
            baseRequest = self.requestsRecord[NSNumber.init(value: (request.task?.taskIdentifier)!)]!

        }
        return baseRequest
    }
    
    private func handlerRequest(_ request: Request, responseData: DataResponse<Data>) {
        
        if (responseData.error != nil) {
            //处理异常
        }
        
        //验证数据准确性
        
        //成功后的处理
        if self.queryRequest(request) != nil {
            let baseRequest: BaseNetworkRequest = self.queryRequest(request)!
            ChangeValue.changeResponse(responseData.response!, forRequest: baseRequest)
            
            ChangeValue.changeResponseData(responseData.data!, forRequest: baseRequest)
            //data to json or xml string
            let resString = String.init(data: responseData.data!, encoding: .utf8)
            ChangeValue.changeResponseString(resString!, forRequest: baseRequest)
            
            do {
                let json = try JSONSerialization.jsonObject(with: responseData.data!, options: [])
                ChangeValue.changeResponseObject(json as AnyObject, forRequest: baseRequest)

            } catch let error {
                print("解析数据失败")
            }
            
            //成功回调
            self.requestDidSuccessWithRequest(baseRequest)
        }
        
    }
    
    private func requestDidSuccessWithRequest(_ request: BaseNetworkRequest) {
        //尝试缓存请求结果
        
        //主线程回调
        DispatchQueue.main.async {
            request.successCompletionBlock(request)
        }
        
    }
}
