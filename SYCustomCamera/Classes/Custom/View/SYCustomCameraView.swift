//
//  SYCustomCameraView.swift
//  SYTexDemo
//
//  Created by bsoshy on 2020/11/17.
//  Copyright © 2020 bsy. All rights reserved.
//

import UIKit
import SnapKit

public typealias SYCustomCameraBlock = ([UIImage])->()

open class SYCustomCameraView: UIView {

    private var cameraPicker : UIImagePickerController!
    private let wHImage = 90
    private var isScroll : Bool = false

    //最多拍照数
    private var maxCount : Int!
    
    var dataSource = [UIImage]()
    public var chooseBlock : SYCustomCameraBlock?
    
    let showVC = SYCustomShowBigImageViewController()

    var isDismiss : Bool = false
    public init(frame: CGRect,cameraPicker:UIImagePickerController,maxCount:Int=3) {
        super.init(frame: frame)
        self.cameraPicker = cameraPicker
        self.maxCount = maxCount
        cameraPicker.delegate = self
        self.viewController()?.addChild(showVC)
        initSubview()
        NotificationCenter.default.addObserver(self, selector: #selector(showExtras(noti:)), name: NSNotification.Name(rawValue: "showExtras"), object: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubview() {
        self.addSubview(takePicBtn)
        self.addSubview(confirmBtn)
        self.addSubview(cancelBtn)
        self.addSubview(changeBtn)
        self.addSubview(imageCollection)
        self.addSubview(showVC.view)
        // 创建拖动手势对象
        let guesture = UIPanGestureRecognizer(target: self, action:#selector(drag(sender:)))
        guesture.delegate = self
        showVC.view.addGestureRecognizer(guesture)
        
        takePicBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.width.height.equalTo(80)
            if #available(iOS 11, *) {
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-30)
            }else {
                make.bottom.equalTo(self.snp.bottom).offset(-30)
            }
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.centerY.equalTo(takePicBtn.snp.centerY)
        }
        cancelBtn.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(25)
            }else {
                make.top.equalTo(self.snp.top).offset(25)
            }
            make.left.equalTo(15)
        }
        changeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            if #available(iOS 11, *) {
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(25)
            }else {
                make.top.equalTo(self.snp.top).offset(25)
            }
        }
        imageCollection.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.centerY.equalTo(takePicBtn.snp.centerY)
            make.width.height.equalTo(wHImage)
        }
        self.layoutIfNeeded()
        showVC.view.frame = CGRect(x: imageCollection.frame.minX, y: imageCollection.frame.minY, width: imageCollection.frame.width, height: imageCollection.frame.height)
        showVC.view.isHidden = true
        showVC.backBlock = {[weak self] in
            self?.hiddenView(true)
        }
        showVC.deleteBlock = {[weak self] images in
            if images.isEmpty {
                self?.hiddenView(false)
            }
            self?.dataSource.removeAll()
            self?.dataSource.append(contentsOf: images)
            self?.imageCollection.reloadData()
        }
    }
    func hiddenView(_ isChange:Bool) {
        if isChange {
            self.dataSource.removeAll()
            self.dataSource.append(contentsOf: self.showVC.dataSource)
            self.imageCollection.reloadData()
        }
        UIView.animate(withDuration: 0.3) {
            self.showVC.view.center = CGPoint(x: self.imageCollection.frame.midX, y: self.imageCollection.frame.midY)
            self.showVC.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } completion: { (finish) in
            if finish {
                self.showVC.view.isHidden = true
            }
        }
    }
    //拍照
    @objc func takePicBtnClick() {
        if self.maxCount > self.dataSource.count {
            self.cameraPicker.takePicture()
        }else {
            print("最多可以拍\(maxCount!)张")
            let alertController = UIAlertController(title: "提示", message: "最多只可以拍\(dataSource.count)张", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                
            }))
            self.viewController()?.present(alertController, animated: true, completion: nil)
        }
    }
    
    //确定
    @objc func confirmBtnClick() {
        self.chooseBlock?(dataSource)
        self.viewController()?.dismiss(animated: true, completion: nil)
    }
    
    //取消
    @objc func cancelBtnClick() {
        self.viewController()?.dismiss(animated: true, completion: nil)
    }
    
    //切换前后相机
    @objc func changeBtnClick() {
        if cameraPicker.cameraDevice == .rear {
            cameraPicker.cameraDevice = .front
        }else {
            cameraPicker.cameraDevice = .rear
        }
    }
    @objc func showExtras(noti:Notification) {
        let state = noti.userInfo?["state"] as! Bool
        self.isScroll = state
    }
    //绑定的事件
    @objc func drag(sender:UIPanGestureRecognizer){
        if isScroll {
            return
        }
        let locationPoint = sender.location(in: self)
        let translation : CGPoint = sender.translation(in: showVC.view)
        let absX = abs(translation.x)
        let absY = abs(translation.y)
         if sender.state == UIGestureRecognizer.State.recognized {
            print("recognized")
         }
         if sender.state == UIGestureRecognizer.State.began {
            print("began")
         }
         if sender.state == UIGestureRecognizer.State.changed {
            if (absX > absY ) {
            } else if (absY > absX) {
                self.isDismiss = true
                var scr = 1-absY/kScreenHeight
                if 1-absY/kScreenHeight <= 0.5 {
                    scr = 0.5
                }
                UIView.animate(withDuration: 0.2) {
                    self.showVC.view.transform = CGAffineTransform(scaleX: scr, y: scr)
                    self.showVC.view.center = CGPoint(x: locationPoint.x, y: locationPoint.y)
                }
            }
         }
         if sender.state == UIGestureRecognizer.State.cancelled {
            print("cancelled")
         }
         if sender.state == UIGestureRecognizer.State.ended {
            if (absX > absY ) {
                if isDismiss {
                    if locationPoint.y < kScreenHeight/3*2 {
                        UIView.animate(withDuration: 0.3) {
                            self.showVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                        } completion: { (finish) in
                        }
                        self.isDismiss = false
                        showVC.view.center = CGPoint(x: self.frame.midX, y: self.frame.midY)
                    }else {
                        self.hiddenView(true)
                    }
                }
            } else if (absY > absX) {
                if locationPoint.y < kScreenHeight/3*2 {
                    UIView.animate(withDuration: 0.3) {
                        self.showVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                    } completion: { (finish) in
                    }
                    showVC.view.center = CGPoint(x: self.frame.midX, y: self.frame.midY)
                }else {
                    self.showVC.view.center = CGPoint(x: locationPoint.x, y: locationPoint.y)
                    self.hiddenView(true)
                }
            }
         }
    }
    func getImage(imageName:String) ->UIImage? {
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "SYCustomCamera", ofType: "bundle")
        let bundles = Bundle(path: path!)
        let image = UIImage(named: imageName, in: bundles, compatibleWith: nil)
        return image
    }
    lazy var takePicBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let image = getImage(imageName: "takephoto")
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(takePicBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("确定", for: .normal)
        btn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("取消", for: .normal)
        btn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var changeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let image = getImage(imageName: "icon_fankui")
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(changeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var imageCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.register(SYCustomCameraImageShowItemCell.classForCoder(), forCellWithReuseIdentifier: "SYCustomCameraImageShowItemCell")
        collectionView.layer.cornerRadius = 5
//        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
}

extension SYCustomCameraView : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("获得照片============= \(info)")
        let image : UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //显示设置的照片
        self.dataSource.append(image)
        self.imageCollection.reloadData()
        self.imageCollection.scrollToItem(at: IndexPath(item: self.dataSource.count-1, section: 0), at: .right, animated: true)
    }
}

extension SYCustomCameraView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SYCustomCameraImageShowItemCell", for: indexPath) as! SYCustomCameraImageShowItemCell
        cell.imgV.image = dataSource[indexPath.item]
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showVC.dataSource = dataSource
        showVC.index = indexPath.item
        showVC.view.isHidden = false
        let finalFrame = self.frame
        let xScale = CGRect.zero.width/imageCollection.frame.width
        let yScale = CGRect.zero.height/imageCollection.frame.height
        showVC.view.transform = CGAffineTransform(scaleX: xScale, y: yScale)
        showVC.view.center = CGPoint(x: imageCollection.frame.midX, y: imageCollection.frame.midY)
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.showVC.view.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            self.showVC.view.transform = .identity
            self.showVC.view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        }) { (finished) -> Void in
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: wHImage, height: wHImage)
    }
}

extension SYCustomCameraView:UIGestureRecognizerDelegate{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.view!.isKind(of: UIScrollView.classForCoder())) {
            return false
        }
        return true
    }
}
