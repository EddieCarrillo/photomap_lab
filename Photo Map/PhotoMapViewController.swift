//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {
    
    
    
    
   
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    
    
    var chosenPicture: UIImage?
    
    
    @IBAction func onCameraTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
            self.present(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialRegion()

        // Do any additional setup after loading the view.
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.chosenPicture = image
        
        dismiss(animated: true) {
            self.performSegue(withIdentifier: "tagSegue", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tagSegue" {
            let destinationVC = segue.destination as! LocationsViewController
            destinationVC.delegate = self
        }
    }

    
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        print("locationPickedLocation() called!")
        
        let locationCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees.init(latitude), CLLocationDegrees.init(longitude))
        
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = locationCoordinate
        pointAnnotation.title = "Picture!"
        mapView.addAnnotation(pointAnnotation)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        print("mapView protocol called!")
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)

        if (annotationView == nil){
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView?.canShowCallout = true
            annotationView?.leftCalloutAccessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
        }
        
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        
        imageView.image = UIImage(named: "Camera")
        
        return annotationView

    }
    
    
    
    func setInitialRegion(){
        //one degree of lattitude is approximately 111 km (69 miles) at all times
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1))
        
        mapView.setRegion(sfRegion, animated: true)
    }
    
    
    

}
