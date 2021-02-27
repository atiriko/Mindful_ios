//
//  Storage.swift
//  Motivation
//
//  Created by Atahan Sahlan on 13/02/2021.
//

import Foundation
import Firebase

public class DatabaseStorage{
    let storage = Storage.storage()
    let uid = Auth.auth().currentUser?.uid
    func getProfilePicture(Image: @escaping (UIImage) -> Void){
        let storageRef = storage.reference().child("UserProfilePictures").child(uid!).child("profile.jpg")
        
        storageRef.getData(maxSize: 10 * 2048 * 2048) { data, error in
          if let error = error {
            let configuration = UIImage.SymbolConfiguration(pointSize: 48)

            let image = UIImage(systemName: "person.fill", withConfiguration: configuration)!
print(error)
            Image(image)
            // Uh-oh, an error occurred!
          } else {
            
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
            Image(image!)
          }
        }
    }
    
    func addProfilePicture(Image: Data){
        let storageRef = storage.reference().child("UserProfilePictures").child(uid!).child("profile.jpg")
        
        let uploadTask = storageRef.putData(Image, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error)
            }
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          storageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
          }

    }
    }


}
