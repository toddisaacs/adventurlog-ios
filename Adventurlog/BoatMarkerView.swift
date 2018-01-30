//
//  BoatMarkerView.swift
//  Adventurlog
//
//  Created by Todd Isaacs on 1/29/18.
//  Copyright © 2018 Todd Isaacs. All rights reserved.
//

import UIKit

class BoatMarkerView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        Styles.drawBoatIcon(frame: self.frame, resizing: .aspectFit)
    }
 

}
