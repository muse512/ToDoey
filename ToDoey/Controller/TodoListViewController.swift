//
//  TodoListViewCOntrollerViewController.swift
//  ToDoey
//
//  Created by Taylor Batch on 9/10/18.
//  Copyright © 2018 burgeoning. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

   
   var itemArray = [Item()]
   
   let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Itmes.plist")
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
      loadItems()
   }

   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return itemArray.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
      
      let item = itemArray[indexPath.row]
      
      cell.textLabel?.text = item.title
      
      cell.accessoryType = item.done ? .checkmark : .none
      
      return cell
   }
   
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     // print(itemArray[indexPath.row])
   
   itemArray[indexPath.row].done = !itemArray[indexPath.row].done
   
   saveItems()
   
   tableView.deselectRow(at: indexPath, animated: true)
   }

   //MARK:- Add new actions
   
   @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
      var textField = UITextField()
      
      let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
         
         let newItem = Item()
         newItem.title = textField.text!
         
         self.itemArray.append(newItem)
         self.saveItems()
      }
      alert.addTextField { (alertTextField) in
         alertTextField.placeholder = "Create item"
         print(alertTextField.text)
         textField = alertTextField
      }
      alert.addAction(action)
      
      self.present(alert, animated: true, completion: nil)
   }
   
   
   func saveItems() {
      let encoder = PropertyListEncoder()
      
      do{
         let data = try encoder.encode(itemArray)
         try data.write(to: dataFilePath!)
      } catch {
         print("Error encoding item \(error)")
      }
      
      self.tableView.reloadData()
      }
   
   func loadItems() {
      if let data = try? Data(contentsOf: dataFilePath!) {
         let decoder = PropertyListDecoder()
         do {
         itemArray = try decoder.decode([Item].self, from: data)
         } catch {
            print("Error \(error)")
         }
      }
   }

}

