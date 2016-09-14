//
//  MyCustomAnnotation.swift
//  L'Homme A Tout Faire
//
//  Created by Can ATAC on 07/10/2015.
//  Copyright © 2015 Can ATAC. All rights reserved.
//

import Foundation
import MapKit

class MyCustomAnnotation: NSObject,MKAnnotation{
    var title: String?
    var subtitle: String?
    var name: String?
    var surname: String?
    var coordinate: CLLocationCoordinate2D
    var address: String
    var email:String
    var phone:String
    var services:[String]
    
    init(name: String,
        surname:String,
        coordinate: CLLocationCoordinate2D,
        address: String,
        email:String,
        phone:String,
        services:[String]
        ) {
            self.title      =   surname
            self.subtitle   =   name
            self.name       =   name
            self.surname    =   surname
            self.coordinate =   coordinate
            self.address    =   address
            self.email      =   email
            self.phone      =   phone
            self.services   =   services
            
            super.init()
    }
}
