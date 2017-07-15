//  ViewController.swift
//  LifePlus
//
//  Created by Javu on 6/5/17.
//  Copyright © 2017 Javu. All rights reserved.
//
import UIKit
import SDWebImage
import FBSDKLoginKit

class HomeVC: BaseTableVC {

    @IBOutlet weak var bannerView:              UIView!
    @IBOutlet weak var bannercollectionView:    UICollectionView!
    @IBOutlet weak var pageControl:             UIPageControl!

    var avatarButton: UIButton?

    //campaigns
    var foodCampaigns   = [Campaign]()
    var buyCampaigns    = [Campaign]()
    var placeCampaigns  = [Campaign]()
    var banners         = [Campaign]()

    var timer           = Timer()
    var qrButton        = UIButton()

    var segmentSelected = "food"
    var segmentSelectedIndex = 0
    var nextURLString: String?

    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate                 = self
        self.tableView.dataSource               = self
        self.bannercollectionView.delegate      = self
        self.bannercollectionView.dataSource    = self

        let nibTable        = UINib(nibName: "HomeTVC", bundle: nil)
        self.tableView.register(nibTable, forCellReuseIdentifier: "HomeTVC")

        let nibCollection   = UINib(nibName: "BannerCVC", bundle: nil)
        self.bannercollectionView.register(nibCollection, forCellWithReuseIdentifier: "BannerCVC")

        self.setupGUI()
        self.getBanners()
        self.setupGUI()
        self.showQRScanButton()

        self.addPullToRefresh()
        self.addLoadMore()
    }


    func showAvatarButton(){
        self.avatarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.avatarButton?.layer.cornerRadius = 10.0
        self.avatarButton?.clipsToBounds = true
        self.avatarButton?.addTarget(self, action: #selector(avatarButtonTapped), for: .touchUpInside)
        self.avatarButton?.showsTouchWhenHighlighted = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: avatarButton!)
    }


    func avatarButtonTapped() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        let storyboard  = UIStoryboard(name: "Login", bundle: nil)
        let controller  = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(controller, animated: false)
    }


    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.showNavigationBar(isWhite: false)
        self.getCampaigns(groupType: "food")
        self.showAvatarButton()
        self.user = User.currentUser()
        if self.user != nil {
            //Logined.
            if self.user?.Avatar != nil  && self.user?.Avatar != ""{
                self.avatarButton?.sd_setImage(with: URL(string: (self.user?.Avatar)!), for: .normal, placeholderImage: UIImage(named: "ic_login"))
            }
            else {
                self.avatarButton?.setBackgroundImage(UIImage(named: "ic_login"), for: .normal)
            }
        }
        else {
            //Not yet login.
            self.avatarButton?.setBackgroundImage(UIImage(named: "ic_login"), for: .normal)
        }

    }

    override func reloadData(reload: Bool) {
        if reload {
            // Pull to refresh
            self.getCampaigns(groupType: self.segmentSelected)
        }
        else{
            // Load more
            self.getCampaigns(groupType: self.segmentSelected, reload: false)
        }
    }

    func setupGUI() {
        //Scroll Horizontal for CollectionView (Banner).
        let layout              = UICollectionViewFlowLayout()
        layout.scrollDirection  = .horizontal
        self.bannercollectionView.setCollectionViewLayout(layout, animated: true)
        self.bannercollectionView.isPagingEnabled = true
        //Setup Page Control.
        self.pageControl.hidesForSinglePage             = true
        self.pageControl.isHidden                       = true
        self.createMenuButtons()
    }


    func createMenuButtons() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        menuButton.setBackgroundImage(UIImage(named: "menu"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        menuButton.showsTouchWhenHighlighted = true
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        logo.image = UIImage(named: "life+Logo")
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: menuButton), UIBarButtonItem(customView: logo)]
    }

    func menuButtonTapped() {
        print("menuButtonTapped")
    }


    func showQRScanButton() {
        self.qrButton = UIButton(frame: CGRect(x: self.view.bounds.size.width - 70.0, y: self.view.bounds.size.height - 170.0, width: 35.0, height: 35.0))
        self.qrButton.setBackgroundImage(UIImage(named: "ic_QR"), for: .normal)
        self.qrButton.addTarget(self, action: #selector(qrScanButtonTapped), for: .touchUpInside)
        self.qrButton.showsTouchWhenHighlighted = true
        self.view.addSubview(qrButton)
    }


    func qrScanButtonTapped() {
        print("qrScanButtonTapped")
    }


    func getCampaigns(groupType: String, reload: Bool = true) {
        if reload {
            APIManager.getCampaigns(groupType: groupType, size: 10, completion: { (sucess, campaigns, nextURL, error) in
                self.nextURLString = nextURL
                if error == nil {
                    switch groupType {
                    case "food":
                        self.foodCampaigns  = campaigns!
                        break
                    case "buy":
                        self.buyCampaigns   = campaigns!
                        break
                    default :
                        self.placeCampaigns = campaigns!
                        break
                    }
                }
                else {
                    print(error ?? "WTH???")
                }
                self.endRefresh()
            })
        } else {
            //Load more.
            if let nextURL = self.nextURLString {
                APIManager.getNextCampaigns(nextURL: nextURL, completion: { (success, campaigns, nextURL, error) in
                    if error == nil {
                        self.nextURLString = nextURL
                        switch groupType {
                        case "food":
                            self.foodCampaigns.append(contentsOf: campaigns!)
                            break
                        case "buy":
                            self.buyCampaigns.append(contentsOf: campaigns!)
                            break
                        default :
                            self.placeCampaigns.append(contentsOf: campaigns!)
                            break
                        }
                    }
                    else {
                        print("error???")
                    }

                    self.endRefresh()
                })
            }
            else {
                print("self.nextURLString = nil???")
                self.endRefresh(reloadData: false)
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func getBanners() {
        APIManager.getBanners(isFeature: true) { (success, banners, nextURL, error) in
            if error == nil {
                if let ban = banners {
                    self.banners = ban
                    self.bannercollectionView.reloadData()
                    self.pageControl.isHidden       = true
                    self.pageControl.numberOfPages  = self.banners.count
                    self.timer                      = Timer.scheduledTimer(timeInterval: 1,
                                                                           target: self,
                                                                           selector: #selector(self.scrollNextBanner),
                                                                           userInfo: nil,
                                                                           repeats: true)
                    self.endRefresh()
                }
            }
            else {
                self.endRefresh()
                self.showMessage(message: error ?? "WTH???")
            }
        }
    }


    func scrollNextBanner() {
        var bannerPage = self.pageControl.currentPage + 1
        if bannerPage == self.banners.count {
            bannerPage = 0
        }
        self.bannercollectionView.scrollToItem(at: IndexPath(item: bannerPage, section: 0), at: .right, animated: true)
    }

    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.segmentSelected {
        case "food":
            return self.foodCampaigns.count
        case "buy":
            return self.buyCampaigns.count
        case "place":
            return self.placeCampaigns.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC") as! HomeTVC
        switch self.segmentSelected {
        case "food":
            cell.campaign = self.foodCampaigns[indexPath.row]
        case "buy":
            cell.campaign = self.buyCampaigns[indexPath.row]
        case "place":
            cell.campaign = self.placeCampaigns[indexPath.row]
        default:
            break
        }
        return cell
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60.0
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("SectionHeaderView", owner: nil, options: nil)?[0] as! SectionHeaderView
        header.configUI(selectedTabIndex: self.segmentSelectedIndex)
        //Closure uses for return value when use tapped menu.
        header.didSelectSegment = {(menuSelected) -> Void in
            self.segmentSelected = menuSelected
            self.getCampaigns(groupType: menuSelected)
            if menuSelected == "food"{
                self.segmentSelectedIndex = 0
            }
            else if menuSelected == "buy" {
                self.segmentSelectedIndex = 1
            }
            else{
                self.segmentSelectedIndex = 2
            }
        }
        return header
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Coupon", bundle: nil)
        let getCouponVC = storyboard.instantiateViewController(withIdentifier: "GetCouponVC") as! GetCouponVC
        switch self.segmentSelected {
        case "food":
            getCouponVC.campaignIdSelected = self.foodCampaigns[indexPath.row].Id
            break
        case "buy":
            getCouponVC.campaignIdSelected = self.buyCampaigns[indexPath.row].Id
            break
        default:
            getCouponVC.campaignIdSelected = self.placeCampaigns[indexPath.row].Id
            break
        }
        self.navigationController?.pushViewController(getCouponVC, animated: true)
    }
}


// MARK: UICollectionViewDataSource
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.banners.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell    = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCVC", for: indexPath) as! BannerCVC
        let aBanner = self.banners[indexPath.item]
        cell.banner = aBanner.Banner
        return cell
    }
}


// MARK: UICollectionViewDelegate
extension HomeVC: UICollectionViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Coupon", bundle: nil)
        let getCouponVC = storyboard.instantiateViewController(withIdentifier: "GetCouponVC") as! GetCouponVC
        getCouponVC.campaignIdSelected = self.banners[indexPath.row].Id
        _ = self.navigationController?.pushViewController(getCouponVC, animated: true)
    }
}


// MARK: UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.size.width, height: 150.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


//MARK: Bottom Bar Tapped.
extension HomeVC {
    @IBAction func giftTapped(_ sender: Any) {
        let storyboard  = UIStoryboard(name: "Gift", bundle: nil)
        let giftVC      = storyboard.instantiateViewController(withIdentifier: "ExchangePointVC") as! ExchangePointVC
        _ = self.navigationController?.pushViewController(giftVC, animated: true)
    }

    @IBAction func nearbyTapped(_ sender: Any) {
        print("nearbyTapped!!!")
    }

    @IBAction func merchantListTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Merchants", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MerchantsVC") as! MerchantsVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        _ = self.navigationController?.pushViewController(searchVC, animated: true)
    }
}
