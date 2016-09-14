//
//  ServicesMapController.swift
//  L'Homme A Tout Faire
//
//  Created by Can ATAC on 07/10/2015.
//  Copyright © 2015 Can ATAC. All rights reserved.
//

import MapKit
import yall

class ServicesMapController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,UIPopoverPresentationControllerDelegate,UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var servicesMap: MKMapView!
    
    var gpsResult : CLLocation!             =   CLLocation()
    var serviceActor:String                 =   ""//PROVIDER OR ASKER
    var address:String                      =   "121 Rue Henri Barbusse, 92110 CLICHY"
    var locationManager:CLLocationManager!
    var v:UIViewController!
    var pm:CLPlacemark!
    var indicatorV:UIActivityIndicatorView!
    var services:[String]                   =   [String]()
    var serviceTableInMap:ServiceTableInMap =   ServiceTableInMap(frame: CGRectMake(0.0, 0.0, 300.0, 400.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.serviceTableInMap.delegate     =   self.serviceTableInMap
        self.serviceTableInMap.dataSource   =   self.serviceTableInMap
        
        self.title                          =   self.serviceActor == "PROVIDER" ? "FOURNISSEURS":"DEMANDEURS"
        
        self.indicatorV                     =   UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        self.indicatorV.color               =   UIColor.whiteColor()
        dispatch_async(dispatch_get_main_queue(), {
            self.indicatorV.backgroundColor = UIColor(white:0.2,alpha:0.6)
        })
        
        self.indicatorV.layer.cornerRadius  =   10
        self.indicatorV.frame               =   CGRectMake(0.0,0.0,80.0,80.0)
        self.indicatorV.center              =   self.view.center
        self.view.addSubview(self.indicatorV)
        
        self.indicatorV.startAnimating()
        
        self.locationManager                 =   CLLocationManager()
        self.locationManager.delegate        =   self
        self.servicesMap.delegate            =   self
        self.locationManager.distanceFilter  =   10
        self.locationManager.desiredAccuracy =   kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        
        self.servicesMap.showsUserLocation   =   true
        self.servicesMap.showsTraffic        =   true
        
        if (NSUserDefaults.standardUserDefaults().valueForKey("userLatitude") == nil) &&
        (NSUserDefaults.standardUserDefaults().valueForKey("userLongitude") == nil){
            
            self.locationManager.requestLocation()
        }else{
            gpsResult = CLLocation(latitude: NSUserDefaults.standardUserDefaults().valueForKey("userLatitude") as! Double, longitude: NSUserDefaults.standardUserDefaults().valueForKey("userLongitude") as! Double)
            self.showMap(NSUserDefaults.standardUserDefaults().valueForKey("userLatitude") as! Double, longitude: NSUserDefaults.standardUserDefaults().valueForKey("userLongitude") as! Double)
        }
        
        
    }
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView:MyAnnotationView! = nil
        
        if annotation is MKUserLocation{
            return nil
        }
        
        let reuseId = "pin"
        
        pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MyAnnotationView

        if(pinView == nil){
            pinView                             =   MyAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout             =   true
            pinView!.image                      =   UIImage(named:"MyPin.png")
            pinView!.bounds.size.height         *= 1.0
            pinView!.bounds.size.width          *= 1.0
            pinView!.centerOffset               =   CGPointMake(0,-20)
            pinView!.canShowCallout             =   true
            pinView!.rightCalloutAccessoryView  =   UIButton(type: .DetailDisclosure) as UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView!
    
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        let customAnnotation            =   view.annotation as! MyCustomAnnotation
        services                        =   customAnnotation.services
        let servicesNb:Int              =   services.count
        serviceTableInMap.data          =   [
            customAnnotation.title!,
            customAnnotation.subtitle!,
            String(servicesNb),
            customAnnotation.address,
            customAnnotation.phone,
            customAnnotation.email
        ]
        
        serviceTableInMap.labels          =   [
            "Nom            : ",
            "Prénom         : ",
            "Nb de services : ",
            "Adresse        : ",
            "Téléphone      : ",
            "Email          : ",
            "Services       : "
        ]
        
        serviceTableInMap.services      =   services
        
        serviceTableInMap.delegateSTIM  =   self
        
        let viewController              =   UIViewController()
        let v                           =   UIView(frame: CGRectMake(0.0, 0.0, 300.0, 300.0))

        
        v.addSubview(serviceTableInMap)
        
        viewController.view = v
        
        viewController.modalPresentationStyle   =   .Popover
        viewController.preferredContentSize     =   CGSizeMake(300, 300)
        
        let viewBoundX = view.bounds.origin.x+30
        let viewBoundY = view.bounds.origin.y+15

        let popoverMenuViewController                       =   viewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections =   .Any
        popoverMenuViewController?.delegate                 =   self
        popoverMenuViewController?.sourceView               =   view
        popoverMenuViewController?.sourceRect               =   CGRect(
            x: viewBoundX,
            y: viewBoundY,
            width: 1,
            height: 1)

        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cellID") as UITableViewCell!
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellID")
        }
        cell!.textLabel!.font   =   UIFont.systemFontOfSize(10.0)
        print("\(services[indexPath.row])")
        cell!.textLabel!.text   =   services[indexPath.row]
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return services.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 20
    }
    
    func tappedTextView(recognizer:UITapGestureRecognizer){
        v.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location:CLLocation
        
        if (NSUserDefaults.standardUserDefaults().valueForKey("userLatitude") == nil){//FIRST TIME
            print("locations = \(locations)")
            gpsResult   =   locations.last as CLLocation!
            location    =   locations.last as CLLocation!
            
            NSUserDefaults.standardUserDefaults().setValue(location.coordinate.latitude, forKey: "userLatitude")
            NSUserDefaults.standardUserDefaults().setValue(location.coordinate.longitude, forKey: "userLongitude")
        
        }
    
        self.showMap(NSUserDefaults.standardUserDefaults().valueForKey("userLatitude") as! Double, longitude: NSUserDefaults.standardUserDefaults().valueForKey("userLongitude") as! Double)
        
    }
    
    func showMap(latitude:Double, longitude:Double){
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        servicesMap.setRegion(region, animated: true)
        
        //Get coordinates
        CLGeocoder().reverseGeocodeLocation(gpsResult, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Error: \(error!.localizedDescription)")
                return
            }
            
            if placemarks!.count > 0 {
                
                self.pm = placemarks![0] as CLPlacemark!
                self.displayLocationInfo(self.pm)
                
            } else {
                print("Error with the data.")
            }
        })
    
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
            print("Error: \(error.localizedDescription)")
    }
    
    func displayLocationInfo(placemark: CLPlacemark!) {
        
        let positions:[MyCustomAnnotation] = servicesLocations(self.serviceActor)
        
        for position in positions{
            servicesMap.addAnnotation(position)
        }
        indicatorV.stopAnimating()
    }
    
    func servicesLocations(serviceActor:String)->[MyCustomAnnotation]{
    
        var customAnnotations:[MyCustomAnnotation] = [MyCustomAnnotation]()
        
        //GET SP OR SA LIST
        if serviceActor == "PROVIDER"{
            customAnnotations = providersListWithMyLocation()
        }
        if serviceActor == "ASKER"{
            customAnnotations = askersListWithMyLocation()
        }
        
        return customAnnotations
    }
    
    func askersListWithMyLocation()->[MyCustomAnnotation]{
        print("gpsresult : \(gpsResult)")
        let askers:Dictionary     =   ServiceActorAPI.getListWithMyLocation("ASKER",location: gpsResult)
        return transformDicToAnnotation(askers)
    }
    func providersListWithMyLocation()->[MyCustomAnnotation]{
        print("gpsresult : \(gpsResult)")
        let providers:Dictionary     =   ServiceActorAPI.getListWithMyLocation("PROVIDER",location: gpsResult)
        for key in providers.keys{
            print("PROVIDER RETRIEVED : \(providers[key])")
        }
        return transformDicToAnnotation(providers)
    }
    
    func transformDicToAnnotation(actors:Dictionary<String,Dictionary<String,AnyObject>>)->[MyCustomAnnotation]{
        var customAnnotations:[MyCustomAnnotation] = [MyCustomAnnotation]()
        
        for (_,value) in actors{
            let tmp:Dictionary<String,AnyObject> = value
                let customAnnotation:MyCustomAnnotation = MyCustomAnnotation(
                    name:       tmp["name"] as! String,
                    surname:    tmp["surname"] as! String,
                    coordinate: CLLocationCoordinate2D(
                        latitude:   tmp["latitude"] as! Double,
                        longitude:  tmp["longitude"] as! Double
                    ),
                    address:    tmp["address"] as! String,
                    email:      tmp["email"] as! String,
                    phone:      tmp["phone"] as! String,
                    services:   tmp["services"] as! [String]
                )
                
                customAnnotations.append(customAnnotation)
        }
        
        return customAnnotations
    }
}
