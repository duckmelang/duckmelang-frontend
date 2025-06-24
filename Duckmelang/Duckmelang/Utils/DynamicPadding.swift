//
//  DynamicPadding.swift
//  Duckmelang
//
//  Created by 주민영 on 6/23/25.
//

import Foundation
import UIKit

public struct DynamicPadding {
    public static var superViewHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    public static var superViewWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    public static var widthScaleFactor : CGFloat {
        get {
            return DynamicPadding.superViewWidth / 375
        }
    }
    
    public static var heightScaleFactor : CGFloat {
        get {
            return DynamicPadding.superViewHeight / 812
        }
    }
        
    public static func dynamicValue(_ baseValue: CGFloat) -> CGFloat {
        return baseValue * heightScaleFactor
    }
    
    public static func dynamicValuebyWidth(_ baseValue: CGFloat) -> CGFloat {
        return baseValue * widthScaleFactor
    }
}
