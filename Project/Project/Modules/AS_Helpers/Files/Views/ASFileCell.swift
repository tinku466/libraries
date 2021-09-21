//
//  ASFileCell.swift
//  ABBC
//
//  Created by Mr. X on 28/04/21.
//

import UIKit
import SDWebImage

class ASFileCell: UICollectionViewCell {
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnDelete.layer.cornerRadius = 17
        imgMain.layer.masksToBounds = true
        
    }

    
    //MARK:- LOADING
    
    /// Load the data into cell
    /// - Parameter file: ASMediaFile
    func load(file: ASMediaFile) {
        weak var weakSelf = self
        imgMain.layer.masksToBounds = true
        imgMain.layer.borderWidth = 0.0
        imgMain.contentMode = .scaleAspectFit
        
        btnDelete.isHidden = false
        lblTitle.isHidden = true
        ///
        /// Setup Image
        if let url = file.url, file.fileLocation == .web {
            imgMain?.sd_imageIndicator = SDWebImageActivityIndicator.white
            imgMain?.sd_setImage(with: url, completed: { (img, _, _, _) in
                if img == nil {
                    weakSelf?.imgMain?.image = #imageLiteral(resourceName: "common_file")
                }
            })
        } else {
            if file.mediaType == .image {
                imgMain.contentMode = .scaleAspectFill
                imgMain.image = file.image
            } else if file.mediaType == .file {
                imgMain.image = #imageLiteral(resourceName: "common_file")
                imgMain.contentMode = .center
            } else {
                imgMain.image = #imageLiteral(resourceName: "common_file")
                imgMain.contentMode = .center
            }
        }
    }
    
    /// Load the data into cell
    /// - Parameter file: ASMediaFile
    func loadPreview(file: ASMediaFile) {
        weak var weakSelf = self
        imgMain.layer.masksToBounds = true
        imgMain.layer.borderWidth = 1.0
        imgMain.contentMode = .scaleAspectFit
        imgMain.backgroundColor = .black
        
        lblTitle.text = file.title
        lblTitle.textColor = .white
        lblTitle.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        lblTitle.isHidden = false
        
        if file.mediaType == .image {
            imgMain.contentMode = .scaleAspectFill
            imgMain.image = file.image
            ///
            /// Setup Image
            if let url = file.url {
                imgMain?.sd_imageIndicator = SDWebImageActivityIndicator.white
                imgMain?.sd_setImage(with: url, completed: { (img, _, _, _) in
                    if img == nil {
                        weakSelf?.imgMain?.image = nil
                    }
                })
            } else {
                imgMain?.image = file.image
            }
            
        } else if file.mediaType == .file {
            imgMain.image = #imageLiteral(resourceName: "common_file")
            imgMain.contentMode = .center
        } else {
            imgMain.image = #imageLiteral(resourceName: "common_file")
            imgMain.contentMode = .center
        }
        btnDelete.isHidden = true
    }
    
    /// Load Add cell
    func loadAddCell() {
        imgMain.layer.masksToBounds = true
        imgMain.layer.borderWidth = 1.0
        imgMain.contentMode = .center
        imgMain.layer.borderColor = Color.border.cgColor
        
        imgMain.image = #imageLiteral(resourceName: "nav_add")
        imgMain.tintColor = Color.border
        btnDelete.isHidden = true
        lblTitle.isHidden = true
    }
    
}
