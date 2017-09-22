//
//  BaseTableViewController.swift
//  LLMarkerDemo
//
//  Created by lixingle on 2017/9/22.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
