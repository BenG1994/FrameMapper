//
//  AddPhotoDataViewController.swift
//  FrameMapper
//
//  Created by Ben Gauger on 3/8/23.
//

import UIKit
import MapKit
import CoreLocation

class AddPhotoDataViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var cameraTextField: UITextField!
    @IBOutlet weak var filmTextField: UITextField!
    @IBOutlet weak var frameCountTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var modalView: UIView!
    
//    var delegate: placePin?
    
    weak var firstViewController: MapViewController?
    
    var textField = UITextField()
    let colors = ["Red", "Green", "Blue", "Orange", "Yellow", "Pink", "Purple"]
    
    var colorPickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraTextField.delegate = self
        self.filmTextField.delegate = self
        self.frameCountTextField.delegate = self
        self.colorTextField.delegate = self
        
        colorTextField.inputView = colorPickerView
        colorPickerView.delegate = self
        colorPickerView.dataSource = self
        colorTextField.placeholder = "Choose a color"
        colorPickerView.frame.size.height = 150
        
        view.isOpaque = false
        view.backgroundColor = .clear
        
        addButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
        modalView.layer.cornerRadius = 15
        photoImageView.layer.cornerRadius = 15
        addPhotoButton.layer.cornerRadius = 15
        addPhotoButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(AddPhotoDataViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
//        firstViewController = self
        
    }
    
    @objc func didTapView(){
      self.view.endEditing(true)
    }
    
    @IBAction func addPhotoPressed(_ sender: Any) {
        accessCamera()
    }
    
    func accessCamera() {
        let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }

        
        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(photoLibraryAction)
        
        present(photoSourceRequestController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.backgroundColor = .clear
            photoImageView.contentMode = .scaleAspectFit
            photoImageView.clipsToBounds = true
        }
        addPhotoButton.backgroundColor = .clear
        addPhotoButton.tintColor = .clear
        dismiss(animated: true)
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        print("cancel stuff")
        dismiss(animated: true)
    }
    
    
    @IBAction func addInfoPressed(_ sender: Any) {
        
        
//        print(mapVC.dropPin())
        firstViewController?.dropPin()
        
        
//        save stuff
//        add pin to location
        
        
        
        dismiss(animated: true)

    }
    
    
    
}




extension AddPhotoDataViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        colors.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        colors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        colorTextField.text = colors[row]
        colorTextField.resignFirstResponder()
    }
    
}

extension AddPhotoDataViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == cameraTextField) {
            cameraTextField.text = ""
        }
        else if (textField == filmTextField) {
            filmTextField.text = ""
        }
        else if (textField == frameCountTextField) {
            frameCountTextField.text = ""
        }
        else if (textField == colorTextField) {
            colorTextField.text = ""
        }
        else {
            print("No text field selected")
        }
    }
    
    
}
