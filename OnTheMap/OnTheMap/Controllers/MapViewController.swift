//
//  MapViewController.swift
//  OnTheMap
//
//  Created by ToOoMa on 2019-01-08.
//  Copyright © 2019 Fatimah. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var locations: Locations? {
        didSet {
            updatePins()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        updatePins()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updatePins()
    }
    
    //show students pins on the map
    func updatePins() {
        
        var annotations = [MKPointAnnotation]()
        
        APIFunc.getStudentLocations(limit: 100, skip: 0) {(locations) in
            if locations == nil || (locations?.studentLocationsData.isEmpty)! {
                let alert = UIAlertController(title: "ERROR", message: "No students found", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                return
            } else{
                
                
                for dictionary in (locations?.studentLocationsData)! {
                    
                    guard let latitude = dictionary.latitude, let longitude = dictionary.longitude else { continue }
                    
                    let lat = CLLocationDegrees(latitude)
                    let long = CLLocationDegrees(longitude)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = dictionary.firstName
                    let last = dictionary.lastName
                    let mediaURL = dictionary.mediaURL
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first ?? "") \(last ?? "")"
                    annotation.subtitle = mediaURL
                    
                    annotations.append(annotation)
                    self.mapView.addAnnotations(annotations)
                }
            }            
        }
    }
    
    // return pin back to map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    //open url when pin is tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    @IBAction func refreshButton(_ sender: Any) {
        updatePins()
        
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        APIFunc.sharedInstance.logout{ (false, error) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
}

