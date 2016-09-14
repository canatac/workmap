//
//  ViewController.swift
//  L'Homme A Tout Faire
//
//  Created by Can ATAC on 07/10/2015.
//  Copyright © 2015 Can ATAC. All rights reserved.
//

import UIKit
import yall
import MapKit

class MyViewController: UIViewController {


    @IBOutlet weak var goToFormButton: UIButton!
    
    @IBOutlet weak var goToAskerMapButton: UIButton!
    
    @IBOutlet weak var goToProviderMapButton: UIButton!
    
    var gpsResult : CLLocation!             =   CLLocation()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "providersMapSegue"{
            let vc = segue.destinationViewController as! ServicesMapController
            vc.serviceActor = "PROVIDER"
        }
        if segue.identifier == "askersMapSegue"{
            let vc = segue.destinationViewController as! ServicesMapController
            vc.serviceActor = "ASKER"
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // IF PROFILE CREATED => UPDATE MODE, IF NOT => CREATION MODE
        // CHECK SERVER IF UDID EXISTS
        let label:String    =   NSUserDefaults.standardUserDefaults().stringForKey("serviceActorId") != nil ? "Bonjour \(NSUserDefaults.standardUserDefaults().stringForKey("serviceActorName")!) !":"Créer"
        
        self.goToFormButton .setTitle(label, forState: UIControlState.Normal)
        self.goToFormButton.titleLabel?.textAlignment   =   NSTextAlignment.Center
        self.goToFormButton.setBackgroundImage(self.imageWithColor(UIColor.redColor()), forState: UIControlState.Highlighted)


        if (NSUserDefaults.standardUserDefaults().valueForKey("userLatitude") != nil &&
            NSUserDefaults.standardUserDefaults().valueForKey("userLongitude") != nil){
               gpsResult = CLLocation(latitude: NSUserDefaults.standardUserDefaults().valueForKey("userLatitude") as! Double, longitude: NSUserDefaults.standardUserDefaults().valueForKey("userLongitude") as! Double)
                let askers:Dictionary       =   ServiceActorAPI.getListWithMyLocation("ASKER",location: gpsResult)
                let providers:Dictionary    =   ServiceActorAPI.getListWithMyLocation("PROVIDER",location: gpsResult)
                self.goToAskerMapButton .setTitle("Carte des Demandes \n(\(askers.count))", forState: UIControlState.Normal)
                self.goToProviderMapButton .setTitle("Carte des Offres \n(\(providers.count))", forState: UIControlState.Normal)
        }

        self.goToAskerMapButton.titleLabel?.textAlignment       =   NSTextAlignment.Center
        self.goToProviderMapButton.titleLabel?.textAlignment    =   NSTextAlignment.Center
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageWithColor(color:UIColor) -> UIImage {
        let rect:CGRect = CGRectMake(0.0, 0.0, 1.0, 1.0)
    
        UIGraphicsBeginImageContext(rect.size);
    
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
    
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
    
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return image
    }

}

