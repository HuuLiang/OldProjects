//
//  GuideViewController.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/31.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import EZSwiftExtensions

fileprivate class GuidViewCell: UICollectionViewCell {
    
    var imageView: UIImageView?
    var imageName: String? {
        didSet {
            self.imageView?.image = UIImage(named: imageName ?? "")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: self.bounds)
        imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.contentView.addSubview(imageView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class GuideViewController: UIViewController {
    
    var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configCollectionView()
    }
    
    lazy var imageList: [String]? = {
        if ez.screenHeight <= 480 {
            return ["4_1","4_2","4_3","4_4"]
        }
        else if ez.screenHeight <= 1136 {
            return ["5_1","5_2","5_3","5_4"]
        }
        else if ez.screenHeight <= 1334 {
            return ["6_1","6_2","6_3","6_4"]
        }
        return ["6p_1","6p_2","6p_3","6p_4"]
    }()
    
    func configCollectionView() -> Void {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = UIScreen.main.bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        self.collectionView = UICollectionView(frame: self.view.bounds,
                                               collectionViewLayout: flowLayout)
        self.view.addSubview(self.collectionView!)
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.backgroundColor = UIColor.white
        
        self.collectionView?.register(GuidViewCell.classForCoder(),
                                      forCellWithReuseIdentifier: GuidViewCell.className)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let index = scrollView.contentOffset.x / self.view.w
        
        log.info("index: \(index)")
    }

}
extension GuideViewController : UICollectionViewDataSource , UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuidViewCell.className, for: indexPath) as! GuidViewCell
        
        let imageName = self.imageList![indexPath.row]
        
        cell.imageName = imageName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.imageList!.count - 1 {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.showLoginViewController()
        }
    }
}

