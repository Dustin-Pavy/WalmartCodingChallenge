//
//  CustomCell.swift
//  CodingChallengeWalmart
//
//  Created by Dustin Pavy on 8/23/23.
//
import UIKit

class CustomCell: UITableViewCell{
    
    @IBOutlet weak var nameAndRegion: UILabel!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var capital: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
