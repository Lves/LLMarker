//
//  TabBViewController.swift
//  GrowingIODemo
//
//  Created by Pintec on 19/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import MJRefresh
class TabBViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]  in
            sleep(2)
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.reloadData()
        })
        tableView.mj_header.beginRefreshing()
        // Do any additional setup after loading the view.
    }
    
    // MARK: -  delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DemoTableViewCell.getCell(tableView: tableView)
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 10))
        view.backgroundColor  = UIColor.gray
        return view
    }
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }


}
