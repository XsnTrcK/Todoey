//
//  ViewController.swift
//  Todoey
//
//  Created by Alberto Ayala on 9/25/18.
//  Copyright © 2018 Alberto A Ayala. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    var todoItems : Results<Item>?
    
    lazy var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search \(selectedCategory?.name ?? "")"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let color = UIColor(hexString: selectedCategory?.cellColor ?? "") else {fatalError("Could not get hex color from category")}
        
        title = selectedCategory!.name
        
        updateNavBar(withColor: color)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let color = UIColor(hexString: "1D9BF6") else {fatalError("Could not create color from hex")}
        
        updateNavBar(withColor: color)
    }
        
    override func getObject(atIndexPath indexPath: IndexPath) -> Object? {
        return todoItems?[indexPath.row]
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setDelegate(tableView, cellForRowAt: indexPath, withIdentifier: "TodoItemCell")
        
        if let item = todoItems?[indexPath.row] {
            if let backgroundColor = UIColor(hexString: selectedCategory!.cellColor)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)) {
                cell.textLabel?.text = item.title
                cell.accessoryType = item.done ? .checkmark : .none
                cell.backgroundColor = backgroundColor
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
            }
        } else {
            if let backgroundColor = UIColor(hexString: selectedCategory!.cellColor){
                cell.textLabel?.text = "No Items Available"
                cell.backgroundColor = backgroundColor
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
            }
        }
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating item, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks add item button on our UIAlert
            
            if let newItem = textField.text, let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = newItem
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                    }
                } catch {
                    print("Error adding item, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}

//MARK: - Search bar methods
extension TodoListViewController : UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        if searchText.count == 0 {return}
        todoItems = selectedCategory?.items.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            searchController.isActive = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadItems()
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }

}

