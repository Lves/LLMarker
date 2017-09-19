//
//  TabAViewController.swift
//  GrowingIODemo
//
//  Created by Pintec on 19/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

class MKOrderViewModel: NSObject {
    var name: String?
    var code: String?
    var value: String?
    var isSelect: Bool = false
}


class TabAViewController: MyTableViewController {
    private struct InnerConst {
        static let CellID = "MKOrderTableViewCell"
    }
    var data: [MKOrderViewModel]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setEditing(true, animated: false)
        tableView.allowsSelectionDuringEditing = true

        tableView.tableFooterView = UIView()
        
        
        data = []
        for index in 0..<10 {
            let model = MKOrderViewModel()
            model.name = "Cell" + "\(index)"
            model.code = String(index + 1000)
            model.value = "\(10000)"
            data?.append(model)
        }
        tableView.reloadData()
    }

    // MARK: -  delegate
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        super.tableView(tableView, didSelectRowAt: indexPath)
////        let model = self.data?[indexPath.row] ?? MKOrderViewModel()
////        model.isSelect = !model.isSelect
////        tableView.reloadRows(at: [indexPath], with: .fade)
//    }
    //在编辑状态，可以拖动设置cell位置
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath != destinationIndexPath {
            //获取移动行对应的值
            if let model = data?[sourceIndexPath.row] {
                //删除移动的值
                data?.remove(at: sourceIndexPath.row)
                //如果移动区域大于现有行数，直接在最后添加移动的值
                if sourceIndexPath.row > (data?.count ?? 0) {
                    data?.append(model)
                } else {
                    //没有超过最大行数，则在目标位置添加刚才删除的值
                    data?.insert(model, at: destinationIndexPath.row)
                }
            }
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InnerConst.CellID) as? MKOrderTableViewCell else { return UITableViewCell() }
        cell.model = self.data?[indexPath.row] ?? MKOrderViewModel()
//        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : UIColor.gray
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
    
    


}
