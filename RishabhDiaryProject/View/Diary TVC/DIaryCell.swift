//
//  DIaryCell.swift
//  RishabhDiaryProject
//

//

import UIKit

class DIaryCell: UITableViewCell {
    @IBOutlet weak var date:UILabel!
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var body:UILabel!
    static let identifier:String = "DIaryCell"
    static func nib() -> UINib{
        return UINib(nibName: "DIaryCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
