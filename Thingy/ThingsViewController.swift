
//  ThingsViewController.swift
//  Thingy
//
//  Created by Benjamin Heutmaker on 11/18/15.
//  Copyright © 2015 Ben Heutmaker. All rights reserved.
//

import UIKit

class ThingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewThingCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var emptyView: UIView!
    
    var datasource: [Objectified] = []
    
    var selectedIndexPath: IndexPath?
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ThingsViewController.downloadAllTheThings), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        toggleEmptyView()
        
        downloadAllTheThings()
    }
    
    func downloadAllTheThings() {
        self.datasource = []
        tableView.reloadData()
        
        Coordinator.default.getAllThings(
            gotOne: { (newThing) in
                self.insertNew(thing: newThing, atBeginning: true)
                
        }, errorBlock: { (e) in
            self.showAlert(withTitle: "Thing Error", message: e)
            self.stopRefreshing()
        }) {
            self.stopRefreshing()
        }
        
        toggleEmptyView()
    }
    
    private func stopRefreshing() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    func toggleEmptyView() {
        if self.datasource.isEmpty {
            self.emptyView.frame = self.tableView.frame
            
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.backgroundView = self.emptyView
            })
            
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.backgroundView = nil
            })
        }
    }
    
    //New Thing
    
    @IBAction func newThingButtonHandler(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        
        toggleEmptyView()
        
        let newObject = Object(type: .new)
        datasource.insert(newObject, at: 0)
        
        tableView.reloadSections([0], with: .fade)
        
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRowAction = UITableViewRowAction(style: .default, title: "Delete") { (action, actionIndexPath) -> Void in
            
            guard let thing = self.datasource[indexPath.row] as? Thing else { fatalError() }
            let cachedThing = thing
            
            self.datasource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            
            Coordinator.default.delete(thing: thing, closure: { (success) in
                if !success {
                    let alert = UIAlertController(title: "Deleting That Thing Failed", message: "Could not delete that thing. Sorry. (It's the server thing's fault, not yours)", preferredStyle: .alert)
                    let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    alert.addAction(okay)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    self.datasource.insert(cachedThing, at: indexPath.row)
                    tableView.insertRows(at: [indexPath], with: .top)
                    
                }
            })
        }
        
        return [deleteRowAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath) is NewThingCell {
            return
        }
        
        if splitViewController!.isCollapsed {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        selectedIndexPath = indexPath
        performSegue(withIdentifier: SegueKey.showDetail, sender: nil)
    }
    
    //MARK: NewThingCellDelegate
    
    func didCancelNewThing() {
        removeNewThingCell()
    }
    
    func didSave(new thing: Thing) {
        removeNewThingCell()
        insertNew(thing: thing, atBeginning: true)
    }
    
    func insertNew(thing: Thing, atBeginning: Bool) {
        
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
                
                for index in 0...self.datasource.capacity {
                    
                    if index > self.datasource.capacity {
                        return
                    }
                    
                    let object = self.datasource[index]
                    
                    if object.objectType.isNew {
                        self.datasource.remove(at: index)
                        let indexPath = IndexPath(row: index, section: 0)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
            
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.toggleEmptyView()
        }
    }
    
    @IBAction func dismissSettingsPopover(sugue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = selectedIndexPath {
            guard let thing = datasource[indexPath.row] as? Thing else { fatalError() }
            
            if segue.identifier == SegueKey.showDetail {
                
                guard
                    let navigationController = segue.destination as? UINavigationController,
                    let detailViewController = navigationController.childViewControllers[0] as? AttributesViewController
                else {
                    fatalError()
                }
                
                detailViewController.thing = thing
            }
        }
    }
}
