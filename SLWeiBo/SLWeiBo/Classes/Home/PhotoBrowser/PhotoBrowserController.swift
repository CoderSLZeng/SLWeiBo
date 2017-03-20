//
//  PhotoBrowserController.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/18.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

private let PhotoBrowserCell = "PhotoBrowserCell"

class PhotoBrowserController: UIViewController {
    
    // MARK:- 定义属性
    var indexPath : NSIndexPath
    var picURLs : [NSURL]
    
    // MARK:- 懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    private lazy var closeBtn : UIButton = UIButton(bgColor: UIColor.darkGrayColor(), fontSize: 14, title: "关 闭")
    private lazy var saveBtn : UIButton = UIButton(bgColor: UIColor.darkGrayColor(), fontSize: 14, title: "保 存")
    
    // MARK:- 自定义构造函数
    init(indexPath : NSIndexPath, picURLs : [NSURL]) {
        self.indexPath = indexPath
        self.picURLs = picURLs
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 系统回调函数
    
    override func loadView() {
        super.loadView()
        
        view.bounds.size.width += 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置UI界面
        setupUI()
        
        // 2.滚动到对应的图片
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
    }
}


// MARK:- 设置UI界面内容
extension PhotoBrowserController {
    private func setupUI() {
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        // 2.设置frame
        collectionView.frame = view.bounds
        closeBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-20)
            make.bottom.equalTo(closeBtn.snp_bottom)
            make.size.equalTo(closeBtn.snp_size)
        }
        
        // 3.设置collectionView的属性
        collectionView.registerClass(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        collectionView.dataSource = self
        
        // 4.监听两个按钮的点击
        closeBtn.addTarget(self, action: #selector(PhotoBrowserController.closeBtnClick), forControlEvents: .TouchUpInside)
        saveBtn.addTarget(self, action: #selector(PhotoBrowserController.saveBtnClick), forControlEvents: .TouchUpInside)
    }
}

// MARK:- 事件监听函数
extension PhotoBrowserController {
    @objc private func closeBtnClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func saveBtnClick() {
        // 1.获取当前正在显示的image
        let cell = collectionView.visibleCells().first as! PhotoBrowserViewCell
        guard let image = cell.imageView.image else {
            return
        }
        
        // 2.将image对象保存相册
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(image : UIImage, didFinishSavingWithError error : NSError?, contextInfo : AnyObject) {
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存成功"
        }
        
        SVProgressHUD.showInfoWithStatus(showInfo)
    }

}


// MARK:- 实现collectionView的数据源方法
extension PhotoBrowserController : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCell, forIndexPath: indexPath) as! PhotoBrowserViewCell
        
        // 2.给cell设置数据
        cell.picURL = picURLs[indexPath.item]
        cell.delegate = self
        
        return cell
    }
}

// MARK:- PhotoBrowserViewCell的代理方法
extension PhotoBrowserController : PhotoBrowserViewCellDelegate {
    func imageViewClick() {
        closeBtnClick()
    }
}
// MARK:- 自定义流水布局
class PhotoBrowserCollectionViewLayout : UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        // 1.设置itemSize
        itemSize = collectionView!.frame.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .Horizontal
        
        // 2.设置collectionView的属性
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
