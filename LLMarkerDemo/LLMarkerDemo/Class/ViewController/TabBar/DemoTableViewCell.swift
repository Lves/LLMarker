//
//  DemoTableViewCell.swift
//  GrowingIODemo
//
//  Created by Pintec on 19/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

class DemoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    struct InnerConst {
        static let CellID = "DemoTableViewCell"
        static let NibName = "DemoTableViewCell"
    }
    class func getCell(tableView: UITableView) -> DemoTableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: InnerConst.CellID) as? DemoTableViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed(InnerConst.NibName, owner: nil, options: nil)![0] as? DemoTableViewCell
        }
        return cell!
    }

}
