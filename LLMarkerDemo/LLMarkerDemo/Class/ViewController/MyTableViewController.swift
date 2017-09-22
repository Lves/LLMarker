//
//  MyTableViewController.swift
//  LLMarkerDemo
//
//  Created by lixingle on 2017/3/24.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import MJRefresh
class MyTableViewController: UITableViewController {
    var dataArray:[LLMarkerControl]?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.tableFooterView = UIView()
    
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]  in
            LLMarkerDBManager().ll_markerGetAllControlInfo({ (array) in
                self?.dataArray = array as? [LLMarkerControl]
            })
            self?.tableView.reloadData()
            self?.tableView.mj_header.endRefreshing()
        })
        tableView.mj_header.beginRefreshing()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "删除记录", style: .plain, target: self, action: #selector(deletePageInfo))
        
    }

    //MARK: - Action
    func deletePageInfo(){
        LLMarkerDBManager().ll_markerDeleteAllControl()
        LLMarkerDBManager().ll_markerGetAllControlInfo({[weak self] (array) in
            self?.dataArray = array as? [LLMarkerControl]
            self?.tableView.reloadData()
        })
//        dataArray = LLMarkerDBManager().ll_markerGetAllControlInfo() as? [LLMarkerControl]
//        tableView.reloadData()
    }
    
    
    
    // MARK: -  delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        print("%@","父类方法");
//        
////        let tabBVc = TabBViewController()
////        self.navigationController?.pushViewController(tabBVc, animated: true)
    }
    
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let control = dataArray?[indexPath.row];
        let str = "name: \(control?.name ?? "") \n标题:\(control?.title ?? "")  \n path：\(control?.path ?? "")"
        cell.textLabel?.text = str
        cell.textLabel?.numberOfLines = 0

        return cell
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 10))
        view.backgroundColor  = UIColor.gray
        return view
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //MARK: - scrollView
    
    
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("didScroll")
//    }
//    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndDecelerating")
//    }
//    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndScrollingAnimation")
//    }

}
