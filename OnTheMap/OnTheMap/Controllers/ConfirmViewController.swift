//
//  ConfirmViewController.swift
//  OnTheMap
//
//  Created by ToOoMa on 2019-01-22.
//  Copyright © 2019 Fatimah. All rights reserved.
//

import UIKit
import MapKit

class ConfirmViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var location: StudentLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingupMap()
        activityIndicator.hidesWhenStopped = true
    }
    
    
    private func settingupMap() {
        guard let location = location else { return }
        
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func doneButton(_ sender: UIButton)  {
        activityIndicator.startAnimating()
        let firstName = "Fatimah"
        let lastName = "Ibrahim"
        let mapString = location?.mapString
        let media = location?.mediaURL
        let lat = location?.latitude
        let long = location?.longitude
        APIFunc.postLocation(firstName: firstName, lastName: lastName, location: mapString!, media: media!, latitude: lat!, longitude: long!) { err  in
            guard err == nil else {
                self.activityIndicator.stopAnimating()
                let alert = UIAlertController(title: "ERROR", message: "Incorrect Information.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
        }
    }
}

