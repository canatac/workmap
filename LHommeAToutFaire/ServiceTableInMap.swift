//
//  ServiceTableInMap.swift
//  LHommeAToutFaire
//
//  Created by Can ATAC on 26/11/2015.
//  Copyright © 2015 Can ATAC. All rights reserved.
//

import UIKit



class ServiceTableInMap: UITableView, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    weak var delegateSTIM:ServicesMapController?
    
    var data:[String]       =   [String]()
    var labels:[String]     =   [String]()
    var services:[String]   =   [String]()
    var height:CGFloat      =   30.0
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return labels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cellID") as UITableViewCell!
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellID")
        }
        let textView:UITextView     =   UITextView(frame: CGRectMake(10.0, 10.0, 200.0, 20.0))
        textView.font               =   UIFont.systemFontOfSize(10.0)
        textView.text               =   labels[indexPath.row]
        textView.editable           =   false

        cell.contentView.addSubview(textView)
        
        if labels[indexPath.row].containsString("Services"){
            let serviceView                 =   UITableView(frame: CGRectMake(110.0, 10.0, 150.0, 100.0))
            serviceView.dataSource          =   delegateSTIM
            serviceView.delegate            =   delegateSTIM
            serviceView.separatorStyle      =   UITableViewCellSeparatorStyle.None
            cell.contentView.addSubview(serviceView)
            
        }else{
            let textView2:UITextView        =   UITextView(frame: CGRectMake(110.0, 10.0, 150.0, 20.0))
            textView2.font                  =   UIFont.systemFontOfSize(10.0)
            textView2.text                  =   data[indexPath.row]
            textView2.editable              =   false
            
            if labels[indexPath.row].containsString("Téléphone"){
                textView2.dataDetectorTypes     =   UIDataDetectorTypes.PhoneNumber
                textView2.delegate              =   self
            }
            if labels[indexPath.row].containsString("Adresse"){
                textView2.dataDetectorTypes     =   UIDataDetectorTypes.Address
                textView2.delegate              =   self
            }
            if labels[indexPath.row].containsString("Email"){
                textView2.dataDetectorTypes     =   UIDataDetectorTypes.Link
                textView2.delegate              =   self
            }
            
            var textViewFrame                           =   textView2.frame
            textViewFrame.size.height                   =   self.heightForTextView(textView2) //The 10 value is to retrieve the same height padding I inputed earlier when I initialized the UITextView
            textView2.frame                              =   textViewFrame
            cell.contentView.addSubview(textView2)
        }
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 6 {
            return 200
        }
        return height
    }
    
    func heightForTextView(textView:UITextView) -> CGFloat {

        height  =   30.0
        
        let numberOfLines:Int   =   Int((textView.contentSize.height / textView.font!.lineHeight)) - 1
                
        height += (textView.font!.lineHeight) * CGFloat(numberOfLines - 1)

        print("HEIGHT RETURNED : \(height)")
        return height
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let activityViewController = UIActivityViewController(activityItems: [textView.text, URL], applicationActivities: nil)
        
        activityViewController.setValue("Homme à tout faire : Information", forKey: "subject")
        
        if delegateSTIM!.presentedViewController != nil {
            delegateSTIM!.dismissViewControllerAnimated(false, completion: {
                [unowned self] in
                self.delegateSTIM!.presentViewController(activityViewController, animated: true, completion: nil)
                })
        }else{
            delegateSTIM!.presentViewController(activityViewController, animated: true, completion: nil)
        }
        
        return false
    }
    
}
