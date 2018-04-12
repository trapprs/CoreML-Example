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
        //print(image)
        let prediction = try self.food101.prediction(image: image)
      //  print(prediction.classLabel)
        return (prediction.classLabel, prediction.foodConfidence)
    }
    
    @IBAction func takePicture(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        var image = UIImage()
        var predictionDescrition = ""
        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = pickerImage
        }
        
        let convertImage = Convert.convertTOCVPixelBuffer(image: image)
        imageView.image = convertImage.1
        
        guard let prediction = try? caption(image: convertImage.0) else {
            return
        }
        
        for i in prediction.1 {
            if i.key.contains(prediction.0) {
                print(i)
                predictionDescrition = "This image has \(Double(floor(i.value * 100)))% of chance to be \(i.key)"
            }
        }
        print(predictionDescrition)
        self.FoodNme.text = "\(predictionDescrition)"
        
    }
}

