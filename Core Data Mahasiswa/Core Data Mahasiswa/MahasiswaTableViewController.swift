//
//  MahasiswaTableViewController.swift
//  Core Data Mahasiswa
//
//  Created by Mac n Cheese on 17/07/21.
//

import UIKit
import CoreData

class MahasiswaTableViewController: UITableViewController {

    @IBOutlet weak var searchMahasiswa: UISearchBar!
    
    var mahasiswa = [Mahasiswa]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchMahasiswa.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    func getData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Mahasiswa")
        
        do {
            let result = try context.fetch(fetchRequest)
            mahasiswa = result as! [Mahasiswa]
            tableView.reloadData()
        } catch{
            print(error)
        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mahasiswa.count    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataMahasiswa = mahasiswa[indexPath.row]
        var cell : MahasiswaTableViewCell? = nil
        
        if dataMahasiswa.jenisKelamin == "Pria" {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellPria", for: indexPath) as?
            MahasiswaTableViewCell
        }
        if dataMahasiswa.jenisKelamin == "Wanita" {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellWanita", for: indexPath) as?
            MahasiswaTableViewCell
        }
        
        cell?.lblNim.text = String(dataMahasiswa.nim)
        cell?.lblNama.text = dataMahasiswa.nama
        

        // Configure the cell...

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130 
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, handler) in
            self.showAlertDelete(indexpath: indexPath)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            self.performSegue(withIdentifier: "EditAction", sender: indexPath)
        }
        
        edit.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        edit.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [edit,delete])
    }
    
    func showAlertDelete(indexpath : IndexPath){
        
        let alert = UIAlertController (title: "Konfirmasi", message: "Anda Yakin Menghapus Data ini?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Hapus", style: .destructive) { (UIAlertAction) in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let dataMahasiswa = self.mahasiswa[indexpath.row]
            
            context.delete(dataMahasiswa)
            
            do {
                try context.save()
            }catch{
                print(error)
            }
            self.getData()
            
        }
        let cancel = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailMahasiswa", sender: indexPath)
    }
    
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditAction"{
            if let tujuan = segue.destination as? ViewController{
                
                let index = sender as!IndexPath
                let dataMahasiswa = self.mahasiswa[index.row]
                
                tujuan.mahasiswa = dataMahasiswa
            }
        }
        else if segue.identifier == "DetailMahasiswa"{
            if let tujuan = segue.destination as? DetailViewController{
                
                let index  = sender as! IndexPath
                let dataMahasiswa = self.mahasiswa[index.row]
                
                tujuan.detailMahasiswa = dataMahasiswa
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "EditAction"{
            return false
        }
        else if identifier == "DetailMahasiswa"{
            return false
        }
        return true
    }
    

}

extension MahasiswaTableViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Mahasiswa")
        
        if searchText != ""{
            fetchRequest.predicate = NSPredicate(format: "nama LIKE[c] %@", searchText+"*")
        }
        do {
            let result = try context.fetch(fetchRequest)
            mahasiswa = result as! [Mahasiswa]
            tableView.reloadData()
        } catch{
            print(error)
        }
    }
    
}
