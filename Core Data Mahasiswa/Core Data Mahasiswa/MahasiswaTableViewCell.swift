//
//  MahasiswaTableViewCell.swift
//  Core Data Mahasiswa
//
//  Created by Mac n Cheese on 17/07/21.
//

import UIKit

class MahasiswaTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNama: UILabel!
    @IBOutlet weak var lblNim: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
