//
//  AFNetManager.swift
//  LLMarkerDemo
//
//  Created by lixingle on 2017/4/5.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import AFNetworking

class AFNetManager: NSObject {
    
    
    func requestDic()  {
        let urlStr = "https://api.500px.com/v1/photos?page=1&rpp=20&feature=popular&include_store=store_download&include_states=votes&consumer_key=zWez4W3tU1uXHH0S5zAVYX0xAh6sm0kpIZpyF1K7"
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
