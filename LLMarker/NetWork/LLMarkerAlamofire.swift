//
//  LLMarkerAlamofire.swift
//  GrowingIODemo
//
//  Created by Pintec on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import Alamofire
class LLMarkerAlamofire: NSObject {
    struct LLConstant {
        static let kResponseLength:Int = 50;
    }
    
    
    static let sharedMarkerAlamofire = LLMarkerAlamofire()
    private override init() {
        startDates = [URLSessionTask: Date]()
    }
    private var startDates: [URLSessionTask: Date]
    deinit {
        ll_markerStopLogging()
    }
    public func ll_markerStart()  {
        //1.0 启动webview的请求
        LLMarkerURLProtocol.ll_markerStart()
        //2.0 添加Alamofire的通知
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(LLMarkerAlamofire.ll_markerNetworkRequestDidStart(notification:)),
            name: Notification.Name.Task.DidResume,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(LLMarkerAlamofire.ll_markerNetworkRequestDidComplete(notification:)),
            name: Notification.Name.Task.DidComplete,
            object: nil
        )
    }
    
    // MARK: - Private - Notifications
    @objc private func ll_markerNetworkRequestDidStart(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let task = userInfo[Notification.Key.Task] as? URLSessionTask
            else {
                return
        }
        startDates[task] = Date()
    }
    
    @objc private func ll_markerNetworkRequestDidComplete(notification: Notification) {
        guard let sessionDelegate = notification.object as? Alamofire.SessionDelegate,
            let userInfo = notification.userInfo,
            let task = userInfo[Notification.Key.Task] as? URLSessionTask,
            let request = task.originalRequest,
            let httpMethod = request.httpMethod,
            let requestURL = request.url
            else {
                return
        }
        
        var elapsedTime: TimeInterval = 0.0
        var startTime:Date?
        if let startDate = startDates[task] {
            elapsedTime = Date().timeIntervalSince(startDate)
            startTime = startDate
            startDates[task] = nil
        }
        var params:[String:String] = [:]
        if let httpBody = request.httpBody, let httpBodyString = String(data: httpBody, encoding: .utf8) {
            let paramStr:String? = httpBodyString //切割字符串 "testKey=123&username=lves"
            if let array = paramStr?.components(separatedBy: "&") {
                for str in array {
                    let paramA = str.components(separatedBy: "=")
                    if paramA.count == 2 {
                        params["\(paramA.first ?? "")"] = paramA.last
                    }
                }
            }
            
        }
        if let error = task.error {
            LLMarker.sharedInstance().ll_markerNetWorkingUrl(requestURL.absoluteString, params: params, method: httpMethod,header: request.allHTTPHeaderFields ?? [:], response: error.localizedDescription, createTime: (startTime?.timeIntervalSince1970 ?? 0), duration: elapsedTime)
        } else {
            guard (task.response as? HTTPURLResponse) != nil else {
                return
            }
            guard let data = sessionDelegate[task]?.delegate.data else { return }
            var responseString:String? //结果字符串
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                let responseDic = jsonObject as? [String:Any]
                
                if let code = responseDic?["statusCode"] {  //自己的服务器返回
                    //结果字典result
                    var result:[String : Any]? = ["code":code ,
                                                  "errorMessage":responseDic?["errorMessage"] as? String ?? ""]
                    if let dataDic = convertStringToDictionary(text: responseDic?["data"] as? String){
                        result?["data"] = ["status":dataDic["status"] ?? 0,"message":dataDic["message"] ?? ""]
                    }else if let inData = responseDic?["data"]{
                        result?["data"] = "\(inData)"
                    }
                    //dictionay 转字符串
                    let jsonData = try JSONSerialization.data(withJSONObject: result!, options: .prettyPrinted)
                    responseString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as String?
                }else {                                     //第三方服务器,只截取前50个
                    let responseStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    let length = min(responseStr?.length ?? 0, LLConstant.kResponseLength) //截取50
                    responseString = responseStr?.substring(to: length) as String?  ?? ""
                }
            } catch {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    let length = min(string.length, LLConstant.kResponseLength)
                    responseString = string.substring(to: length) as String
                }
            }
            LLMarker.sharedInstance().ll_markerNetWorkingUrl(requestURL.absoluteString, params: params, method: httpMethod,header: request.allHTTPHeaderFields ?? [:] , response: responseString, createTime: (startTime?.timeIntervalSince1970 ?? 0), duration: elapsedTime)
        }
    }
    public func ll_markerStopLogging() {
        NotificationCenter.default.removeObserver(self)
    }
    func convertStringToDictionary(text : String?) -> [String:Any]? {
        if let textData = text?.data(using: .utf8 ) {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: textData , options: .mutableContainers)
                return jsonObject as? [String:Any]
            }catch {
                return nil
            }
        }
        return nil
    }
    
}
///// 测试用
//class LLSessionManger: Alamofire.SessionManager{
//    public static let sharedManager: SessionManager = {
//        let configuration = LLMarkerURLProtocol.defaultSessionConfiguration()
//        configuration?.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
//        let manager = Alamofire.SessionManager(configuration: configuration!)
//        return manager
//    }()
//}



