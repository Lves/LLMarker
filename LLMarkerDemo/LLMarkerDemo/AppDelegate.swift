//
//  AppDelegate.swift
//  LLMarkerDemo
//
//  Created by lixingle on 2017/9/19.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        LLMarker.sharedInstance().ll_markerStart()
        LLMarkerAlamofire.sharedMarkerAlamofire.ll_markerStart()
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if LLMarker.handle(url) {
            return true
        }
        return false
    }
}

