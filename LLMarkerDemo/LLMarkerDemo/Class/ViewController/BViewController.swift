//
//  BViewController.swift
//  LLMarkerDemo
//
//  Created by lixingle on 2017/3/22.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

class BViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         title = "B"
        let bar = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(backItemClick(sender:)))
        navigationItem.setLeftBarButton(bar, animated: true)
    }
    
    func backItemClick(sender: AnyObject)  {
        
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        if self.navigationController?.viewControllers.index(of: self) == nil {
            
        }
        super.viewWillDisappear(animated)
    }

}
