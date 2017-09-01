//
//  AttributesViewController+UIImagePickerController.swift
//  Things
//
//  Created by Brianna Lee on 7/25/16.
//  Copyright © 2016 Exoteric Design. All rights reserved.
//

import UIKit

/**
 extension: UIImagePickerControllerDelegate / UINavigationControllerDelegate
 
 -see didSelectRowAtIndexPath and prepareForSegue for displaying ImageAttributeViewController
 **/

extension AttributesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Image Attribute
    
    //Click Camera Button
    @objc func cameraButtonHandler() {
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { (action) in
            self.presentImagePicker(.savedPhotosAlbum)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.presentImagePicker(.camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func presentImagePicker(_ sourceType: UIImagePickerControllerSourceType) {
        
        if imagePicker == nil {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
        }
        
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Handle Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true) {
            let newObject = Object(type: .attribute)
            let imageAttribute = ImageAttribute(from: newObject)
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            imageAttribute.image = image
            
            guard let thing = self.thing else {
                fatalError()
            }
            
            thing.attributes.append(imageAttribute)
            
//            self.coordinator.save(thing, closure: { newThing in
//                print("Do what needs done.")
//                
//            }, errorBlock: { e in
//                print("Do what needs done.")
//            })
        }
    }
    
    func insertImageCell(with imageAttribute: ImageAttribute) {
        
        guard let thing = self.thing else {
            return
        }
        
        if thing.attributes.isEmpty {
            
            thing.attributes.insert(imageAttribute, at: 0)
            
            OperationQueue.main.addOperation({
                self.tableView.insertRows(at: [firstIndexPath], with: .fade)
                
                let cell = self.tableView.cellForRow(at: firstIndexPath) as! ImageAttributeCell
                self.activeProgressView = cell.imageProgressView
                cell.imageProgressView.isHidden = false
                cell.imageProgressView.progress = 0
            })
        }
    }
}
