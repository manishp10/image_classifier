//
//  ViewController.swift
//  Image Classifier
//
//  Created by Manish Patel on 05/05/2022.
//

import CoreML
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Select Image"
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(imageView)
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapImage)
        )
        tap.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    @objc func didTapImage(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 20, y: view.safeAreaInsets.top,
                                 width: view.frame.size.width-40,
                                 height: view.frame.size.width-40)
        label.frame = CGRect(x: 20, y: view.safeAreaInsets.top+(view.frame.size.width-40)+10,
                             width: view.frame.size.width-40,
                             height: 100)
    }

    private func analyseImage(image: UIImage?) {
        guard let buffer = image?.resize(size: CGSize(width: 180, height: 180))?
        .getCVPixelBuffer() else {
                return
            }
        do{
            print(buffer)
            let config = MLModelConfiguration()
            let model = try flower_classifier(configuration: config)
            let input = flower_classifierInput(sequential_2_input: buffer)
            let output = try model.prediction(input: input)
            let text = output.classLabel
            label.text = text
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
//    private func analyseImage(image: UIImage?) {
//
//        guard let buffer = image?.pixelBufferGray(width: 32, height: 128) else {
//                print("returned at this point")
//                return
//            }
//        do{
//            let config = MLModelConfiguration()
//            let model = try handwriting_recognition_v3(configuration: config)
//            let input = handwriting_recognition_v3Input(image: buffer)
//            let output = try model.prediction(input: input)
//            print(output.Identity)
//            label.text = "printed prediction output"
//        }
//        catch{
//            print(error.localizedDescription)
//        }
//    }
    
    // Image Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // cancelled
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        imageView.image = image
        analyseImage(image: image)
    }
    
}

