//
//  ViewController.swift
//  LLMarkerDemo
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
        //圈选view
        LLMarkerChooseView.sharedInstance().addToWindow()
        
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
        
        let url = URL(string: "https://drscdn.500px.org/photo/228687165/q%3D50_w%3D140_h%3D140/v2?client_application_id=27875&webp=true&v=0&sig=cba698b00ca42283f2e44b75b3f4f268c46f9c7f659d3d27e062045cc9009b20")
        imageView.sd_setImage(with: url)
    }

    
    func tapLabel() {
        
        
        //1.0
        Alamofire.request("https://api.500px.com/v1/photos?page=1&rpp=20&feature=popular&include_store=store_download&include_states=votes&consumer_key=zWez4W3tU1uXHH0S5zAVYX0xAh6sm0kpIZpyF1K7",method:.post,parameters: ["testKey":"123","username":"lves"]).responseJSON { response in
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




