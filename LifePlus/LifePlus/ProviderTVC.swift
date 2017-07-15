//
//  ProvidertVCTableViewCell.swift
//  LifePlus
//
//  Created by Javu on 6/28/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit

class ProviderTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //Merchant images.

    @IBOutlet weak var collectionView: UICollectionView!
    var images: [String]?
    var corr: CGFloat = 0.0
    var timer: Timer?

    var merchant: Merchant! {
        didSet{
            self.images = merchant.Image
            //self.collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate    = self
        self.collectionView.dataSource  = self

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionView.bounces = true
        // self.startTime()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    @IBAction func leftButtonTapped(_ sender: Any) {
        self.scrollNextImage()
        print("leftButtonTapped!!!")
    }


    @IBAction func rightButtonTapped(_ sender: Any) {
        self.scrollBackImage()
        print("rightButtonTapped!!!")
    }


    func scrollNextImage() {


    }


    func scrollBackImage() {

    }


//    func startTime() {
//        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.scrollAuto), userInfo: nil, repeats: true)
//    }
//
//
//    func scrollAuto() {
//        let cellSize = CGSize(width: self.collectionView.bounds.size.width / 3.0 , height: self.collectionView.bounds.size.height / 3.0)
//        self.corr = (self.collectionView.contentOffset.x) + CGFloat(cellSize.width)
//        if self.images != nil {
//            if corr == (cellSize.width * CGFloat((self.images?.count)!)) {
//                corr = 0
//            }
//            self.collectionView.scrollRectToVisible(CGRect(x: corr, y: 0, width: cellSize.width, height: cellSize.height), animated: true)
//        }
//    }


    //MARK: #UICollection Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.images != nil {
            return (self.images?.count)!
        }
        else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let image = cell.viewWithTag(1) as! UIImageView
        image.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        image.sd_setImage(with: URL(string: (self.images?[indexPath.row])!), placeholderImage: UIImage(named: "defaultImage"))
        return cell
    }

    //MARK: #UICollection View Delegate Flow Layout.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availabelWidth = self.collectionView.bounds.size.width - 2
        let imageWidth      = availabelWidth / 3
        return CGSize(width: imageWidth, height: imageWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
