//
//  WebViewController.swift
//  LLMarkerDemo
//
//  Created by lixingle on 2017/4/5.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: URL(string: "https://www.baidu.com")!)
        webView.loadRequest(request)
        webView.delegate = self
    }



}
