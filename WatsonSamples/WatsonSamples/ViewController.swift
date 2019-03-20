//
//  ViewController.swift
//  WatsonSamples
//
//  Created by Konstantin on 19/03/2019.
//  Copyright © 2019 Konstantin. All rights reserved.
//

import UIKit
import VisualRecognitionV3

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    // https://cloud.ibm.com/resources
    
    let apiKey = "-8kIFBc5kqNCNWLyo7RqPhQl2-Mb7rXSt0SyKxaOTLfN"
    let version = "2019-03-20"
    
    let imagePicker = UIImagePickerController()
    var classificationResults: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imageView.contentMode = .scaleAspectFit
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageView.image = image
            
            imagePicker.dismiss(animated: true, completion: nil)
            
            //get url for image, not used
            //let imageData = image.jpegData(compressionQuality: 0.01)
            //let documetsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            //let fileURL = documetsURL.appendingPathComponent("tempImage.jpg")
            //try? imageData?.write(to: fileURL)
            
            let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
            visualRecognition.classify(image: image) { (classifiedImages, error) in
                
                if let classes = classifiedImages?.result?.images.first?.classifiers.first?.classes {
                    
                    self.classificationResults.removeAll()
                    
                    for index in 1..<classes.count {
                        self.classificationResults.append(classes[index].className)
                    }
                    
                    print(self.classificationResults)
                    
                    if self.classificationResults.contains("hotdog") || self.classificationResults.contains("chili dog")  {
                        DispatchQueue.main.async {
                            self.navigationItem.title = "Hotdog!"
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.navigationItem.title = "Not Hotdog!"
                        }
                    }
                    
                }
                
            }
            
        } else {
            print("There was an error picking the image")
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

