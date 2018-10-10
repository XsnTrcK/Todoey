//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Alberto Ayala on 10/2/18.
//  Copyright © 2018 Alberto A Ayala. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let color = UIColor(hexString: "1D9BF6") else {fatalError("Could not create color from hex")}
        
        updateNavBar(withColor: color)
    }
    
    override func getObject(atIndexPath indexPath: IndexPath) -> Object? {
        return categories?[indexPath.row]
    }
    
    //MARK: - Table view Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequedCell = setDelegate(tableView, cellForRowAt: indexPath, withIdentifier: "CategoryCell")

        if let category = categories?[indexPath.row] {
            dequedCell.textLabel?.text = category.name
            let backgroundColor = UIColor(hexString: category.cellColor)!
            dequedCell.backgroundColor = backgroundColor
            dequedCell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
        } else {
            let backgroundColor = UIColor.randomFlat
            dequedCell.textLabel?.text = "No Categories Added Yet"
            dequedCell.backgroundColor = backgroundColor
            dequedCell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
        }
        
        return dequedCell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVc.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data manipulation methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let nameOfCategory = textField.text {
                let newCategory = Category()
                newCategory.name = nameOfCategory
                newCategory.cellColor = UIColor.randomFlat.hexValue()
                self.save(category: newCategory)
            }
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
}
