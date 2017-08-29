//
//  NewThingCell.swift
//  Things
//
//  Created by Brie Heutmaker on 11/18/15.
//  Copyright © 2015 Brie Heutmaker. All rights reserved.
//

import UIKit

protocol NewThingCellDelegate {
    func didCancelNewThing()
    func didSaveNewThing()
    func didFail(with error: String)
}

class NewThingCell: UITableViewCell {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var newThingTextField: UITextField!
    
    @IBOutlet weak var iconCollectionView: UICollectionView! {
        didSet {
            iconCollectionView.delegate = self
            iconCollectionView.dataSource = self
        }
    }
    
    var selectedIndex: IndexPath?
    
    var icons: [String]!
    
    var thing = Thing()
    
    var delegate: NewThingCellDelegate!
    var coordinator: Coordinator!
    
    override func prepareForReuse() {
        newThingTextField.text = ""
        selectedIndex = nil
        thing = Thing()
    }
    
    @IBAction func save() {
        
        if let newText = newThingTextField.text {
            
            if newText != "" {
                
                thing.name = newText
                
                if thing.icon == nil {
                    thing.icon = randomFontAwesomeCode()
                }
                
                coordinator.save(thing, closure: { () in
                    self.delegate.didSaveNewThing()
                    
                }, errorBlock: { e in
                    self.delegate.didFail(with: e)
                })
                
            } else {
                
                newThingTextField.placeholder = "Nothing here..."
                
                delay(1.5, {
                    self.newThingTextField.placeholder = "New thing..."
                })
                
                return
            }
        }
    }
    
    @IBAction func cancel() {
        reset() {
            self.delegate.didCancelNewThing()
        }
    }
    
    private func reset(_ block: @escaping Block) {
        newThingTextField.text = ""
        block()
    }
}

extension NewThingCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let icon = icons[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCell", for: indexPath) as? IconCell else {
            return UICollectionViewCell()
        }
        
        if indexPath == selectedIndex {
            cell.backgroundColor = .lightGray
        }
        
        cell.backgroundView?.layer.cornerRadius = 5
        cell.iconImageView.image = iconFromCode(icon, tintColor: UIColor.black)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? IconCell else { return }
        
        if selectedIndex == indexPath {
            selectedIndex = nil
            cell.backgroundColor = .white
            
        } else {
            selectedIndex = indexPath
            
            cell.backgroundColor = .lightGray
        }
        
        let icon = icons[indexPath.row]
        thing.icon = icon
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? IconCell else { return }
        cell.backgroundColor = UIColor.white
    }
    
}
