//
//  DetailViewController.swift
//  Core Data Mahasiswa
//
//  Created by Mac n Cheese on 18/07/21.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet weak var imgMahasiswa: UIImageView!
    @IBOutlet weak var lblNim: UILabel!
    @IBOutlet weak var lblNama: UILabel!
    @IBOutlet weak var lblAsal: UILabel!
    @IBOutlet weak var lblJurusan: UILabel!
    @IBOutlet weak var lblJenkel: UILabel!
    @IBOutlet weak var lblHobi: UILabel!
    
    var detailMahasiswa : Mahasiswa? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if detailMahasiswa?.jenisKelamin == "Pria" {
            imgMahasiswa.image = UIImage (named: "facebook male")
        }
        else{
            imgMahasiswa.image = UIImage (named: "facebook female")
        }
        
        lblNim.text = String(detailMahasiswa?.nim ?? 0)
        lblNama.text = detailMahasiswa?.nama
        lblAsal.text = detailMahasiswa?.asal
        lblJurusan.text = detailMahasiswa?.jurusan
        lblJenkel.text = detailMahasiswa?.jenisKelamin
        lblHobi.text = detailMahasiswa?.hobi

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
