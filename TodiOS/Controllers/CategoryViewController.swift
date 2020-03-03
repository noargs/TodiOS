import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        tableView.separatorStyle = .none
    }
    
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = categories?[indexPath.row].name
            
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError() }
            
            cell.backgroundColor = categoryColour
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
        return cell

    }
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    
    
    //MARK: - Data Manipulation Methods
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    func loadCategory(){
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    
    
    //MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do {
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Unable to delete a row \(error)")
            }
        }
    }
    
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // Alert Controller with 'Title'
        let alert = UIAlertController(title: "Create a new category", message: "", preferredStyle: .alert)
        
        // Alert Action with 'Button'
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        }
        
        // adding 'Text field' between 'Title' and 'Button'
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil )
    }

    
}


