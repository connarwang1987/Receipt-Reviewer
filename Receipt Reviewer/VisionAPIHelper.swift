//
//  VisionAPIHelper.swift
//  Receipt Reviewer
//
//  Created by Linglong Wang on 7/24/17.
//  Copyright © 2017 Connar Wang. All rights reserved.
//
import UIKit
import Foundation
import Alamofire
import SwiftyJSON

struct VisionAPIHelper {
    
    static func sendImage(image: UIImage, onCompletion: @escaping (JSON) -> Void) {
        func base64EncodeImage(_ image: UIImage) -> String {
            var imagedata = UIImagePNGRepresentation(image)
            
            if ((imagedata?.count)! > 2097152) {
                let oldSize: CGSize = image.size
                let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
                imagedata = resizeImage(newSize, image: image)
            }
            
            return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
        }
        
        
        
        func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
            UIGraphicsBeginImageContext(imageSize)
            image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            let resizedImage = UIImagePNGRepresentation(newImage!)
            UIGraphicsEndImageContext()
            return resizedImage!
        }
        
        let apiKey = "AIzaSyCPweDaQiAX7fnfoxi5Cx8FmS9QTEdpl24"
        var googleURL: URL {
            return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
        }
        let imageBase64 = base64EncodeImage(image)
        let paramsAsJSON: Parameters = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "TEXT_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        Alamofire.request(googleURL, method: .post, parameters: paramsAsJSON, encoding: JSONEncoding.default, headers: headers).responseData { (response) in
            print(response)
            
            let json = JSON(response.data)
            
            print(json)
            
            onCompletion(json)
        }
        
        
    }
}
