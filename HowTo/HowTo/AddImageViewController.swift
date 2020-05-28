//
//  AddImageViewController.swift
//  HowTo
//
//  Created by Shawn James on 5/27/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit
import Cloudinary

class AddImageViewController: UIViewController {
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var pickAnImageButton: UIButton!
    @IBOutlet weak var uploadAnImageButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    var newTutorialTitle: String?
    var newTutorialImageURL: String?
    public var imagePicker: UIImagePickerController? // save reference to it
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pickAnImageButtonpressed(_ sender: UIButton) {
        presentPhotoLibraryActionSheet()
    }
    
    @IBAction func uploadAnImageButtonPressed(_ sender: UIButton) {
        guard let imageData: Data = selectedImage.image?.jpeg else { return }
        
        self.statusLabel.text = "Uploading..."
        
        let cloudinaryConfiguration = CLDConfiguration(cloudName: "dehqhte0i", apiKey: "959718959598545", secure: true)
        let cloudinaryControl = CLDCloudinary(configuration: cloudinaryConfiguration)
        
        cloudinaryControl.createUploader().upload(data: imageData, uploadPreset: "y1v3bbv4", progress: { (progress) in
            // handle progress
        }) { (uploadResult, error) in
            if let error = error { print(error) }
            if let imageURL = uploadResult?.secureUrl {
                print("image was uploaded to \(imageURL)")
                self.newTutorialImageURL = imageURL
                self.statusLabel.text = "Upload Successful!"
            }
        }
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
    }
    
    private func presentPhotoLibraryActionSheet() {
        
        // make sure imagePicker is nill
        if self.imagePicker != nil {
            self.imagePicker?.delegate = nil
            self.imagePicker = nil
        }
        
        // init image picker
        self.imagePicker = UIImagePickerController()
        
        let actionSheet = UIAlertController(title: "Select Source Type", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.presentImagePicker(controller: self.imagePicker!, sourceType: .camera)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
                self.presentImagePicker(controller: self.imagePicker!, sourceType: .photoLibrary)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            actionSheet.addAction(UIAlertAction(title: "Saved Albums", style: .default, handler: { _ in
                self.presentImagePicker(controller: self.imagePicker!, sourceType: .savedPhotosAlbum)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(actionSheet, animated: true)
    }
    
    // helper for imagePicker
    func presentImagePicker(controller: UIImagePickerController, sourceType: UIImagePickerController.SourceType) {
        controller.delegate = self
        controller.sourceType = sourceType
        self.present(controller, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addDescriptionViewController = segue.destination as? AddDescriptionViewController,
            let newTutorialTitle = newTutorialTitle,
        let newTutorialImageURL = newTutorialImageURL else { return }
        
        addDescriptionViewController.newTutorialImageURL = newTutorialImageURL
        addDescriptionViewController.newTutorialTitle = newTutorialTitle
    }
    
}

extension AddImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return self.imagePickerControllerDidCancel(picker)
        }
        self.selectedImage.image = image
        picker.dismiss(animated: true) {
            // clean up
            picker.delegate = nil
            self.imagePicker = nil
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            picker.delegate = nil
            self.imagePicker = nil
        }
    }

}
