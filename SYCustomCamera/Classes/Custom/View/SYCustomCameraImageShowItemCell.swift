//
//  SYCustomCameraImageShowItemCell.swift
//  SYTexDemo
//
//  Created by bsoshy on 2020/11/17.
//  Copyright © 2020 bsy. All rights reserved.
//

import UIKit

class SYCustomCameraImageShowItemCell: UICollectionViewCell {

    @IBOutlet weak var imgV: UIImageView!
    var model : SYCustomCameraModel?{
        didSet {
            guard let model = model else {
                return
            }
            if let image = model.image {
                imgV.image = image
            }
//            if let imageUrl = model.imageUrl {
//                imgV
//            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
