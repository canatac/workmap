//
//  SubscriptionViewController.swift
//  L'Homme A Tout Faire
//
//  Created by Can ATAC on 07/10/2015.
//  Copyright © 2015 Can ATAC. All rights reserved.
//

import UIKit
import MapKit
import yall


class SubscriptionViewController: UITableViewController, UITextViewDelegate, CLLocationManagerDelegate,ServicesTableViewControllerDelegate, ServicesTableInSubscriptionDelegate  {


    @IBOutlet weak var myName: UITextView!
    @IBOutlet weak var mySurname: UITextView!
    @IBOutlet weak var myAddress: UITextView!
    @IBOutlet weak var myMobileNumber: UITextView!
    @IBOutlet weak var myEmail: UITextView!
        
    @IBOutlet weak var validationIBOutlet: UIButton!
    @IBOutlet weak var geoLocMeIBOutlet: UIButton!
    @IBOutlet weak var askerButton: UIButton!
    @IBOutlet weak var providerButton: UIButton!
    
    @IBOutlet weak var servicesTableView: ServicesTableInSubscription!
    
    var serviceActor:String                     =   ""
    var actorId:String                          =   ""
    var textViewNameTags:[Int:String]           =   [:]
    var viewName:[String:UITextView]            =   [:]
    var tableViewCells:[String:CGFloat]         =   [:]
    var cellTextView:UITextView!
    var numberOfLines:Int                       =   0
    
    var numberOfLineByCellSection1:[String:Int] =   [:]
    var numberOfLineByCellSection2:[String:Int] =   [:]

    var indicatorV:UIActivityIndicatorView      =   UIActivityIndicatorView(activityIndicatorStyle: .White)
    var gpsResult : CLLocation!                 =   CLLocation()
    var locationManager:CLLocationManager!
    var pm:CLPlacemark!
    var height:Int                              =   44
    let servicesTB                              =   ServicesTableInSubscription()
    var selectedServicesST:[String]             =   ["Aucun"]
    var geoPoint:[String:Double]                =   [String:Double]()

    
    @IBAction func geoLocMeButton(sender: AnyObject) {

        UIView.animateWithDuration(0.2, animations: {
            
            self.view.userInteractionEnabled = false
            self.view.endEditing(true)
            }, completion: {
                _ in
                UIView.animateWithDuration(0.5, animations: {
                    
                    self.indicatorV.color                   =   UIColor.whiteColor()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.indicatorV.backgroundColor     =   UIColor(white:0.2,alpha:0.6)
                    })
                    
                    self.indicatorV.layer.cornerRadius      =   10
                    self.indicatorV.frame                   =   (sender as! UIButton).frame
                    self.indicatorV.center                  =   (sender as! UIButton).center
                    
                    self.validationIBOutlet.alpha           =   0.0
                    self.geoLocMeIBOutlet.titleLabel!.text  =   ""
                    self.geoLocMeIBOutlet.superview!.addSubview(self.indicatorV)
                    
                    self.indicatorV.startAnimating()
                    self.myAddress.backgroundColor          =   UIColor(red: 0.0, green: 250.0, blue: 0.0, alpha: 0.2)
                    
                    },completion:{
                        _ in self.locationManager.requestLocation()
                })
        })
    }
    
    @IBAction func serviceProviderButton(sender: AnyObject) {
        
        self.spButtonAnimation()
    }
    
    @IBAction func serviceAskerButton(sender: AnyObject) {
        
        self.saButtonAnimation()
    }

    private func spButtonAnimation(){
        self.providerButton.alpha               =   0.0
        self.askerButton.alpha                  =   0.0
        self.providerButton.titleLabel?.font    =   UIFont.boldSystemFontOfSize(10)
        self.askerButton.titleLabel?.font       =   UIFont.italicSystemFontOfSize(10)
        
        UIView.animateWithDuration(0.5, animations: {
            self.providerButton.setTitle("Je propose !", forState: UIControlState.Highlighted)
            self.askerButton.setTitle("Je ne demande pas", forState:UIControlState.Highlighted)
            
            }, completion: {
                _ in
                UIView.animateWithDuration(0.5, animations: {
                    self.providerButton.titleLabel?.font    =   UIFont.boldSystemFontOfSize(20)
                    self.providerButton.setTitle("Je propose !", forState: UIControlState.Normal)
                    self.askerButton.setTitle("Je ne demande pas", forState:UIControlState.Normal)
                    self.providerButton.alpha               =   1.0
                    self.askerButton.alpha                  =   1.0
                })
                self.validate(self.getAllData())
        })
        
        serviceActor="PROVIDER"
    }
    
    private func saButtonAnimation(){
        self.providerButton.alpha               =   0.0
        self.askerButton.alpha                  =   0.0
        self.askerButton.titleLabel?.font       =   UIFont.boldSystemFontOfSize(10)
        self.providerButton.titleLabel?.font    =   UIFont.italicSystemFontOfSize(10)
        
        UIView.animateWithDuration(0.5, animations: {
            self.askerButton.setTitle("Je demande !", forState: UIControlState.Highlighted)
            self.providerButton.setTitle("Je ne propose pas", forState: UIControlState.Highlighted)
            
            }, completion: { _ in
                UIView.animateWithDuration(0.5, animations: {
                    self.askerButton.titleLabel?.font   =   UIFont.boldSystemFontOfSize(20)
                    self.askerButton.setTitle("Je demande !", forState: UIControlState.Normal)
                    self.providerButton.setTitle("Je ne propose pas", forState: UIControlState.Normal)
                    self.providerButton.alpha           =   1.0
                    self.askerButton.alpha              =   1.0
                })
                self.validate(self.getAllData())
        })
        
        serviceActor="ASKER"
    }
    
    @IBAction func validationButton(sender: AnyObject) {
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.view.userInteractionEnabled = false
            self.view.endEditing(true)
            
                        }, completion: {
                _ in
                UIView.animateWithDuration(0.5, animations: {
                    
                    self.indicatorV.color                   =   UIColor.whiteColor()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.indicatorV.backgroundColor     =   UIColor(white:0.2,alpha:0.6)
                    })
                    
                    self.indicatorV.layer.cornerRadius      =   10
                    self.indicatorV.frame                   =   CGRectMake(CGRectGetMidX(self.view.bounds) - 50, CGRectGetMidY(self.view.bounds) - 50, 50.0, 50.0)

                    self.validationIBOutlet.alpha           =   0.0
                    self.view.addSubview(self.indicatorV)
                    self.indicatorV.startAnimating()
                    
                    },completion:{
                        _ in self.goCreateServiceActor()
                })
        })
    }
    
    /////////////
    
    override func viewDidLayoutSubviews()
    {
        self.indicatorV.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
    }
    
    /////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfLines = 1
        providerButton.setTitle("Je propose ?", forState: UIControlState.Normal)
        askerButton.setTitle("je demande ?", forState:UIControlState.Normal)
        
        self.viewName                           =   [String:UITextView]()
        self.tableViewCells                     =   [String:CGFloat]()
        self.numberOfLineByCellSection1         =   [String:Int]()
        self.numberOfLineByCellSection2         =   [String:Int]()

        self.textViewNameTags                   =   [1:"Name",2:"Surname",3:"Address",5:"Phone",6:"Email"]
        
        myName.delegate                         =   self
        mySurname.delegate                      =   self
        myAddress.delegate                      =   self
        myMobileNumber.delegate                 =   self
        myEmail.delegate                    	=   self
        
        servicesTableView.delegate              =   servicesTB
        servicesTableView.dataSource            =   servicesTB
        servicesTB.delegateST               	=   self
        
        validationIBOutlet.alpha                =   0.0
        validationIBOutlet.enabled              =   false
        
        self.locationManager                	=   CLLocationManager()
        self.locationManager.delegate           =   self
        self.locationManager.distanceFilter     =   10
        self.locationManager.desiredAccuracy    =   kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        
        self.getActorIfExist()
    }

    /////////////
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.startAnimating(textView)
    }
    func textViewDidEndEditing(textView: UITextView) {
        self.stopAnimating(textView)
    }
    /////////////
    
    func getActorIfExist(){
        
        if NSUserDefaults.standardUserDefaults().stringForKey("serviceActorId") != nil ||
            (
            NSUserDefaults.standardUserDefaults().stringForKey("serviceActorId") == nil &&
            ServiceActorAPI.getServiceActorWithUDID() != nil
            ){
                self.loadForm()
        }
    }
    
    /////////////
    
    func getNSUserDefaultData(){
        actorId                 =   NSUserDefaults.standardUserDefaults().stringForKey("serviceActorId")!
        myName.text             =   NSUserDefaults.standardUserDefaults().stringForKey("serviceActorName")
        mySurname.text          =   NSUserDefaults.standardUserDefaults().stringForKey("serviceActorSurname")
        myAddress.text          =   NSUserDefaults.standardUserDefaults().stringForKey("serviceActorAddress")
        myMobileNumber.text     =   NSUserDefaults.standardUserDefaults().stringForKey("serviceActorMobileNumber")
        myEmail.text            =   NSUserDefaults.standardUserDefaults().stringForKey("serviceActorEmail")
        geoPoint                =   [String:Double]()
        geoPoint["latitude"]    =   (NSUserDefaults.standardUserDefaults().objectForKey("serviceActorGeoPointLatitude") as! Double)
        geoPoint["longitude"]   =   (NSUserDefaults.standardUserDefaults().objectForKey("serviceActorGeoPointLongitude") as! Double)
        
        self.selectedServicesST = [String]()
        
        for service in NSUserDefaults.standardUserDefaults().objectForKey("serviceActorServices") as! [String]{
            self.selectedServicesST.append(service)
        }
    }
    
    func loadForm(){
        self.getNSUserDefaultData()
        
        servicesTableView.reloadData()
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        if NSUserDefaults.standardUserDefaults().stringForKey("serviceActorType") == "ASKER" {
            self.saButtonAnimation()
        }
        if NSUserDefaults.standardUserDefaults().stringForKey("serviceActorType") == "PROVIDER" {
            self.spButtonAnimation()
        }
        
        self.view.userInteractionEnabled    =   true
    }
    
    ////////////
    
    func getAllData()->[String:String]{
        var data = [String:String]()
        data["Name"]        =   myName.text!
        data["Surname"]     =   mySurname.text!
        data["Address"]     =   myAddress.text!
        data["Phone"]       =   myMobileNumber.text!
        data["Email"]       =   myEmail.text!
        return data    
    }

    func validate(data:[String:String]){
    
        ValidatorAPI().validateAllDataWithCompletion(data, completionHandler: { (result,error) -> Void in
            if result.0 {
                self.validationIBOutlet.alpha    =   1.0
                self.validationIBOutlet.enabled  =   true

            } else {
                self.validationIBOutlet.alpha    =   0.0
                self.validationIBOutlet.enabled  =   false
            }
            for key in result.1.keys {
                //print("Dic Results : \(key)-\(result.1[key]!)")
                if result.1[key]==false {
                    let textView:UITextView = self.viewName[key]!
                    textView.backgroundColor = UIColor(red: 250.0, green: 0.0, blue: 0.0, alpha: 0.2)
                    
                }else
                    if result.1[key]==true {
                        let textView:UITextView = self.viewName[key]!
                        textView.backgroundColor = UIColor(red: 0.0, green: 250.0, blue: 0.0, alpha: 0.2)
                }
                
            }
            if (error != nil) {
                print("PROD ERROR : \(error)")
            }
            
        })
    }
    
    func textViewDidChange(textView:UITextView) {
        
        height                                      =   44
        
        self.cellTextView                           =   nil
        
        self.validate(self.getAllData())
        
        numberOfLines                               =   Int((textView.contentSize.height / textView.font!.lineHeight)) - 1;
        
        let row:Int                                 =   textView.tag - 1 // UITEXTFIELDS TAG BEGIN AT 1. LETTING ALL OTHERS AT 0.
        
        self.numberOfLineByCellSection1["\(row)"]   =   numberOfLines
        
        height += (Int(textView.font!.lineHeight) * (numberOfLines - 1))
        
        self.tableViewCells["\(row)"]               =   CGFloat(height)//?
        
        var textViewFrame                           =   textView.frame
        textViewFrame.size.height                   =   CGFloat(height - 10) //The 10 value is to retrieve the same height padding I inputed earlier when I initialized the UITextView
        textView.frame                              =   textViewFrame
        
        textView.contentInset                       =   UIEdgeInsetsZero
        
        self.cellTextView                           =   textView // FOR REUSE IN RESIZING CELL HEIGHT
        
        self.tableView.beginUpdates();
        self.tableView.endUpdates();
        
    }
    
    private func goCreateServiceActor(){
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "stopIndicator:",
            name: "net.canatac.hommeatoutfaire.serviceactormg.save.ok",
            object: nil)
        if actorId == "" {
            ServiceActorAPI.createServiceActor(serviceActor,formData: self.getAllData(), services:selectedServicesST, geoPoint:geoPoint)
        }else{
            ServiceActorAPI.updateServiceActor(actorId, serviceActor: serviceActor,formData: self.getAllData(), services:selectedServicesST, geoPoint:geoPoint)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0
        {return 6}
        if section==1
        {return 3}
        return 0
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tempView:UIView = UIView(frame: CGRectMake(0,0,300,44))
        tempView.backgroundColor    =   UIColor(red: 0.337, green: 0.349, blue: 0.929, alpha: 0.75)
        
        let tempLabel:UILabel       =   UILabel(frame: CGRectMake(15,0,300,30))
        tempLabel.textColor         =   UIColor.whiteColor()
        
        tempLabel.text  =  section == 0 ?  "Informations Personnelles" : "Prestations"
        tempLabel.font = UIFont.boldSystemFontOfSize(12.0)
        
        tempView.addSubview(tempLabel)
        
        return tempView
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
            if (indexPath.row == tableView.indexPathsForVisibleRows!.last?.row &&
                indexPath.section == tableView.indexPathsForVisibleRows!.last?.section){
                
                for key in textViewNameTags.keys{
                        viewName[textViewNameTags[key]!] = (self.tableView.viewWithTag(key) as! UITextView)
                    if ((self.cellTextView) == nil) {
                       self.tableViewCells["\(indexPath.row)"] = CGFloat(height)
                    }
                }
            }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tmpHeight:Int = 44
        if (indexPath.section == 0){
                if ((self.cellTextView) != nil) {
                        if self.tableViewCells["\(indexPath.row)"] != nil
                        {
                            return self.tableViewCells["\(indexPath.row)"]!
                        }
                }
        }
        if (indexPath.section == 1){
            if indexPath.row == 1 { // SERVICES ROW
                return CGFloat(tmpHeight * selectedServicesST.count)
            }
        }
        return CGFloat(tmpHeight)

    }

    @objc func stopIndicator(notification:NSNotification){

        self.getActorIfExist()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "net.canatac.hommeatoutfaire.serviceactormg.save.ok", object: nil)
        self.view.userInteractionEnabled    =   true
        self.indicatorV.stopAnimating()
        self.validationIBOutlet.alpha       =   1.0
        self.indicatorV.removeFromSuperview()
        self.stopAnimating(self.myAddress)

    }
    
    func startAnimating(textView : UITextView){
        UIView.animateWithDuration(0.2, animations: {
            self.cellTextView                           =   nil
            
            let row:Int                                 =   textView.tag - 1 // UITEXTFIELDS TAG BEGIN AT 1. LETTING ALL OTHERS AT 0.
            
            self.tableViewCells["\(row)"]               =   CGFloat(self.tableViewCells["\(row)"] != nil ? self.tableViewCells["\(row)"]!:44 + 2)//?
            
            var textViewFrame                           =   textView.frame
            textViewFrame.size.height                   =   CGFloat(self.tableViewCells["\(row)"] != nil ? self.tableViewCells["\(row)"]!:34 + 2) //The 10 value is to retrieve the same height padding I inputed earlier when I initialized the UITextView
            
            textView.frame                              =   textViewFrame
            textView.font                               =   UIFont.boldSystemFontOfSize(12)
            textView.contentInset                       =   UIEdgeInsetsZero
            
            self.cellTextView                           =   textView
 
            }, completion: {
                _ in
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
        })
       
    }
    
    func stopAnimating(textView : UITextView){

     
        UIView.animateWithDuration(0.2, animations: {
            self.cellTextView                           =   nil
            
            let row:Int                                 =   textView.tag - 1 // UITEXTFIELDS TAG BEGIN AT 1. LETTING ALL OTHERS AT 0.
            
            self.tableViewCells["\(row)"]               =   CGFloat(44)//?
            
            var textViewFrame                           =   textView.frame
            textViewFrame.size.height                   =   CGFloat(34) //The 10 value is to retrieve the same height padding I inputed earlier when I initialized the UITextView
            textView.frame                              =   textViewFrame
            
            textView.font                               =   UIFont.systemFontOfSize(10)
            
            textView.contentInset                       =   UIEdgeInsetsZero
            
            self.cellTextView                           =   textView
            
            }, completion: {
                _ in
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
        })

        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("locations = \(locations)")
        gpsResult               =   locations.last as CLLocation!
        geoPoint["latitude"]    =   gpsResult.coordinate.latitude
        geoPoint["longitude"]   =   gpsResult.coordinate.longitude
        //Get co ordinates
        CLGeocoder().reverseGeocodeLocation(locationManager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Error: \(error!.localizedDescription)")
                return
            }
            
            if placemarks!.count > 0 {
                
                self.pm = placemarks![0] as CLPlacemark!
                self.myAddress.text = ""
                self.myAddress.text?.appendContentsOf(self.pm.subThoroughfare!) // Rue
                self.myAddress.text?.appendContentsOf(" ")

                self.myAddress.text?.appendContentsOf(self.pm.thoroughfare!) // N°
                self.myAddress.text?.appendContentsOf(" ")

                self.myAddress.text?.appendContentsOf(self.pm.postalCode!)
                self.myAddress.text?.appendContentsOf(" ")

                self.myAddress.text?.appendContentsOf(self.pm.locality!) // Commune

                self.textViewDidChange(self.myAddress)
                
            } else {
                print("Error with the data.")
            }
            self.indicatorV.stopAnimating()
            self.stopAnimating(self.myAddress)
            self.geoLocMeIBOutlet.alpha             =   1.0
            self.geoLocMeIBOutlet.titleLabel!.text  =   "Localisez moi"
            self.view.userInteractionEnabled    =   true

        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "servicesSegue"{
            let vc = segue.destinationViewController as! ServicesTableViewController
            vc.delegate = self
            vc.selectedServices = self.selectedServicesST
        }
    }
    
    func selectedServices(services: [String]) {
        print(services)
        selectedServicesST = [String]()
        for service in services{
            if (service != "" && service != "Aucun"){
                selectedServicesST.append(service)
            }
        }
        if selectedServicesST.count == 0 {
            selectedServicesST.append("Aucun")
        }
        
        servicesTableView.reloadData()
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}


/////////////
