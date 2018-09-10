//
//  TodoListViewCOntrollerViewController.swift
//  ToDoey
//
//  Created by Taylor Batch on 9/10/18.
//  Copyright © 2018 burgeoning. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

   
   var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }

   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return itemArray.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
      cell.textLabel?.text = itemArray[indexPath.row]
      
      return cell
   }
   
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     // print(itemArray[indexPath.row])
   
   if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
   } else {
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
   }
   
   tableView.deselectRow(at: indexPath, animated: true)
   }

   //MARK:- Add new actions
   
   @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
      var textField = UITextField()
      
      let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
         self.itemArray.append(textField.text!)
         
         self.tableView.reloadData()
      }
      
      alert.addTextField { (alertTextField) in
         alertTextField.placeholder = "Create item"
         print(alertTextField.text)
         textField = alertTextField
      }
      alert.addAction(action)
      
      present(alert, animated: true, completion: nil)
   }
   
}

