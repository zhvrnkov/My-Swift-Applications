//
//  ViewController.swift
//  WhatFlower
//
//  Created by Vladislav Zhavoronkov on 30/05/2018.
//  Copyright © 2018 Vladislav Zhavoronkov. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var dateLabel: UITextView!
    
    
    let imagePicker = UIImagePickerController()
    let wikiURL = "https://en.wikipedia.org/w/api.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("WE GOT SOME PROBLEMS WITH CIIMAGE")
            }
            
            
            detect(flowerImage: ciImage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(flowerImage: CIImage) {
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("WE GOT SOME PROBLEMS WITH ML MODEL")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("WE GOT SOME PROBLEMS WITH REQUEST")
            }
            
            let classification = results.first?.identifier
            print(classification!)
            self.getData(flowerName: classification!)
        }
        
        let handler = VNImageRequestHandler(ciImage: flowerImage)
        
        do {
            try handler.perform([request])
        } catch  {
            print(error)
        }
    }
    
    func getData(flowerName: String) {
        let params = [
            "format": "json",
            "action": "query",
            "prop": "extracts|pageimages",
            "exintro": "",
            "explaintext": "",
            "titles": flowerName,
            "indexpageids": "",
            "redirects": "1",
            "pithumbsize": "500"
        ]
        
        Alamofire.request(wikiURL, method: .get, parameters: params).responseJSON {
            responce in
            if responce.result.isSuccess {
                let data: JSON = JSON(responce.result.value!)
                print(data)
                self.updateData(data)
            } else {
                self.dateLabel.text = "NO DATA"
            }
        }
    }
    
    func updateData(_ data: JSON) {
        let id = data["query"]["pageids"][0].stringValue
        let title = data["query"]["pages"][id]["title"].stringValue
        let text = data["query"]["pages"][id]["extract"].stringValue
        let flowerImageUrl = data["query"]["pages"][id]["thumbnail"]["source"].stringValue
        
        self.imageView.sd_setImage(with: URL(string: flowerImageUrl))
        
        self.navigationItem.title = title
        self.dateLabel.text = text
    }


    @IBAction func cameraBtnPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
}

