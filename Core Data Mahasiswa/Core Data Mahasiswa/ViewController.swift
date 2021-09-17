//
//  ViewController.swift
//  Core Data Mahasiswa
//
//  Created by Mac n Cheese on 17/07/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var tfNim: UITextField!
    @IBOutlet weak var tfNama: UITextField!
    @IBOutlet weak var tfAsal: UITextField!
    @IBOutlet weak var pvJenisKelamin: UIPickerView!
    @IBOutlet weak var pvJurusan: UIPickerView!
    @IBOutlet weak var swMembaca: UISwitch!
    @IBOutlet weak var swMenulis: UISwitch!
    @IBOutlet weak var swBercerita: UISwitch!
    
    var jenisKelaminPickerView = ["Pria", "Wanita"]
    var jurusanPickerView = ["Jurusan DKV", "Teknik Mesin", "Teknik Komputer", "terknik Sipil", "teknik Industri"]
    
    var mahasiswa : Mahasiswa? = nil
    var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pvJurusan.delegate = self
        pvJurusan.dataSource = self
        
        pvJenisKelamin.delegate = self
        pvJenisKelamin.dataSource = self
        
        if mahasiswa != nil {
            self.title = "Edit Data"
            showData()
        }
    }
    
    func showData(){
        
        tfNim.text = String(mahasiswa!.nim)
        tfNama.text = mahasiswa?.nama
        tfAsal.text = mahasiswa?.asal
        
        // ambil index jenis kelamin
        let indexJenisKelamin = jenisKelaminPickerView.firstIndex(of: (mahasiswa?.jenisKelamin)!)
        pvJenisKelamin.selectRow(indexJenisKelamin!, inComponent: 0, animated: true)
        
        // ambil index jurusan
        let indexJurusan = jurusanPickerView.firstIndex(of: (mahasiswa?.jurusan)!)
        pvJurusan.selectRow(indexJurusan!, inComponent: 0, animated: true)
        
        if ((mahasiswa?.hobi?.contains("Membaca")) != nil) {
            swMembaca.isOn = true
        }
        
        if ((mahasiswa?.hobi?.contains("Menulis")) != nil) {
            swMenulis.isOn = true
        }
        
        if ((mahasiswa?.hobi?.contains("Bercerita")) != nil) {
            swBercerita.isOn = true
        }
        
    }
    @IBAction func btnSave(_ sender: Any) {
        
        let nim = tfNim.text
        let nama = tfNama.text
        let asal = tfAsal.text
        let jenkel = jenisKelaminPickerView[pvJenisKelamin.selectedRow(inComponent: 0)]
        let jurus = jurusanPickerView[pvJurusan.selectedRow(inComponent: 0)]
        
        var hobi = [String]()
        if swMenulis.isOn {
            hobi.append("Menulis")
        }
        if swMembaca.isOn {
            hobi.append("Membaca")
        }
        if swBercerita.isOn {
            hobi.append("Bercerita")
        }
        let hobies = hobi.joined(separator: ",")
        
        if nim!.count == 0 || nama!.count == 0  || asal!.count == 0 || hobies.count == 0{
            showAlert(title: "info", message: "Tidak ada yang kosong")
        }
        else{
            saveToCoreData(nim: nim!, nama: nama!, asal: asal!, jenkel: jenkel, jurusan: jurus, hobi: hobies)
        }
    }
    
    func showAlert(title : String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        
    }
    
    func showAlertBack(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveToCoreData(nim : String, nama : String, asal : String, jenkel : String, jurusan : String, hobi : String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // jika nil, tambah data
        if mahasiswa == nil{
            self.title = "Edit Data"
            isEdit = true
            mahasiswa = Mahasiswa(context: context)
        }
        
        // set ke core data
        mahasiswa?.nim = Int32(nim)!
        mahasiswa?.nama = nama
        mahasiswa?.jenisKelamin = jenkel
        mahasiswa?.jurusan = jurusan
        mahasiswa?.hobi = hobi
        mahasiswa?.asal = asal
        
        do {
            try context.save()
        } catch {
            showAlert(title: "Error", message: error.localizedDescription)
        }
        
        if isEdit {
            showAlertBack(title: "Info", message: "Edit Data Berhasil")
        }
        else{
            showAlertBack(title: "Info", message: "Insert Data Berhasil")
        }

        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let tag = pickerView.tag
        
        if tag == 1 {
            return jenisKelaminPickerView.count
        }
        else{
            return jurusanPickerView.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let tag = pickerView.tag
        
        if tag == 1 {
            return jenisKelaminPickerView[row]
        }
        else{
            return jurusanPickerView[row]
        }
    }
    


}

