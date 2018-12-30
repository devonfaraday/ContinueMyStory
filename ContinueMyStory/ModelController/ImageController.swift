//
//  ImageController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 12/9/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import FirebaseStorage
import UIKit

class ImageController {
    var imageReference: StorageReference {
        return Storage.storage().reference().child(String.profileImagesKey)
    }
    
    // MARK: - Create
    func createProfileImage(withImageData imageData: Data, forUser user: User?) {
        guard let userId = user?.uid else { return }
        let imageRef = imageReference.child("\(userId).jpg")
        let uploadTask = imageRef.putData(imageData, metadata: nil) { (metaData, error) in
            print(metaData ?? "NO META DATA")
            print(error?.localizedDescription ?? "NO ERROR")
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        uploadTask.resume()
    }
    
    // MARK: - Read
    func fetchImage(forUser user: User?, completion: @escaping(UIImage?) -> Void) {
        guard let userId = user?.uid else { completion(nil); return }
        let imageRef = imageReference.child("\(userId).jpg")
        imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let image = UIImage(data: data)
                completion(image)
            }
        }
    }
    
    func fetchImage(withUserId userId: String, completion: @escaping(UIImage?) -> Void) {
        let imageRef = imageReference.child("\(userId).jpg")
        imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let image = UIImage(data: data)
                completion(image)
            }
        }
    }
    
    func fetchImages() {
        
    }
    
    // MARK: - Update
    func updateImage() {
        
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // MARK: - Delete
    func deleteImage()  {
        
    }
}

