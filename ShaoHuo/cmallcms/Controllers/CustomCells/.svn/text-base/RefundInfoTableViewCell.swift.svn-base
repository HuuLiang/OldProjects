//
//  RefundInfoTableViewCell.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/26.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import SDWebImage
import SKPhotoBrowser

class RefundInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var createUserLabel: UILabel!
    
    @IBOutlet weak var refundStatusLabel: UILabel!
    
    @IBOutlet weak var refundAmountLabel: UILabel!
    
    @IBOutlet weak var refundReasonLabel: UILabel!
    
    @IBOutlet weak var refundSNLabel: UILabel!
    
    @IBOutlet weak var refundImageContainerView: UIView!
    
    @IBOutlet weak var refundImageContainerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionTopConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var remarkLabel: UILabel!
    
    var imageList: [String] = []
    
    let collectionViewCellIdentifier = "collectionViewCellIdentifier"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UICollectionViewCell.classForCoder(),
                                     forCellWithReuseIdentifier: collectionViewCellIdentifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var refundEntity: OrderRefundEntity?
    var createUser: String?
    
    func setRefundEntity(refundEntity: OrderRefundEntity, createUser: String) {
        self.refundEntity = refundEntity
        self.createUser = createUser
        
        self.createUserLabel.text = createUser
        
        var refundStatus: String = "退款申请中"
        
        switch refundEntity.status! {
        case REFUND_STATUS_ING:
            refundStatus = "退款申请中"
        case REFUND_STATUS_AGREE:
            refundStatus = "同意申请退款"
        case REFUND_STATUS_REFUSED:
            refundStatus = "申请被驳回"
        case REFUND_STATUS_CLOSED:
            refundStatus = "关闭退款申请"
        case REFUND_STATUS_SUCCESS:
            refundStatus = "退款完成"
        default:
            refundStatus = ""
        }
        
        self.refundStatusLabel.text = refundStatus
        
        let refund_amout = refundEntity.refund_amout ?? 0
        self.refundAmountLabel.text = String(format: "￥%.2f元", refund_amout*0.01)
        
        var refundReason: String = ""
        switch refundEntity.refund_reason! {
        case 1:
            refundReason = "拍错/不喜欢"
        case 2:
            refundReason = "未按时发货"
        default:
            refundReason = "其他"
        }
        self.refundReasonLabel.text = refundReason
        self.refundSNLabel.text = refundEntity.refund_sn ?? ""
        
        self.remarkLabel.text = refundEntity.remark ?? " "
        
        self.imageList = []
        
        if let proof_img1 = refundEntity.proof_img1 , proof_img1.length > 0 {
            imageList.append(proof_img1.replacingOccurrences(of: "http://", with: "https://"))
        }
        if let proof_img2 = refundEntity.proof_img2 , proof_img2.length > 0 {
            imageList.append(proof_img2.replacingOccurrences(of: "http://", with: "https://"))
        }
        if let proof_img3 = refundEntity.proof_img3 , proof_img3.length > 0 {
            imageList.append(proof_img3.replacingOccurrences(of: "http://", with: "https://"))
        }
        
        if imageList.count <= 0 {
            refundImageContainerView.isHidden = true
            refundImageContainerViewHeightConstraint.constant = 0
            collectionTopConstraint.constant = 0
        }
        else {
            refundImageContainerView.isHidden = false
            collectionTopConstraint.constant = 14
            self.collectionView.reloadData()
        }
    }
    
    func showPhotoBrowers(index: Int) {
        
        var photos: [SKPhoto] = []
        
        for item in imageList {
            let photo = SKPhoto.photoWithImageURL(item)
            photo.shouldCachePhotoURLImage = false
            photos.append(photo)
        }
        
        let browser = SKPhotoBrowser(photos: photos)
        browser.initializePageIndex(index)
        
        let appDelgate = UIApplication.shared.delegate as! AppDelegate
        appDelgate.window?.rootViewController?.present(browser, animated: true, completion: nil)
        
    }
}

extension RefundInfoTableViewCell : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier,
                                                      for: indexPath)
        
        let imageUrlString = imageList[indexPath.row]
        
        let imageView = cell.contentView.viewWithTag(33) as? UIImageView
        if imageView == nil {
            let tmpImageView = UIImageView(frame: CGRect(x: 0, y: 0, w: 60, h: 60))
            cell.contentView.addSubview(tmpImageView)
            tmpImageView.tag = 33
            
            tmpImageView.sd_setImage(with: URL(string: imageUrlString)!)
        }
        else {
            imageView!.sd_setImage(with: URL(string: imageUrlString)!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if imageList.count > 0 {
            self.showPhotoBrowers(index: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
}
