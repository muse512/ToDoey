//
//  TodoListViewCOntrollerViewController.swift
//  ToDoey
//
//  Created by Taylor Batch on 9/10/18.
//  Copyright © 2018 burgeoning. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

   
   var todoItems: Results<Item>?
   let realm = try! Realm()

   @IBOutlet weak var searchBar: UISearchBar!
   
   var selectedCategory : Category? {
      didSet{
         loadItems()
      }
   }
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      tableView.separatorStyle = .none
      
      
   }
   override func viewWillAppear(_ animated: Bool) {
      guard let colorHex = selectedCategory?.bgColor else { fatalError() }
         
      title = selectedCategory?.name
      
      updateNavBar(withHexcode: colorHex)
      
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      
      updateNavBar(withHexcode: "1D9BF6")
   }

   //MARK:- nav bar setup methods
   
   func updateNavBar(withHexcode colorHexcode: String) {
      
      guard let navBarColor = UIColor(hexString: colorHexcode) else { fatalError()}
      guard let navBar = navigationController?.navigationBar else {fatalError("no nav contrller")}
      navBar.barTintColor = navBarColor
      navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
      navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
      
      searchBar.barTintColor = navBarColor
      
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return todoItems?.count ?? 1
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
     let cell = super.tableView(tableView, cellForRowAt: indexPath)
      
      if let item = todoItems?[indexPath.row] {
         cell.textLabel?.text = item.title
         
         if let color = UIColor(hexString: selectedCategory!.bgColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
         cell.backgroundColor = color
         cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
         }
         
         cell.accessoryType = item.done ? .checkmark : .none
      } else {
         cell.textLabel?.text = "No Items"
      
      }
      
      return cell
   }
/////////////////////////////////////////////////////////////////
   
   //MARK:- TableView Delegate Methods
   
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
   if let item = todoItems?[indexPath.row] {
      do {
         //to delete data from realm object
        // try realm.delete(item)
         
         ////this is how you update data. inside the try { write the update }
      try realm.write {
         item.done = !item.done
         }
         } catch {
            print("Error \(error)")
         }
   }
   
   tableView.reloadData()
   
   tableView.deselectRow(at: indexPath, animated: true)
   }

   //MARK:- Add new actions
   
   @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
      var textField = UITextField()
      
      let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
         
        
         if let currentCategory = self.selectedCategory {
            do {
            try self.realm.write {
               let newItem = Item()
               newItem.title = textField.text!
               newItem.dateCreated = Date()
               currentCategory.items.append(newItem)
         }
            } catch {
               print("Error\(error)")
         }
         }
        self.tableView.reloadData()
      }
      
      
      alert.addTextField { (alertTextField) in
         alertTextField.placeholder = "Create item"
        print(alertTextField.text!)
         textField = alertTextField
      }
      alert.addAction(action)
      
      self.present(alert, animated: true, completion: nil)
   }
   
   func loadItems() {
      todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
      
      tableView.reloadData()
   }
   
   override func updateModel(at indexPath: IndexPath) {
      
      //calls from superclass
      //super.updateModel(at: indexPath)
      
      if let itemForDeletion = todoItems?[indexPath.row] {
         do {
            try self.realm.write {
               self.realm.delete(itemForDeletion)
            }
         } catch {
            print("ERROR \(error)")
         }
      }
   }
   
   
   

}

//////////////////
//MARK:- EXTENSIONS

extension TodoListViewController: UISearchBarDelegate {

   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      todoItems = todoItems?.filter("title CONTAINS %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
      
      tableView.reloadData()
   }

   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      if searchBar.text?.count == 0 {
         loadItems()

         DispatchQueue.main.async {
            searchBar.resignFirstResponder()
         }


      }
   }
}

