//
//  ASTableVC.swift
//  AAKitDemo
//
//  Created by HuangPeng on 7/9/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit

class ASTableVC: UIViewController, ASTableDelegate, ASTableDataSource, AARefreshControllerDelegate, AAModelRefresherDelegate {
    let tableNode = ASTableNode()
    
    /// model, default: NIMutableTableViewModel
    var tableViewModel : NITableViewModel {
        get {
            if _tableViewModel == nil {
                _tableViewModel = NIMutableTableViewModel()
            }
            return _tableViewModel!
        }
        set(newValue) {
            _tableViewModel = newValue
        }
    }
    private var _tableViewModel: NITableViewModel? = nil
    
    // mutable table view model
    var mutableTableViewModel: NIMutableTableViewModel? {
        get {
            return tableViewModel as? NIMutableTableViewModel
        }
    }
    
    var refreshController: AARefreshController!
    var modelRefresher: AAModelRefresher!
    var modelViewUpdater: NIModelUpdater!

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableNode.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        tableNode.frame = view.frame
        tableNode.view.separatorStyle = .None
        tableNode.dataSource = self
        tableNode.delegate = self
        view.addSubnode(tableNode)
        
        refreshController = AARefreshController(scrollView: tableNode.view, delegate: self)
        modelRefresher = AAModelRefresher(refreshController: refreshController)
        modelRefresher.delegate = self
        modelViewUpdater = NIModelUpdater()
        modelViewUpdater.tableUpdater = ASTableUpdater(tableView: tableNode.view)
        modelViewUpdater.mutableTableViewModel = mutableTableViewModel
    }

    // MARK: - data source
    
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        return tableViewModel .objectAtIndexPath(indexPath) as! ASCellNode
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableViewModel.numberOfSectionsInTableView(tableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModel.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func beginFooterRefreshing() {
        
    }
    
    func beginHeaderRefreshing() {
        
    }
}

class ASTableUpdater : NSObject, AAModelViewUpdater {
    let tableView: ASTableView
    
    init(tableView: ASTableView) {
        self.tableView = tableView
        super.init()
    }
    
    func reloadWithObjects(objects: [AnyObject]!) {
        tableView.reloadData()
    }
    
    func appendObjects(objects: [AnyObject]!, withIndexPaths indexPaths: [AnyObject]!) {
        tableView.insertRowsAtIndexPaths(indexPaths as! [NSIndexPath], withRowAnimation: .None)
    }
    
    func insertSectionsAtIndexSet(indexSet: NSIndexSet!) -> NSIndexSet! {
        tableView.insertSections(indexSet, withRowAnimation: .Automatic)
        return indexSet
    }
    
    func insertObjects(objects: [AnyObject]!, atIndexPaths indexPaths: [AnyObject]!) -> [AnyObject]! {
        tableView.insertRowsAtIndexPaths(indexPaths as! [NSIndexPath], withRowAnimation: .None)
        return indexPaths
    }
    
    func deleteSectionsAtIndexSet(indexSet: NSIndexSet!) -> NSIndexSet! {
        tableView.deleteSections(indexSet, withRowAnimation: .Automatic)
        return indexSet
    }
    
    func deleteRowsAtIndexPaths(indexPaths: [AnyObject]!) -> [AnyObject]! {
        tableView.deleteRowsAtIndexPaths(indexPaths as![ NSIndexPath], withRowAnimation: .Automatic)
        return indexPaths
    }
    
}
