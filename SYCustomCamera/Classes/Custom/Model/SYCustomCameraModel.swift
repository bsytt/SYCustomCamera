//
//  SYCustomCameraModel.swift
//  SYTexDemo
//
//  Created by bsoshy on 2020/11/17.
//  Copyright © 2020 bsy. All rights reserved.
//

import UIKit

class SYCustomCameraModel: NSObject {

    var image :UIImage?
    var imageUrl : String?
    
    init(image:UIImage?=nil,imageUrl:String?=nil) {
        self.image = image
        self.imageUrl = imageUrl
    }
}
