//
//  ServicesTableTableViewController.swift
//  LHommeAToutFaire
//
//  Created by Can ATAC on 16/10/2015.
//  Copyright © 2015 Can ATAC. All rights reserved.
//

import UIKit

protocol ServicesTableViewControllerDelegate: class{
    func selectedServices(services: [String])
}


class ServicesTableViewController: UITableViewController {

    let services = [
        "Travaux peinture",
        "Livraison",
        "Travaux voiture",
        "Cuisine",
        "Animation soirée",
        "Garde d'enfants",
        "Gestion passeport",
        "Covoiturage",
        "Enseignement",
        "Location"]
    
    weak var delegate:SubscriptionViewController?
    
    var selectedServices:[String] = []
    let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedServices.count == 0 {
            selectedServices = [String](count: services.count, repeatedValue: "")
        }

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(false)
        self.delegate?.selectedServices(selectedServices)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        cell.textLabel?.textColor = UIColor.blackColor()
        cell.textLabel?.text = services[indexPath.row]
        
        for var i = 0; i < self.selectedServices.count; i++ {
            let myRegex = services[indexPath.row]
            if (self.selectedServices[i].rangeOfString(myRegex, options: .RegularExpressionSearch) != nil){
               self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        for var i = 0; i < self.selectedServices.count; i++ {
            let myRegex = services[indexPath.row]
            if (self.selectedServices[i].rangeOfString(myRegex, options: .RegularExpressionSearch) != nil){
                selectedServices.removeAtIndex(i)
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedServices.insert(services[indexPath.row],atIndex: selectedServices.count)
    }
}
