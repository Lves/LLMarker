//
//  ViewController.swift
//  GrowingIODemo
//
//  Created by lixingle on 2017/3/22.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Alamofire
import SDWebImage

class ViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var textContent:String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel))
        lblTop.isUserInteractionEnabled = true
        lblTop.addGestureRecognizer(tap)
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(tapBgView(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapView)
        
        
        textField.reactive.textValues.observeValues { (text) in
            print("")
        }
        btnB.reactive.controlEvents(.touchUpInside).observeValues { (sender) in
            let tableVc = MyTableViewController()
            self.navigationController?.pushViewController(tableVc, animated: true)
        }
        
        
        SDWebImageManager.shared().imageCache?.clearMemory()
        SDWebImageManager.shared().imageCache?.clearDisk(onCompletion: nil)
        
        let url = URL(string: "https://dn-jm-public.qbox.me/94264e87-4fac-48cc-bfe6-9d1fdd786214")
        imageView.sd_setImage(with: url)
    }

    
    func tapLabel() {
        //http://jmbx-miracle-app.qa-02.jimu.com/appVersion/update/check?caller=14&appId=5&versionCode=8013301
        // http://jmbx-miracle-app.qa-02.jimu.com/loan/apply/v2/dict?caller=14
        
        
        //1.0
        Alamofire.request("http://jmbx-miracle-app.qa-02.jimu.com/loan/apply/v2/dict?caller=14",method:.post,parameters: ["testKey":"123","username":"lves"]).responseJSON { response in
//           print("123")
            
        }
        AFNetManager().requestDic()
        
//        let manager = LLSessionManger.sharedManager
//        manager.request("https://httpbin.org/get").responseJSON { (response) in
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
    }
    
    
    func tapBgView(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("")
    }


}




