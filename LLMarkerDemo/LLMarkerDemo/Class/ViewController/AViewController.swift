//
//  AViewController.swift
//  GrowingIODemo
//
//  Created by lixingle on 2017/3/22.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class AViewController: BViewController {
    @IBOutlet weak var btnA: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "A"
        btnA.addTarget(self, action: #selector(buttonClickMethod), for: .touchUpInside)
        btnA.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        
        
    }
    

    
    func buttonClickMethod()  {
        print("")
    }
    
    func buttonClick()  {
        let alert = UIAlertController(title: "标题", message: "Hello world", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (sender) in
            print("使用printOK");
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (sender) in
            print("使用printCancel");
        }))
        self.present(alert, animated: true) { 
            
        }
    }
    

}
