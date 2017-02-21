//
//  AttributesViewController+UITableView.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 7/18/16.
//  Copyright © 2016 Ben Heutmaker. All rights reserved.
//

import UIKit

extension AttributesViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView Delegate / Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let thing = self.thing else {
            return 0
        }
        
        return thing.attributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let thing = self.thing else {
            fatalError()
        }
        
        let attribute = thing.attributes[indexPath.row]
        
        switch attribute.type {
            
        case .image:
            guard let imageAttribute = attribute as? ImageAttribute else { fatalError() }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellKey.attributeImage) as? ImageAttributeCell else { fatalError() }
            
            cell.thingImageView.image = imageAttribute.image
            
            cell.thingImageView.layer.borderColor = UIColor.darkGray.cgColor
            cell.thingImageView.layer.borderWidth = 1
            cell.imageProgressView.isHidden = true
//            cell.thingDescriptionLabel.text = imageAttribute.id.dateCreated?.string
            return cell
            
        case .text:
            guard let textAttribute = attribute as? TextAttribute else { fatalError() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CellKey.attributeText) as! AttributeTextCell
            
            cell.newAttributeTextView.delegate = self
            cell.newAttributeTextView.text = textAttribute.text
//            cell.thingDescriptionLabel.text = textAttribute.id.dateCreated?.string
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let thing = self.thing else {
            fatalError()
        }
        
        let attribute = thing.attributes[indexPath.row]
        
        guard let imageAttribute = attribute as? ImageAttribute else {
            return UITableViewAutomaticDimension
        }
        
        guard let height = imageAttribute.imageHeight(from: tableView.frame.width) else {
            return UITableViewAutomaticDimension
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let thing = self.thing else {
            return nil
        }
        
        guard let header = (tableView.dequeueReusableCell(withIdentifier: "ThingTitleCell") as? ThingTitleCell) else {
            fatalError()
        }
        
        header.titleLabel.text = thing.name
        
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = tableView.headerView(forSection: section) else {
            return 0
        }
        
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard let thing = self.thing else {
            fatalError()
        }
        
        let attribute = thing.attributes[indexPath.row]
        
        let deleteRowAction = UITableViewRowAction(style: .default, title: "Delete") { (action, actionIndexPath) in
            
            let cachedAttribute = attribute
            
            thing.attributes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            
            if thing.attributes.isEmpty {
                self.insertNewTextAttribute()
            }
            
            Coordinator.default.delete(attribute: attribute, closure: { 
                
            }, errorBlock: { (e) in
                self.showAlert(withTitle: "Much Fail, Many Faults", message: "e")
                
                thing.attributes.insert(cachedAttribute, at: indexPath.row)
                self.tableView.insertRows(at: [indexPath], with: .top)
            })
            
//            self.coordinator.delete(attribute: attribute, { (success) in
//                if success {
//                    print("Deleted attribute successfully")
//                    
//                } else {
//                    let alert = UIAlertController(title: "Deleting That Thing Failed", message: "Could not delete that thing. Sorry.", preferredStyle: .alert)
//                    let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
//                    alert.addAction(okay)
//                    
//                    self.present(alert, animated: true, completion: nil)
//                    
//                }
//            })
        }
        
        return [deleteRowAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let thing = self.thing else {
            fatalError()
        }
        
        let attribute = thing.attributes[indexPath.row]
        
        switch attribute.type {
        case .image:
            guard let imageAttribute = attribute as? ImageAttribute else {
                return
            }
            
            guard let image = imageAttribute.image else {
                print("Image in attribute is nil????")
                return
            }
            
            performSegue(withIdentifier: "ImageSegue", sender: image)
            
        default:
            break
        }
    }
}
