//
//  MyAnnotationView.swift
//  LHommeAToutFaire
//
//  Created by Can ATAC on 16/10/2015.
//  Copyright © 2015 Can ATAC. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotationView: MKAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(
            annotation: annotation, reuseIdentifier:reuseIdentifier)
        let im = UIImage(named:"MyPin")!
        
        self.frame = CGRectMake(0, 0, im.size.width + 5, im.size.height + 5)

        self.centerOffset = CGPointMake(0, -20)
        self.opaque = false
    }
    
    override init(frame:CGRect){
        super.init(frame:frame)
    }
    
    required init(coder:NSCoder){
        fatalError("NSCoding not supported")
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        let im = UIImage(named:"MyPin")!
        im.drawInRect(self.bounds.insetBy(dx:5, dy:5))
    }


}
