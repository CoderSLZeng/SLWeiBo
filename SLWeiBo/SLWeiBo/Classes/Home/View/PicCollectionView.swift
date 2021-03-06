//
//  PicCollectionView.swift
//  DS11WB
//
//  Created by Anthone on 17/3/14.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {
    
    // MARK:- 定义属性
    var picURLs : [URL] = [URL]() {
        didSet {
            self.reloadData()
        }
    }
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
    }
}


// MARK:- collectionView的数据源方法
extension PicCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        
        // 2.给cell设置数据
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PicCollectionView : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1.获取通知需要传递的参数
        let userInfo = [ShowPhotoBrowserIndexKey : indexPath, ShowPhotoBrowserUrlsKey : picURLs] as [String : Any]
        
        // 2.发出通知
        NotificationCenter.default.post(name: Notification.Name(rawValue: ShowPhotoBrowserNote), object: self, userInfo: userInfo)
    }
}

extension PicCollectionView : AnimatorPresentedDelegate {
    func startRect(_ indexPath: IndexPath) -> CGRect {
        // 1.获取cell
        let cell = self.cellForItem(at: indexPath)!
        
        // 2.获取cell的frame
        let startFrame = self.convert(cell.frame, to: UIApplication.shared.keyWindow!)
        
        return startFrame
    }
    
    func endRect(_ indexPath: IndexPath) -> CGRect {
        // 1.获取该位置的image对象
        let picURL = picURLs[indexPath.item]
        guard let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString) else
        {
            myLog("获取缓存图片失败")
            return CGRect.zero
        }
        
        // 2.计算结束后的frame
        let w = UIScreen.main.bounds.width
        let h = w / image.size.width * image.size.height
        var y : CGFloat = 0
        if h > UIScreen.main.bounds.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - h) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    func imageView(_ indexPath: IndexPath) -> UIImageView {
        // 1.创建UIImageView对象
        let imageView = UIImageView()
        
        // 2.获取该位置的image对象
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString)
        
        // 3.设置imageView的属性
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}



// MARK:- 配图的cell
class PicCollectionViewCell : UICollectionViewCell {
    // MARK:- 定义模型属性
    var picURL : URL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
                        
            iconView.sd_setImage(with: picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    // MARK:- 控件的属性
    @IBOutlet weak var iconView: UIImageView!
}






