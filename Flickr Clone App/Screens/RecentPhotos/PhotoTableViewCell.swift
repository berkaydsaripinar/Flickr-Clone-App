//
//  PhotoTableViewCell.swift
//  Flickr Clone App
//
//  Created by BDS on 17.06.2023.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    @IBOutlet weak var ppImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ppImageView.layer.cornerRadius = 24.0
        // Initialization code
      
    }

   /* override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
