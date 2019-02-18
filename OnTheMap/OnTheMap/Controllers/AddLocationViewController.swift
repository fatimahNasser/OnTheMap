//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by ToOoMa on 2019-01-19.
//  Copyright © 2019 Fatimah. All rights reserved.
//

import UIKit
import CoreLocation


class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var addLocationTextField: UITextField!
    @IBOutlet weak var mediaLinkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingupUI()
        activityIndicator.hidesWhenStopped = true
    }
    
    // subscribing to keyboard notifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // unsubscribing to keyboard notifications
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //managing the problem of keyboard showing on top of the textfields
    @objc func keyboardWillShow(_ notification:Notification) {
        if mediaLinkTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func findLocationButton(_ sender: UIButton) {
        
        guard let location = addLocationTextField.text,
            let mediaLink = mediaLinkTextField.text,
            location != "", mediaLink != "" else {
                let alert = UIAlertController(title: "ERROR", message: "Incorrect Information, TRY again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                present(alert, animated: true, completion: nil)
                
                return
        }
        let studentLocation = StudentLocation(mapString: location, mediaURL: mediaLink)
        geocodeCoordinates(studentLocation)
    }
    
    private func geocodeCoordinates(_ studentLocation: StudentLocation) {
        
        activityIndicator.startAnimating()
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMarks, err) in
            if err == nil {
                self.activityIndicator.stopAnimating()
                guard let firstLocation = placeMarks?.first?.location else { return }
                var location = studentLocation
                location.latitude = firstLocation.coordinate.latitude
                location.longitude = firstLocation.coordinate.longitude
                self.performSegue(withIdentifier: "mapSegue", sender: location)
            } else {
                self.activityIndicator.stopAnimating()
                let alert = UIAlertController(title: "ERROR", message: "Unable to find location", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                return
                
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue", let vc = segue.destination as? ConfirmViewController {
            vc.location = (sender as! StudentLocation)
        }
    }
    
    private func settingupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancelButton(_:)))
        
        addLocationTextField.delegate = self
        mediaLinkTextField.delegate = self
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
