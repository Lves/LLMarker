//
//  AFNetManager.swift
//  GrowingIODemo
//
//  Created by lixingle on 2017/4/5.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import AFNetworking

class AFNetManager: NSObject {
    
    
    func requestDic()  {
        let urlStr = "http://jmbx-miracle-app.qa-02.jimu.com/loan/apply/v2/dict"
        let mutableRequest = AFJSONRequestSerializer().request(withMethod: "GET", urlString: urlStr, parameters: nil, error: nil)
        
        mutableRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        mutableRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        let manager = AFURLSessionManager(sessionConfiguration: LLMarkerURLProtocol.defaultSessionConfiguration())
        manager.responseSerializer = AFJSONResponseSerializer()
        
        manager.dataTask(with: mutableRequest as URLRequest) { (response, responseObject, error) in
            if error == nil {
                print("\(response) \(responseObject)")
            }else {
                print(" \(error)")
            }
            
        }.resume()
        
       
        
        
        
    }
    

}
