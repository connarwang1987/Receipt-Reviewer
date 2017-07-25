//
//  RRPhotoHelper.swift
//  Receipt Reviewer
//
//  Created by Linglong Wang on 7/10/17.
//  Copyright © 2017 Connar Wang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class RRPhotoHelper: NSObject {
    
    var completionHandler: ((UIImage) -> Void)?
    var pickedImage: UIImage? = nil
    
    // MARK: - Helper Methods
    

    func presentActionSheet(from viewController: UIViewController) {
        // 1
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your receipt from?", preferredStyle: .actionSheet)
        
        let manual = UIAlertAction(title: "Fill an Empty Form", style: .default, handler: {action in viewController.performSegue(withIdentifier: "newReceipt", sender: nil)
            
        })
        
            alertController.addAction(manual)
        
        // 2
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // 3
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { action in
                self.presentImagePickerController(with: .camera, from: viewController)
            })
            // 4
            alertController.addAction(capturePhotoAction)
            
        }
        
        // 5
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { action in
                self.presentImagePickerController(with: .photoLibrary, from: viewController)
            })
            
            alertController.addAction(uploadAction)
    
        }
        
        // 6
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // 7
        viewController.present(alertController, animated: true)
    }
    
    func presentImagePickerController(with sourceType: UIImagePickerControllerSourceType, from viewController: UIViewController) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        viewController.present(imagePickerController, animated: true)
    }
    
    
    
    
}


extension RRPhotoHelper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickedImage = selectedImage
            
            completionHandler?(selectedImage)
            
        }
        
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


