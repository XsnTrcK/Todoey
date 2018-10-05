//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Alberto Ayala on 10/2/18.
//  Copyright © 2018 Alberto A Ayala. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    // Force unwrapping since we know it will be set on
    // viewDidLoad and available for the rest of the controller
    var realm: Realm!
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        
        loadCategories()
    }
    
    //MARK: - Table view Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequedCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        dequedCell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
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
