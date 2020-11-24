//
//  ViewController.swift
//  SYCustomCamera
//
//  Created by bsytt on 11/23/2020.
//  Copyright (c) 2020 bsytt. All rights reserved.
//

import UIKit
import SYCustomCamera

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        goCamera()
    }
    func goCamera(){
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let  cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = .camera
            //隐藏apple标准相机UI
            cameraPicker.showsCameraControls = false
            cameraPicker.cameraFlashMode = .off
            //自定义你想展示的view
            let backView = SYCustomCameraView(frame: self.view.bounds, cameraPicker: cameraPicker,maxCount: 3)
            backView.chooseBlock = {[weak self] imageArr in
                print(imageArr)

            }
            cameraPicker.cameraOverlayView = backView
            self.present(cameraPicker, animated: true, completion: nil)
       } else {
            print("不支持拍照")
       }
   }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

