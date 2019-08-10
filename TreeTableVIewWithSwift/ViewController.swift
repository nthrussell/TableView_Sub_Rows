//
//  ViewController.swift
//  TreeTableVIewWithSwift
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Access to resources
        let plistpath = Bundle.main.path(forResource: "DataInof", ofType: "plist")!
        let data = NSMutableArray(contentsOfFile: plistpath)
        
        // Initialize the TreeNode array
        let nodes = TreeNodeHelper.sharedInstance.getSortedNodes(data!, defaultExpandLevel: 0)
        
        //Initialize a custom tableView
        let tableview: TreeTableView = TreeTableView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height-20), withData: nodes)
        self.view.addSubview(tableview)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

