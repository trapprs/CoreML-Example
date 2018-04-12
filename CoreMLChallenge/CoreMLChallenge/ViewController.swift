//
//  ViewController.swift
//  CoreMLChallenge
//
//  Created by Renan Trapp on 11/04/18.
//  Copyright © 2018 Renan Trapp. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let food101 = Food101()
    
    @IBOutlet weak var FoodNme: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    func caption(image: CVPixelBuffer) throws -> (String, [String: Double]) {
        let prediction = try self.food101.prediction(image: image)
        
        return (prediction.classLabel, prediction.foodConfidence)
    }
    
    @IBAction func getImageFromPhone(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takePicture(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
       
        var predictionDescrition = ""
        var image = UIImage()
        
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                image = pickerImage
            }
            
            let convertImage = Convert.convertTOCVPixelBuffer(image: image)
            guard let prediction = try? self.caption(image: convertImage.0) else {
                return
            }
            
            for i in prediction.1 {
                if i.key.contains(prediction.0) {
                    predictionDescrition = "This image has \(Double(floor(i.value * 100)))% of chance to be a \(i.key.replacingOccurrences(of: "_", with: " "))"
                }
            }
             self.imageView.image = image
            self.FoodNme.text = "\(predictionDescrition)"
        }
       
        
    }
}

