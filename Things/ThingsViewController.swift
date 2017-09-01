
//  ThingsViewController.swift
//  Things
//
//  Created by Brianna Lee on 11/18/15.
//  Copyright © 2015 Exoteric Design. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ThingsViewController: EDTableViewController, UITableViewDataSource, UITableViewDelegate, NewThingCellDelegate {
    
    var datasource: [Objectified] = []
    
    var selectedIndexPath: IndexPath?
    var coordinator: Coordinator!
    
    var thingAddedObserver: DatabaseHandle!
    var thingChangedObserver: DatabaseHandle!
    var thingRemovedObserver: DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "All The Things"
        
        type = .things
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        toggleEmptyView()
        
        if coordinator == nil {
            coordinator = Coordinator()
        }
        
        setThingsObservers()
    }
    
    private func setThingsObservers() {
        guard let uid = AppState.shared.uid else {
            return
        }
        
        let allTheThingsRef = Database.database().reference().child("humans/\(uid)/things/")
        
        allTheThingsRef.keepSynced(true)
        
        thingAddedObserver = allTheThingsRef.observe(.childAdded, with: { (snapshot) in
            let dict = snapshot.value as! [String : Any]
            let thing = Thing(from: dict)
            self.insert(thing, atBeginning: true)
            self.toggleEmptyView()
        })
        
        thingChangedObserver = allTheThingsRef.observe(.childChanged, with: { (snapshot) in
            let dict = snapshot.value as! [String : Any]
            let thing = Thing(from: dict)
            
            let index = self.indexOf(thing)!
            self.datasource[index] = thing
            let row = IndexPath(row: index, section: 0)
            self.tableView.reloadRows(at: [row], with: .automatic)
            self.toggleEmptyView()
        })
        
        thingRemovedObserver = allTheThingsRef.observe(.childRemoved, with: { (snapshot) in
            let dict = snapshot.value as! [String : Any]
            let thing = Thing(from: dict)
            
            guard let index = self.indexOf(thing) else { return }
            self.datasource.remove(at: index)
            let row = IndexPath(row: index, section: 0)
            self.tableView.deleteRows(at: [row], with: .automatic)
            self.toggleEmptyView()
        })
    }
    
    func indexOf(_ thing: Thing) -> Int? {
        
        for i in 0..<datasource.count {
            let object = datasource[i]
            if object.id == thing.id {
                return i
            }
        }
        
        return nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Database.database().reference().removeAllObservers()
    }
    
    //New Thing
    
    @IBAction func newThingButtonHandler(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        
        let newObject = Object(type: .new)
        datasource.insert(newObject, at: 0)
        
        tableView.beginUpdates()
        tableView.reloadSections([0], with: .fade)
        tableView.insertRows(at: [firstIndexPath], with: .fade)
        tableView.endUpdates()
        
        toggleEmptyView()
        
        guard let newThingCell = tableView.cellForRow(at: firstIndexPath) as? NewThingCell else {
            fatalError()
        }
        
        newThingCell.newThingTextField.placeholder = "New thing..."
        newThingCell.newThingTextField.becomeFirstResponder()
        
    }
    
    
    //UITableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let object = datasource[indexPath.row]
        
        switch object.objectType {
            
        case .new:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellKey.newThing) as? NewThingCell else { fatalError() }
            
            cell.delegate = self
            cell.coordinator = self.coordinator
            
            cell.icons = Array(FontAwesomeIcons.values)
            
            return cell
            
        case .thing:
            guard let thing = object as? Thing else { fatalError() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellKey.thing) as? ThingCell else { fatalError() }
            
            if let thingIcon = thing.icon {
                cell.thingIconImageView.image = iconFromCode(thingIcon, tintColor: self.view.tintColor)
                
            } else {
                let icon = randomFontAwesomeCode()
                thing.icon = icon
                cell.thingIconImageView.image = iconFromCode(icon!, tintColor: self.view.tintColor)
            }
            
            cell.thingLabel?.text = thing.name
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if datasource[indexPath.row] is Object {
            return false
        
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let object = datasource[indexPath.row]
        
        switch object.objectType {
        case .thing:
            return UITableViewAutomaticDimension
        case .new:
            return 252
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRowAction = UITableViewRowAction(style: .default, title: "Delete") { (action, actionIndexPath) -> Void in
            
            let alert = UIAlertController(title: "Are you sure you want to delete this Thing?", message: "This cannot be undone!", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes, Delete", style: .destructive) { action in
                self.deleteThing(at: indexPath)
            }
            let no = UIAlertAction(title: "No, Stay", style: .cancel, handler: nil)
            alert.addAction(yes)
            alert.addAction(no)
            self.present(alert, animated: true, completion: nil)
        }
        
        return [deleteRowAction]
    }
    
    fileprivate func deleteThing(at indexPath: IndexPath) {
        guard let thing = self.datasource[indexPath.row] as? Thing else { fatalError() }
        let cachedThing = thing
        
        self.datasource.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .top)
        
        self.coordinator.delete(thing: thing, closure: {
            self.toggleEmptyView()
            if indexPath == self.selectedIndexPath {
                self.selectedIndexPath = nil
                self.performSegue(withIdentifier: SegueKey.showDetail, sender: nil)
            }
            
        }, errorBlock: { (e) in
            self.showAlert(title: "Failed Delete", message: e)
            
            DispatchQueue.main.async {
                self.datasource.insert(cachedThing, at: indexPath.row)
                self.tableView.insertRows(at: [indexPath], with: .top)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath) is NewThingCell {
            return
        }
        
        selectedIndexPath = indexPath
        performSegue(withIdentifier: SegueKey.showDetail, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath) is NewThingCell {
            return
        }
        
        selectedIndexPath = nil
        performSegue(withIdentifier: SegueKey.showDetail, sender: nil)
    }
    
    //MARK: NewThingCellDelegate
    
    func didCancelNewThing() {
        removeNewThingCell()
    }
    
    func didSaveNewThing() {
        removeNewThingCell()
    }
    
    func didFail(with error: String) {
        self.showAlert(title: "Save Failed", message: error)
    }
    
    private func insert(_ thing: Thing, atBeginning: Bool) {
        
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            
            thing.objectType = .thing
            
            if atBeginning {
                if self.datasource.count == 0 {
                    self.datasource.append(thing)
                    
                } else {
                    self.datasource.insert(thing, at: 0)
                }
                self.tableView.insertRows(at: [firstIndexPath], with: .fade)
                
            } else {
                self.datasource.append(thing)
                
                let lastIndex = IndexPath(row: self.datasource.count - 1, section: 0)
                self.tableView.insertRows(at: [lastIndex], with: .automatic)
            }
            
            self.tableView.endUpdates()
            
            self.toggleEmptyView()
        }
    }
    
    func removeNewThingCell() {
        DispatchQueue.main.async {
            if self.datasource.first?.objectType == .new {
                self.datasource.remove(at: 0)
                self.tableView.deleteRows(at: [firstIndexPath], with: .fade)
                
            } else {
                
                if let validIndex = (self.datasource.index{$0.objectType.isNew}) {
                    self.datasource.remove(at: validIndex)
                    let indexPath = IndexPath(row: validIndex, section: 0)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.toggleEmptyView()
        }
    }
    
    @IBAction func dismissSettingsPopover(sugue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "settingsSegue" {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let settingsController = navigationController.viewControllers.first as? SettingsViewController
                else {
                    return
            }
            
            settingsController.coordinator = self.coordinator
        }
        
        if segue.identifier == SegueKey.showDetail {
            
            guard
                let navigationController = segue.destination as? UINavigationController,
                let detailViewController = navigationController.viewControllers.first as? AttributesViewController
                else {
                    return
            }
            
            guard
                let indexPath = selectedIndexPath,
                let thing = datasource[indexPath.row] as? Thing
                else {
                    detailViewController.thing = nil
                    detailViewController.toggleEmptyView()
                    return
            }
            
            detailViewController.thing = thing
            detailViewController.coordinator = self.coordinator
        }
    }
}
