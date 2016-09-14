//
//  ServicesTableInSubscription.swift
//  LHommeAToutFaire
//
//  Created by Can ATAC on 09/11/2015.
//  Copyright © 2015 Can ATAC. All rights reserved.
//

import UIKit


protocol ServicesTableInSubscriptionDelegate: class{
    var selectedServicesST:[String] {get set}
}

class ServicesTableInSubscription:UITableView, UITableViewDelegate, UITableViewDataSource{

    weak var delegateST:SubscriptionViewController?
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cellID")! as UITableViewCell
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellID")
        }
        cell!.textLabel!.text = delegateST!.selectedServicesST[indexPath.row]
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.frame = CGRectMake(0,0,self.frame.width,self.frame.height * CGFloat(delegateST!.selectedServicesST.count))
        return delegateST!.selectedServicesST.count
    }
}
