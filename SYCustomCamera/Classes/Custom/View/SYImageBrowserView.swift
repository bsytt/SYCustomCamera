//
//  SYScrollView.swift
//  SYTexDemo
//
//  Created by bsoshy on 2020/11/19.
//  Copyright © 2020 bsy. All rights reserved.
//

import UIKit

class SYImageBrowserView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /// 当前显示的是第几张图片 && How many pictures of the currently displayed
    var indexImage: Int!
    /// 高清图片数组 && High-resolution image array
    var arrayImage = [UIImage]() {
        didSet {
            collectionView.reloadData()
            self.collectionView.contentOffset = CGPoint(x: (self.frame.size.width) *  CGFloat(self.indexImage), y: 0)
        }
    }

    /// 图片展示View && Pictures show the View
    var collectionView:UICollectionView!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SYImageBrowserView{
    
    func  creatUI(){
        self.backgroundColor = .black
        creatCollectionView()
    }
    
    func  creatCollectionView(){
        let fowLayout = UICollectionViewFlowLayout.init()
        fowLayout.minimumLineSpacing = 0;
        fowLayout.scrollDirection = .horizontal
        fowLayout.itemSize = CGSize(width: kScreenWidth,
                                        height: kScreenHeight)
        collectionView = UICollectionView.init(frame: CGRect(x: 0,
            y: 0,
            width: kScreenWidth,
            height: self.frame.height),collectionViewLayout: fowLayout)
        collectionView.allowsMultipleSelection = true
        collectionView.register(HJCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alpha = 1
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .black
        self.addSubview(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! HJCell
        let image = arrayImage[indexPath.row]
        cell.setBigImageTheSizeOfThe(image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let firstIndexPath = self.collectionView.indexPathsForVisibleItems.first
        indexImage = firstIndexPath?.row
    }
}

@objc(HJCell)
class HJCell: UICollectionViewCell,UIScrollViewDelegate,UIActionSheetDelegate {
    static let cellId = "HJCell"
    var BigImage: UIImageView!
    var BottomScroll: UIScrollView!
    var bottomView:UIView!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatUI(){
        BottomScroll = UIScrollView.init(frame: CGRect(x: 0,
            y: 0,
            width: kScreenWidth,
            height: kScreenHeight))
        BottomScroll.delegate = self
        BottomScroll.maximumZoomScale = 2.0;
        BottomScroll.minimumZoomScale = 1.0;
        BottomScroll.backgroundColor = .black
        BigImage = UIImageView.init()
        BigImage.isUserInteractionEnabled = true
        BottomScroll.addSubview(BigImage)
        self.addSubview(BottomScroll)
        let doubleTap = UITapGestureRecognizer.init(target: self,action: #selector(twoTouch(_:)))
        let longpressGesutre = UILongPressGestureRecognizer(target: self,action: #selector(handleLongpressGesture(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.require(toFail: longpressGesutre)
        BottomScroll.addGestureRecognizer(doubleTap)
        BottomScroll.addGestureRecognizer(longpressGesutre)
    }
    
    internal func setImageWithURL(image:UIImage){
        self.setBigImageTheSizeOfThe(image)
    }
    
    func setBigImageTheSizeOfThe(_ bImage:UIImage){
        self.BottomScroll.contentOffset = CGPoint.zero
        self.BottomScroll.contentSize = CGSize.zero
        self.BottomScroll.contentInset = UIEdgeInsets.zero
        self.BottomScroll.zoomScale = 1
        let heightS = (bImage.size.height)/(bImage.size.width)*self.BottomScroll.frame.size.width
        let widthS = (bImage.size.width)/(bImage.size.height)*heightS
        self.BigImage.frame = CGRect(x: 0, y: 0, width: widthS, height: heightS)
        self.BigImage.image = bImage
        if heightS > kScreenHeight {
            self.BottomScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.BottomScroll.contentSize = CGSize(width: widthS, height: heightS)
        }else{
            self.BottomScroll.contentInset = UIEdgeInsets(top: (self.BottomScroll.frame.size.height - heightS)/2, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc func twoTouch(_ sender: UITapGestureRecognizer){
        let touchPoint = sender.location(in: sender.view)
        let scroll =  sender.view as! UIScrollView
        let imageView = scroll.subviews[0]
        let zs = scroll.zoomScale
        UIView.animate(withDuration: 0.5, animations: {
            scroll.zoomScale = (zs == 1.0) ? 2.0 : 0.0
        })
        UIView.animate(withDuration: 0.5, animations: {
            if scroll.zoomScale==2.0{
                let rectHeight = (self.frame.size.height)/scroll.zoomScale
                let rectWidth = self.frame.size.width/scroll.zoomScale
                let rectX = touchPoint.x-rectWidth/2.0
                let rectY = touchPoint.y-rectHeight/2.0
                let zoomRect = CGRect(x: rectX, y: rectY, width: rectWidth, height: rectHeight)
                scroll.zoom(to: zoomRect, animated: false)
                if imageView.frame.size.height > kScreenHeight {
                    self.BottomScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                }else{
                    self.BottomScroll.contentInset = UIEdgeInsets(top: (self.BottomScroll.frame.size.height - (imageView.frame.size.height))/2, left: 0, bottom: 0, right: 0)
                }
            }else{
                if imageView.frame.size.height > kScreenHeight {
                    self.BottomScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                }else{
                    self.BottomScroll.contentInset = UIEdgeInsets(top: (self.BottomScroll.frame.size.height - (imageView.frame.size.height))/2, left: 0, bottom: 0, right: 0)
                }
            }
        })
    }
    
    @objc func handleLongpressGesture(_ sender : UILongPressGestureRecognizer){
        if (sender.state == .began) {
            let alertAction = UIAlertController(title: "保存图片到本地", message: nil, preferredStyle: .actionSheet)
            alertAction.addAction(UIAlertAction(title: "保存", style: .default, handler: { (action) in
                UIImageWriteToSavedPhotosAlbum(self.BigImage.image!,self,#selector(HJCell.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }))
            alertAction.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            }))
            self.viewController()?.present(alertAction, animated: true, completion: nil)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            let alertAction = UIAlertController(title: nil, message: "图片保存失败", preferredStyle: .alert)
            alertAction.addAction(UIAlertAction(title: "保存", style: .default, handler: { (action) in
            }))
            self.viewController()?.present(alertAction, animated: true, completion: nil)
            return
        }
        let alertAction = UIAlertController(title: nil, message: "图片保存成功", preferredStyle: .alert)
        alertAction.addAction(UIAlertAction(title: "保存", style: .default, handler: { (action) in
        }))
        self.viewController()?.present(alertAction, animated: true, completion: nil)
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtras"), object:nil,userInfo: ["state":true])
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews[0]
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let image = scrollView.subviews[0]
        if image.frame.size.height > kScreenHeight {
            UIView.animate(withDuration: 0.2, animations: {
                self.BottomScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            })
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.BottomScroll.contentInset = UIEdgeInsets(top: (self.BottomScroll.frame.size.height - image.frame.size.height)/2, left: 0, bottom: 0, right: 0)
            })
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtras"), object:nil,userInfo: ["state":false])
    }
    
    func indexPath() ->IndexPath {
        let collectionView = self.superCollectionView
        let indexPath = collectionView().indexPath(for: self)
        return indexPath!
    }
    
    func superCollectionView() ->UICollectionView{
        return self.findSuperViewWithClass(UICollectionView.classForCoder()) as! UICollectionView
    }
    
    func findSuperViewWithClass(_ superViewClass:AnyClass) ->UIView{
        var superView = self.superview
        var foundSuperView:UIView?
        while (superView != nil && foundSuperView == nil) {
            if ((superView?.isKind(of: superViewClass)) != nil) {
                foundSuperView = superView
            }else{
                superView = superView!.superview;
            }
        }
        return foundSuperView!
    }
}

/// Tools 工具类 && The Tools Tools
import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
    return l < r
    case (nil, _?):
    return true
    default:
    return false
    }
}
/// 动画时间 && Animation time
let animationTime = 0.5
