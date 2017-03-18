//
//  ThingViewController.swift
//  Things
//
//  Created by Brie Heutmaker on 4/18/16.
//  Copyright © 2016 Brie Heutmaker. All rights reserved.
//

import UIKit

enum AttributesButtonStyle {
    case thingButtons
    case done(backButtonHidden: Bool)
}

class AttributesViewController: UIViewController {
    
    //MARK: Declarations
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var iconImageView: UIImageView!
    
    var imageBarButtonItem: UIBarButtonItem!
    var textBarButtonItem: UIBarButtonItem!
    
    var doneBarButtonItem: UIBarButtonItem!
    
    var imagePicker: UIImagePickerController!
    var alert: UIAlertController!
    
    var thing: Thing?
    
    var refreshControl: UIRefreshControl!
    
    var activeTextView: UITextView?
    var oldText: String?
    var activeAttribute: Attribute?
    
    var activeProgressView: UIProgressView?
    
    var dateFormatter: DateFormatter!
    
    var coordinator: Coordinator!
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setBarButtonItems(.thingButtons)
        
        refresh()
        
        setIcon()
    }
    
    func refresh() {
        guard let thing = self.thing else {
            return
        }
        
        if !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
        }
        
        coordinator.getAllAttributes(from: thing, gotOne: { attribute in
            self.insert(attribute)
            
        }, errorBlock: { (e) in
            self.showAlert(withTitle: "Attribute Error", message: e)
            
        }) {
            self.endRefreshing()
        }
    }
    
    private func removeNewTextAttributes() {
        guard let thing = self.thing else {
            return
        }
        
        DispatchQueue.main.async {
            thing.attributes = thing.attributes.filter { attribute -> Bool in
                return attribute.id != ""
            }
            
            let firstSection = IndexSet(integer: 0)
            self.tableView.reloadSections(firstSection, with: .fade)
        }
    }
    
    private func insert(_ attribute: Attribute) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            
            guard let thing = self.thing else { return }
            
            let containsAttribute: Bool = thing.attributes.contains { _attribute in
                return _attribute.id == attribute.id
            }
            
            if containsAttribute {
                for i in 0..<thing.attributes.count {
                    let existingAttribute = thing.attributes[i]
                    
                    let same = existingAttribute.id == attribute.id
                    
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
                        if let imageAttribute = _attribute as? ImageAttribute {
//                            print(imageAttribute.id)
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
                        
//                        print("_textAttribute", _textAttribute.dict(), "\n", "textAttribute", textAttribute.dict())
                        
                        let sameText = _textAttribute.text == textAttribute.text
                        let noID = _textAttribute.id == ""
                        
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
                            return existingAttribute.id == attribute.id
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
                            thing.attributes.insert(attribute, at: 0)
                            self.tableView.insertRows(at: [firstIndexPath], with: .fade)
                        }
                    }
                }
            }
            
            self.tableView.endUpdates()
        }
        
        self.removeNewTextAttributes()
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
        
        //RefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(AttributesViewController.refresh),
                                 for: .valueChanged)
        
        tableView.addSubview(refreshControl)
    }
    
    func setBarButtonItems(_ style: AttributesButtonStyle) {
        
        switch style {
            
        case .thingButtons:
            
//            if imageBarButtonItem == nil {
//                let attributes = [NSFontAttributeName : UIFont.fontAwesomeOfSize(20)] as Dictionary!
//                imageBarButtonItem = UIBarButtonItem(title: String.fontAwesomeIconWithName(FontAwesome.Image),
//                                                     style: .plain,
//                                                     target: self,
//                                                     action: #selector(AttributesViewController.cameraButtonHandler))
//                imageBarButtonItem.setTitleTextAttributes(attributes, for: UIControlState())
//            }
            
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
                
//                OperationQueue.main.addOperation({ 
//                    self.navigationItem.setHidesBackButton(true, animated: true)
//                })
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
    
    private func endRefreshing() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
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
        
        if attribute.id == "" {
            return
        }
        
        coordinator.delete(attribute: attribute, closure: {
            print("Successfully deleted Attribute")
        }, errorBlock: { (e) in
            self.showAlert(withTitle: "Much Fail, Many Faults", message: "\(e)")
            
            DispatchQueue.main.async {
                thing.attributes.insert(cachedAttribute, at: indexPath.row)
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
        })
    }
    
    @objc private func finishEditingTextAttribute() {
        
        guard let activeTextView = activeTextView else {
//            print("activeTextView is nil when done button is pressed")
            return
        }
        
        guard let thing = self.thing else { return }
        
        let textViewPoint = activeTextView.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: textViewPoint) else { return }
        
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
            let newAttribute = TextAttribute(text: activeTextView.text, parent: thing)
            save(newAttribute)
            
            activeTextView.resignFirstResponder()
            self.setBarButtonItems(.thingButtons)
            
        //Updated Attribute
        } else if isUpdatedAttribute {
            
            guard let existingAttribute = thing.attributes[indexPath.row] as? TextAttribute else { return }
            
            existingAttribute.text = activeTextView.text
            existingAttribute.updated = Date().string
            update(existingAttribute)
            
            activeTextView.resignFirstResponder()
            self.setBarButtonItems(.thingButtons)
            
        //Canceled Attribute
        } else if canceledAttribute {
            activeTextView.resignFirstResponder()
            self.setBarButtonItems(.thingButtons)
            
        } else {
            activeTextView.resignFirstResponder()
        }
    }
    
    private func save(_ attribute: Attribute) {
        coordinator.save(attribute, closure: { attribute in
            self.insert(attribute)
        }, errorBlock: { e in
            self.showAlert(withTitle: "Attribute Error", message: e)
        })
    }
    
    private func update(_ attribute: Attribute) {
        coordinator.update(attribute, closure: { attribute in
            self.insert(attribute)
        }) { e in
            self.showAlert(withTitle: "Attribute Error", message: e)
        }
    }
    
    //New Text Attribute
    
    @objc func insertNewTextAttribute() {
        
        let newObject = Object(type: .attribute)
        let newTextAttribute = TextAttribute(from: newObject)
        
        guard let thing = self.thing else { fatalError() }
        
        newTextAttribute.parent = thing.id
        
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            
            thing.attributes.insert(newTextAttribute, at: 0)
            self.tableView.insertRows(at: [firstIndexPath], with: .fade)
            
            self.tableView.endUpdates()
            
            guard let newAttributeCell = self.tableView.cellForRow(at: firstIndexPath) as? AttributeTextCell else { fatalError() }
                
            newAttributeCell.newAttributeTextView.text = ""
            newAttributeCell.newAttributeTextView.becomeFirstResponder()
        }
    }
    
}
