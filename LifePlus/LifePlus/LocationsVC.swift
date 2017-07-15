//
//  LocationsVC.swift
//  LifePlus
//
//  Created by Javu on 7/12/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class LocationsVC: BaseTableVC {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var merchantLogoButton: UIButton!

    var campaign: Campaign?             //Pass from GiftDetailVC
    var currentCampaign: Campaign?
    var branchSelected: Branch?         //Pass from GiftDetailVC

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        if self.branchSelected == nil {
            self.addPullToRefresh()
        }
        else {
            let currentLat  = branchSelected?.Lat
            let currentLng  = branchSelected?.Lng
            let currentLocation = CLLocation(latitude: currentLat!, longitude: currentLng!)
            self.showLocation(location: currentLocation, title: (self.branchSelected?.Address ?? ""))
        }
    }


    override func reloadData(reload: Bool) {
        self.getCampaignDetail()
    }

    override func endRefresh(reloadData: Bool) {
        self.tableView.mj_header.endRefreshing()
        self.tableView.reloadData()
    }

    func getCampaignDetail() {
        APIManager.getCampaign(campaignId: (self.campaign?.Id)!) { (success, campaign, error) in
            if error == nil {
                self.currentCampaign = campaign
                self.setupLogoUI()
            }
            else {
                self.showMessage(message: error ?? "getCampaignDetail error!!!")
            }
            self.endRefresh(reloadData: true)
        }
    }

    func setupLogoUI(){
        self.merchantLogoButton.sd_setBackgroundImage(with: URL(string: (self.currentCampaign?.Merchant?.MerchantLogo)!), for: .normal)
        self.merchantLogoButton.circleButton()
        self.showTitle(title: "\(self.currentCampaign?.Branch?.count ?? 4) ĐỊA ĐIỂM")
        let firstLocation = CLLocation(latitude: (self.currentCampaign?.Branch?.first?.Lat)!, longitude: (self.currentCampaign?.Branch?.first?.Lng)!)
        self.showLocation(location: firstLocation, title: (self.currentCampaign?.Branch?.first?.Address ?? ""))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func merchantLogoButtonTapped(_ sender: Any) {
        print("merchantLogoButtonTapped!!!")
    }
}


//MARK: CLLocation Manager Delegate.
extension LocationsVC: CLLocationManagerDelegate {
    /*
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.locationManager.startUpdatingLocation()
            self.mapView.isMyLocationEnabled        = true
            self.mapView.settings.myLocationButton  = true
        }
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
*/

    func showLocation(location: CLLocation, title: String){
        self.mapView.clear()
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: 15)
        self.mapView.camera = camera
        self.mapView.isMyLocationEnabled = true
        let marker = GMSMarker()
        marker.position = camera.target //Show marker on map.
        marker.snippet  = title
        marker.appearAnimation = .pop
        marker.map = self.mapView
        marker.icon = GMSMarker.markerImage(with: UIColor.red)
    }

    //MARK: UITable View Data Source.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.branchSelected == nil {
            if let num = self.currentCampaign?.Branch?.count {
                return num
            }
            else {
                return 0
            }
        }
        else {
            return 1
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationsCell")
        let addressLabel = cell?.viewWithTag(11) as! UILabel
        if self.branchSelected == nil {
            addressLabel.text = self.currentCampaign?.Branch?[indexPath.row].Address ?? ""
        }
        else {
            addressLabel.text = self.branchSelected?.Address ?? ""
        }
        cell?.selectionStyle = .none
        return cell!
    }


    //MARK: UITable View Deleagate.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.branchSelected == nil {
            let currentItem = self.currentCampaign?.Branch?[indexPath.row]
            let currentLat  = currentItem?.Lat
            let currentLng  = currentItem?.Lng
            let currentLocation = CLLocation(latitude: currentLat!, longitude: currentLng!)
            self.showLocation(location: currentLocation, title: (self.currentCampaign?.Branch?[indexPath.row].Address ?? ""))
        }
        else {
            let currentLat  = branchSelected?.Lat
            let currentLng  = branchSelected?.Lng
            let currentLocation = CLLocation(latitude: currentLat!, longitude: currentLng!)
            self.showLocation(location: currentLocation, title: (self.branchSelected?.Address ?? ""))
        }
    }
}
