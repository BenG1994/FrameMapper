//
//  ViewController.swift
//  FrameMapper
//
//  Created by Ben Gauger on 3/7/23.
//

import UIKit
import MapKit
import CoreLocation

//protocol placePin {
//    
//    func dropPin()
//    
//}


class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    
    @IBOutlet weak var eraserButton: UIButton!
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    var textField = UITextField()
//    var placedPins: [Pins] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustButtonSizes()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
        locationManager.delegate = self
        
//        have for loop to load each of the photo data things and have a pin show up each time?
    }
    
    
    
    func adjustButtonSizes() {
        locationButton.frame.size.height = 50
        locationButton.frame.size.width = 50
        locationButton.imageView?.sizeToFit()
        locationButton.tintColor = UIColor(red: 227/255.0, green: 6/255.0, blue: 19/255.0, alpha: 255.0)
        locationButton.backgroundColor = UIColor(red: 250/255.0, green: 182/255.0, blue: 23/255.0, alpha: 255.0)
        locationButton.layer.cornerRadius = locationButton.frame.size.height/2
        locationButton.contentHorizontalAlignment = .fill
        locationButton.contentVerticalAlignment = .fill
        locationButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
    }
    
    @IBAction func testButtonPressed(_ sender: Any) {
        dropPin()
    }
    
    @IBAction func clearPhotosPressed(_ sender: Any) {
    }
    
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        centerMapOnUserLocation()
        
    }
    
    @IBAction func addPhotoDataPressed(_ sender: Any) {
        dropPin()
        guard let infoVC = storyboard?.instantiateViewController(withIdentifier: "AddPhotoDataViewController") as? AddPhotoDataViewController else {return}
        infoVC.modalPresentationStyle = .overCurrentContext
        present(infoVC, animated: true)
//        dropPin()
    }
    
}

//MARK: - Map View Delegate

extension MapViewController: MKMapViewDelegate{
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }else {
            let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
            pinAnnotation.pinTintColor = UIColor.orange
            pinAnnotation.animatesDrop = true
            return pinAnnotation
        }
    }
    
    
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else {return}
        let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionRadius * 2, longitudinalMeters: regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    @objc func dropPin() {
        
        
        let currentLocation = CLLocationCoordinate2D(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
        
        
        print(currentLocation)
        let annotation = DroppablePin(coordinate: currentLocation, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

//MARK: - Location Delegate

extension MapViewController: CLLocationManagerDelegate{
    
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        centerMapOnUserLocation()
    }
}

extension MapViewController: UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    
}
