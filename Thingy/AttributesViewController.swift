//
//  ThingViewController.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 4/18/16.
//  Copyright © 2016 Ben Heutmaker. All rights reserved.
//

import UIKit

enum AttributesButtonStyle {
    case thingButtons
    case done(backButtonHidden: Bool)
}

class AttributesViewController: UIViewController {
    
    //MARK: Declarations
    
    var coordinator = Coordinator.default
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
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
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setBarButtonItems(.thingButtons)
        
        refresh()
        
        setIcon()
    }
    
    func refresh() {
        if !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
        }
        
        guard let thing = self.thing else {
            return
        }
        
        Coordinator.default.getAllAttributes(from: thing, gotOne: { attribute in
            self.insert(new: attribute)
            
        }, errorBlock: { (e) in
            self.showAlert(withTitle: "Attribute Error", message: e)
            
        }) { 
            self.endRefreshing()
        }
    }
    
    private func insert(new attribute: Attribute) {
        
        guard let thing = self.thing else {
            return
        }
        
        if thing.attributes.isEmpty {
            thing.attributes.append(attribute)
            
        } else {
            let exists: Bool = thing.attributes.contains { existingAttribute in
                let same = existingAttribute.id == attribute.id
                
                if same {
                    return true
                } else {
                    return false
                }
            }
            
            if exists {
                let updatedAttributes = thing.attributes.map { existingAttribute -> Attribute in
                    let same = existingAttribute.id == attribute.id
                    
                    if same {
                        return attribute
                    } else {
                        return existingAttribute
                    }
                }
                
                thing.attributes.removeAll()
                thing.attributes.append(contentsOf: updatedAttributes)
                
            } else {
                thing.attributes.insert(attribute, at: 0)
            }
        }
        
        DispatchQueue.main.async {
            let firstSection = IndexSet(integer: 0)
            self.tableView.reloadSections(firstSection, with: .fade)
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
    
    @objc private func finishEditingTextAttribute() {
        
        guard let activeTextView = activeTextView else {
            print("activeTextView is nil when done button is pressed")
            return
        }
        
        print("\n", "activeTextView.text:", "\"\(activeTextView.text!)\"", "oldText:", "\"\(oldText!)\"", "Equal Values:", activeTextView.text! == oldText!)
        
        let isNewAttribute = (oldText == "" && activeTextView.text != "")
        let isUpdatedAttribute = (oldText != "" && oldText != activeTextView.text)
        let canceledAttribute = (oldText == activeTextView.text)
        
        guard let thing = self.thing else { return }
        
        //New Attribute
        if isNewAttribute {
            let newAttribute = TextAttribute(text: activeTextView.text, parent: thing)
            
            activeTextView.resignFirstResponder()
            self.setBarButtonItems(.thingButtons)
            
            save(newAttribute)
            
            
        //Updated Attribute
        } else if isUpdatedAttribute {
            
            let textViewPoint = activeTextView.convert(CGPoint.zero, to: tableView)
            
            guard let indexPath = tableView.indexPathForRow(at: textViewPoint) else { return }
            guard var existingAttribute = thing.attributes[indexPath.row] as? TextAttribute else { return }
            
            existingAttribute.text = activeTextView.text
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
        Coordinator.default.save(attribute, closure: { attribute in
            self.insert(new: attribute)
            
        }, errorBlock: { e in
            self.showAlert(withTitle: "Attribute Error", message: e)
        })
    }
    
    private func update(_ attribute: Attribute) {
        Coordinator.default.update(attribute, closure: { attribute in
            self.insert(new: attribute)
            
        }) { e in
            self.showAlert(withTitle: "Attribute Error", message: e)
        }
    }
    
    //New Text Attribute
    
    @objc func insertNewTextAttribute() {
        
        let newObject = Object(type: .attribute)
        var newTextAttribute = TextAttribute(from: newObject)
        
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
