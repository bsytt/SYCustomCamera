//
//  SYCustomCameraImageShowItemCell.swift
//  SYTexDemo
//
//  Created by bsoshy on 2020/11/17.
//  Copyright © 2020 bsy. All rights reserved.
//

import UIKit

class SYCustomCameraImageShowItemCell: UICollectionViewCell {

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
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imgV)
        imgV.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var imgV: UIImageView = {
        let img = UIImageView(frame: .zero)
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .red
        return img
    }()

}
