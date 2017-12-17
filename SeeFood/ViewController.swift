//
//  ViewController.swift
//  SeeFood
//
//  Created by user132375 on 11/30/17.
//  Copyright © 2017 user132375. All rights reserved.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBAction func nutrients(_ sender: UIButton) {
        performSegue(withIdentifier: "goToNutrientsScreen", sender: self)
    }
    
    @IBAction func recipe(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRecipeScreen", sender: self)
    }
    
    @IBOutlet weak var imageView: UIImageView!

    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary //.camera to access camera
        imagePicker.allowsEditing = false
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
          imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage to CIImage")
            }
            
            detect(image: ciimage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            let firstResult = results.first?.identifier
            self.navigationItem.title = firstResult
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToNutrientsScreen" {
//
//            let NutrientsVC = segue.destination as! NutrientsViewController
//
//            NutrientsVC.food = self.navigationItem.title
//        }
//    }

}

