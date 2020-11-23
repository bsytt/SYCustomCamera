//
//  SYCustomShowBigImageViewController.swift
//  SYTexDemo
//
//  Created by bsoshy on 2020/11/17.
//  Copyright © 2020 bsy. All rights reserved.
//

import UIKit

typealias SYCustomShowBigImageBackBlock = ()->()
class SYCustomShowBigImageViewController: UIViewController {

    var backBlock : SYCustomShowBigImageBackBlock?
    var deleteBlock : SYCustomCameraBlock?
    var dataSource = [UIImage]()

    var index : Int?{
        didSet {
            scrollView.indexImage = index
            scrollView.arrayImage = dataSource
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
    }
    
    func initSubview() {
        let nav = UIView(frame: .zero)
        nav.backgroundColor = .black
        self.view.addSubview(nav)
        nav.addSubview(backBtn)
        self.view.addSubview(stackView)
        self.view.addSubview(scrollView)
        nav.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(kNavBarHeight)
        }
        stackView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(kTabBarHeight)
        }
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(nav.snp.bottom).offset(-16)
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
        self.view.layoutIfNeeded()
    }
    
    lazy var scrollView: SYImageBrowserView = {
        let bview = SYImageBrowserView(frame: CGRect(x: 0, y: kNavBarHeight, width: kScreenWidth, height: kScreenHeight-kNavBarHeight-kTabBarHeight))
        return bview
    }()
   
    @objc func editBtnClick() {
        let image = dataSource[scrollView.indexImage]
        let cropController = CropViewController(croppingStyle: .default, image: image)
        cropController.delegate = self
        self.present(cropController, animated: true, completion: nil)
    }
    
    @objc func deleteBtnClick() {
        dataSource.remove(at: scrollView.indexImage)
        scrollView.arrayImage = dataSource
        if scrollView.indexImage > 0 {
            scrollView.indexImage = scrollView.indexImage - 1
        }
        self.deleteBlock?(dataSource)
    }
    
    @objc func backBtnClick() {
        self.backBlock?()
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [editBtn,deleteBtn])
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var editBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("编辑", for: .normal)
        btn.addTarget(self, action: #selector(editBtnClick), for: .touchUpInside)
        btn.backgroundColor = .black
        return btn
    }()
    
    lazy var deleteBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("删除", for: .normal)
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(deleteBtnClick), for: .touchUpInside)
        return btn
    }()

    lazy var backBtn: UIButton = {
        let btn = UIButton(type:.custom)
        btn.setTitle("返回", for:.normal)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        return btn
    }()
}

extension SYCustomShowBigImageViewController : CropViewControllerDelegate {

    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        self.dataSource[scrollView.indexImage] = image
        self.index = scrollView.indexImage
        cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,toView: UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)),toFrame: CGRect.zero,setup: {},completion: {
            self.scrollView.isHidden = false
        })
    }
}
