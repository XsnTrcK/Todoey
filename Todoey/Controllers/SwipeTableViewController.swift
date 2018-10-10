//
//  SwipTableViewController.swift
//  Todoey
//
//  Created by Alberto Ayala on 10/5/18.
//  Copyright © 2018 Alberto A Ayala. All rights reserved.
//

import Foundation
import SwipeCellKit
import RealmSwift
import ChameleonFramework

// Rename or move navbar functionality to another class
class SwipeTableViewController : UITableViewController, SwipeTableViewCellDelegate {
    // Force unwrapping since we know it will be set on
    // viewDidLoad and available for the rest of the controller
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setRealm()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    //MARK: - Nav Bar setup methods
    func updateNavBar(withColor color: UIColor) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        let textTintColor = ContrastColorOf(color, returnFlat: true)
        
        navBar.barTintColor = color
        navBar.tintColor = textTintColor
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: textTintColor]        
    }
    
    func setRealm() {
        realm = try! Realm()
    }
    
    func getObject(atIndexPath indexPath: IndexPath) -> Object? {
        preconditionFailure("Must be overriden by superclass")
    }
    
    func setDelegate(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withIdentifier identifier: String) -> UITableViewCell {
        let dequedCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SwipeTableViewCell
        dequedCell.delegate = self
        
        return dequedCell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("Realm Object Deleted")
            
            if let objectToDelete = self.getObject(atIndexPath: indexPath) {
                do {
                    try self.realm.write {
                        self.realm.delete(objectToDelete)
                    }
                } catch {
                    print("Unable to delete realm object, \(error)")
                }
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
