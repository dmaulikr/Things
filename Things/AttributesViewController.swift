//
//  ThingViewController.swift
//  Things
//
//  Created by Brie Heutmaker on 4/18/16.
//  Copyright © 2016 Brie Heutmaker. All rights reserved.
//

import UIKit
import FirebaseDatabase

enum AttributesButtonStyle {
    case thingButtons
    case done(backButtonHidden: Bool)
}

class AttributesViewController: EDTableViewController, UITextFieldDelegate {
    
    //MARK: Declarations
    
    @IBOutlet var iconImageView: UIImageView!
    
    var imageBarButtonItem: UIBarButtonItem!
    var textBarButtonItem: UIBarButtonItem!
    
    var doneBarButtonItem: UIBarButtonItem!
    
    var imagePicker: UIImagePickerController!
    var alert: UIAlertController!
    
    var thing: Thing?
    
    var activeTextView: UITextView?
    var oldText: String?
    var activeAttribute: Attribute?
    
    var activeProgressView: UIProgressView?
    
    var dateFormatter: DateFormatter!
    
    var coordinator: Coordinator!
    
    var attributeAddedObserver: DatabaseHandle!
    var attributeChangedObserver: DatabaseHandle!
    var attributeRemovedObserver: DatabaseHandle!
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type = .attributes
        
        setTableView()
        setBarButtonItems(.thingButtons)
        
        setIcon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAttributesObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        attributeAddedObserver = nil
        attributeChangedObserver = nil
        attributeRemovedObserver = nil
    }
    
    private func setAttributesObservers() {
        guard let uid = AppState.shared.uid else {
            fatalError()
        }
        
        guard let thing = thing else {
            return
        }
        
        let path = "/humans/\(uid)/things/\(thing.id!)/attributes/"
        
        let attributesRef = Database.database().reference().child(path)
        
        attributesRef.keepSynced(true)
        
        attributeAddedObserver = attributesRef.observe(.childAdded, with: { (snapshot) in
            let dict = snapshot.value as! [String : Any]
            guard let attribute = AttributeFactory.shared.generateAttribute(from: dict) else { return }
            
            let containsAttribute = thing.attributes.contains(where: { (attr) -> Bool in
                guard let id = attr.id else { return false }
                return id == attribute.id
            })
            
            if containsAttribute {
                return
            } else {
                self.insert(attribute)
            }
        })
        
        attributeChangedObserver = attributesRef.observe(.childChanged, with: { (snapshot) in
            let dict = snapshot.value as! [String : Any]
            
            if let attribute = AttributeFactory.shared.generateAttribute(from: dict) {
                
                if let index = self.indexOf(attribute) {
                    thing.attributes[index] = attribute
                    let row = IndexPath(row: index, section: 0)
                    self.tableView.reloadRows(at: [row], with: .automatic)
                }
            }
        })
        
        attributeRemovedObserver = attributesRef.observe(.childRemoved, with: { (snapshot) in
            let dict = snapshot.value as! [String : Any]
            
            if let attribute = AttributeFactory.shared.generateAttribute(from: dict) {
                
                if let index = self.indexOf(attribute) {
                    thing.attributes.remove(at: index)
                    let row = IndexPath(row: index, section: 0)
                    self.tableView.deleteRows(at: [row], with: .automatic)
                }
            }
        })
    }
    
    func indexOf(_ attribute: Attribute) -> Int? {
        
        guard let thing = thing else {
            return nil
        }
        
        for i in 0..<thing.attributes.count {
            let object = thing.attributes[i]
            if object.id == attribute.id {
                return i
            }
        }
        
        return nil
    }
    
    private func insert(_ attribute: Attribute) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            
            guard let thing = self.thing else { return }
            
            let containsAttribute: Bool = thing.attributes.contains { _attribute in
                if _attribute.id == nil { return false }
                return _attribute.id == attribute.id
            }
            
            if containsAttribute {
                for i in 0..<thing.attributes.count {
                    let existingAttribute = thing.attributes[i]
                    
                    let same = existingAttribute.id ?? "" == attribute.id
                    
                    if same {
                        thing.attributes[i] = attribute
                        let indexPath = IndexPath(row: i, section: 0)
                        self.tableView.reloadRows(at: [indexPath], with: .fade)
                    }
                }
                
            } else {
                let containsTextAttribute_NotUploaded: Bool = thing.attributes.contains(where: { _attribute -> Bool in
                    switch _attribute.type {
                    case .image:
                        if let _ = _attribute as? ImageAttribute {
                            return true
                        } else {
                            return false
                        }
                        
                    case .text:
                        guard
                            let _textAttribute = _attribute as? TextAttribute,
                            let textAttribute = attribute as? TextAttribute
                            else {
                                return false
                        }
                        
                        let sameText = _textAttribute.text == textAttribute.text
                        
                        let noID = _textAttribute.id == nil ?? ""
                        
                        if sameText && noID {
                            return true
                        } else {
                            return false
                        }
                    }
                })
                
                if containsTextAttribute_NotUploaded {
                    while containsTextAttribute_NotUploaded {
                        if let index = thing.attributes.index(where: { _attribute -> Bool in
                            return _attribute.dict()["id"] == nil
                        }) {
                            thing.attributes.remove(at: index)
                            thing.attributes.insert(attribute, at: index)
                            
                            let indexPath = IndexPath(row: index, section: 0)
                            self.tableView.reloadRows(at: [indexPath], with: .fade)
                        }
                    }
                } else {
                    
                    if thing.attributes.isEmpty {
                        thing.attributes.append(attribute)
                        self.tableView.insertRows(at: [firstIndexPath], with: .fade)
                        
                    } else {
                        let exists: Bool = thing.attributes.contains { existingAttribute in
                            
                            guard let id = existingAttribute.id else {
                                return false
                            }
                            
                            let idsAreTheSame = id == attribute.id
                            
                            return idsAreTheSame
                        }
                        
                        if exists {
                            
                            for i in 0..<thing.attributes.count {
                                let existingAttribute = thing.attributes[i]
                                
                                let same = existingAttribute.id == attribute.id
                                
                                if same {
                                    let indexPath = IndexPath(row: i, section: 0)
                                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                                    thing.attributes[i] = attribute
                                }
                            }
                            
                        } else {
                            thing.attributes.append(attribute)
                            let i = thing.attributes.count - 1
                            let lastIndex = IndexPath(row: i, section: 0)
                            self.tableView.insertRows(at: [lastIndex], with: .fade)
                        }
                    }
                }
            }
            
            self.tableView.endUpdates()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageSegue" {
            
            guard let imageVC = segue.destination as? ImageAttributeViewController else {
                return
            }
            
            guard let image = sender as? UIImage else {
                return
            }
            
            imageVC.image = image
        }
    }
    
    //MARK: Setup
    
    private func setTableView() {
        //TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setBarButtonItems(_ style: AttributesButtonStyle) {
        
        switch style {
            
        case .thingButtons:
            
            if imageBarButtonItem == nil {
                let attributes = [NSFontAttributeName : UIFont.fontAwesomeOfSize(20)] as Dictionary!
                imageBarButtonItem = UIBarButtonItem(title: String.fontAwesomeIconWithName(FontAwesome.Image),
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(AttributesViewController.cameraButtonHandler))
                imageBarButtonItem.setTitleTextAttributes(attributes, for: UIControlState())
            }
            
            if textBarButtonItem == nil {
                let attributes = [NSFontAttributeName : UIFont.fontAwesomeOfSize(20)] as Dictionary!
                textBarButtonItem = UIBarButtonItem(title: String.fontAwesomeIconWithName(FontAwesome.ICursor),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(AttributesViewController.insertNewTextAttribute))
                textBarButtonItem.setTitleTextAttributes(attributes, for: UIControlState())
            }
            
            let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            fixedSpace.width = 30
            
            self.navigationItem.rightBarButtonItems = [self.textBarButtonItem]
            self.navigationItem.setHidesBackButton(false, animated: true)
            
            if thing == nil {
                //                imageBarButtonItem.isEnabled = false
                textBarButtonItem.isEnabled = false
            }
            
        case .done(let backButtonHidden):
            
            if doneBarButtonItem == nil {
                doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                    target: self,
                                                    action: #selector(AttributesViewController.finishEditingTextAttribute))
            }
            
            self.navigationItem.rightBarButtonItems = [self.doneBarButtonItem]
            
            if backButtonHidden {
                self.navigationItem.leftBarButtonItems = []
                self.navigationItem.setHidesBackButton(true, animated: true)
            }
            
            return
        }
    }
    
    private func setIcon() {
        guard let thing = self.thing else { return }
        guard let iconString = thing.icon else { return }
        
        let icon = iconFromCode(iconString, tintColor: UIColor.black)
        iconImageView.image = icon
    }
    
    func deleteAttribute(at indexPath: IndexPath) {
        guard let thing = self.thing else { return }
        let attribute = thing.attributes[indexPath.row]
        
        let cachedAttribute = attribute
        
        DispatchQueue.main.async {
            thing.attributes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        if thing.attributes.isEmpty {
            self.insertNewTextAttribute()
        }
        
        if attribute.id == nil {
            return
        }
        
        coordinator.delete(attribute: attribute, closure: {
            print("Successfully deleted Attribute")
        }, errorBlock: { (e) in
            self.showAlert(title: "Much Fail, Many Faults", message: "\(e)")
            
            DispatchQueue.main.async {
                thing.attributes.insert(cachedAttribute, at: indexPath.row)
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
        })
    }
    
    var activeTextViewIndexPath: IndexPath? {
        guard let activeTextView = activeTextView else {
            print("activeTextView is nil")
            return nil
        }
        let textViewPoint = activeTextView.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: textViewPoint) else {
            print("activeTextView is nil")
            return nil
        }
        return indexPath
    }
    
    @objc private func finishEditingTextAttribute() {
        
        guard let thing = self.thing else { return }
        guard let activeTextView = activeTextView else { return }
        activeTextView.delegate = self
        guard let indexPath = activeTextViewIndexPath else { return }
        
        if activeTextView.text == "" {
            deleteAttribute(at: indexPath)
            return
        }
        
        //        print("\n", "activeTextView.text:", "\"\(activeTextView.text!)\"", "oldText:", "\"\(oldText!)\"", "Equal Values:", activeTextView.text! == oldText!)
        
        let isNewAttribute = (oldText == "" && activeTextView.text != "")
        let isUpdatedAttribute = (oldText != "" && oldText != activeTextView.text)
        let canceledAttribute = (oldText == activeTextView.text)
        
        //New Attribute
        if isNewAttribute {
            self.setBarButtonItems(.thingButtons)
            
            let newAttribute = TextAttribute(text: activeTextView.text, parent: thing)
            save(newAttribute)
            
            activeTextView.resignFirstResponder()
            
            //Updated Attribute
        } else if isUpdatedAttribute {
            
            guard let existingAttribute = thing.attributes[indexPath.row] as? TextAttribute else { return }
            
            self.setBarButtonItems(.thingButtons)
            
            existingAttribute.text = activeTextView.text
            existingAttribute.updated = Date().string
            save(existingAttribute)
            
            activeTextView.resignFirstResponder()
            
            //Canceled Attribute
        } else if canceledAttribute {
            activeTextView.resignFirstResponder()
            self.setBarButtonItems(.thingButtons)
            
        } else {
            activeTextView.resignFirstResponder()
        }
    }
    
    private func save(_ attribute: Attribute) {
        coordinator.save(attribute, closure: {
            self.removeNewTextAttributes()
        }, errorBlock: { e in
            self.showAlert(title: "Attribute Error", message: e)
        })
    }
    
    //New Text Attribute
    
    @objc func insertNewTextAttribute() {
        
        let newObject = Object(type: .attribute)
        let newTextAttribute = TextAttribute(from: newObject)
        
        guard let thing = self.thing else { fatalError() }
        
        newTextAttribute.parent = thing.id
        
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            
            thing.attributes.append(newTextAttribute)
            let i = thing.attributes.count - 1
            let lastIndex = IndexPath(row: i, section: 0)
            self.tableView.insertRows(at: [lastIndex], with: .fade)
            
            self.tableView.endUpdates()
            
            guard let textCell = self.lastCell() as? AttributeTextCell else {
                fatalError()
            }
            
            textCell.newAttributeTextView.text = ""
            textCell.newAttributeTextView.becomeFirstResponder()
            
            self.tableView.scrollToRow(at: lastIndex, at: .none, animated: true)
        }
    }
    
    fileprivate func lastCell() -> UITableViewCell {
        guard let thing = self.thing else { fatalError() }
        let i = thing.attributes.count - 1
        let lastIndex = IndexPath(row: i, section: 0)
        
        guard let cell = self.tableView.cellForRow(at: lastIndex) else {
            let cellOffset = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.bounds.size.height)
            self.tableView.setContentOffset(cellOffset, animated: false)
            
            return tableView.cellForRow(at: lastIndex)!
        }
        
        return cell
    }
    
    fileprivate func removeCell(at i: Int) {
        let index = IndexPath(row: i, section: 0)
        tableView.deleteRows(at: [index], with: .fade)
    }
    
    private func removeNewTextAttributes() {
        guard let thing = self.thing else {
            return
        }
        
        DispatchQueue.main.async {
            
            var indexes: [IndexPath] = []
            
            thing.attributes = thing.attributes.filter { attribute -> Bool in
                
                guard
                    let id = attribute.id,
                    let i = thing.attributes.index(where: { (attr) -> Bool in
                        guard
                            let id = attribute.id,
                            let _id = attr.id
                            else {
                                return true
                        }
                        
                        return id == _id
                    })
                    else {
                        
                        return false
                }
                
                guard id != "" else {
                    indexes.append(IndexPath(row: i, section: 0))
                    return false
                }
                
                switch attribute.type {
                case .image:
                    indexes.append(IndexPath(row: i, section: 0))
                    return false
                case .text:
                    let textAttribute = attribute as! TextAttribute
                    if textAttribute.text == nil ?? "" {
                        indexes.append(IndexPath(row: i, section: 0))
                        return false
                    }
                }
                
                return true
            }
            
            self.tableView.deleteRows(at: indexes, with: .fade)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        finishEditingTextAttribute()
    }
}
