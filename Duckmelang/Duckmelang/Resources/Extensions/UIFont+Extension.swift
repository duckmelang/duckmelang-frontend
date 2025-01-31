//
//  UIFont+Extension.swift
//  Duckmelang
//
//  Created by 주민영 on 1/13/25.
//

import UIKit

struct AppFontName {
    static let aBold = "AritaDotumKRBold"
    static let aLight = "AritaDotumKRLight"
    static let aMedium = "AritaDotumKRMedium"
    static let aSemiBold = "AritaDotumKRSemiBold"
    static let aThin = "AritaDotumKRThin"
    
    static let pThin = "Pretendard-Thin"
    static let pRegular = "Pretendard-Regular"
    static let pMedium = "Pretendard-Medium"
    static let pLight = "Pretendard-Light"
    static let pExtraLight = "Pretendard-ExtraLight"
    static let pExtraBold = "Pretendard-ExtraBold"
    static let pBold = "Pretendard-Bold"
    static let pSemiBold = "Pretendard-SemiBold"
    static let pBlack = "Pretendard-Black"
}

extension UIFont {
    // AritaDotumKR Bold Font
    public class func aritaBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.aBold, size: size)!
    }
    
    // AritaDotumKR Light Font
    public class func aritaLightFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.aLight, size: size)!
    }
    
    // AritaDotumKR Medium Font
    public class func aritaMediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.aMedium, size: size)!
    }
    
    // AritaDotumKR SemiBold Font
    public class func aritaSemiBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.aSemiBold, size: size)!
    }
    
    // AritaDotumKR Thin Font
    public class func aritaThinFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.aThin, size: size)!
    }
    
    // Pretendard Thin Font
    public class func ptdThinFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pThin, size: size)!
    }
    
    // Pretendard Regular Font
    public class func ptdRegularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pRegular, size: size)!
    }
    
    // Pretendard Medium Font
    public class func ptdMediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pMedium, size: size)!
    }
    
    // Pretendard Light Font
    public class func ptdLightFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pLight, size: size)!
    }
    
    // Pretendard ExtraLight Font
    public class func ptdExtraLightFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pExtraLight, size: size)!
    }
    
    // Pretendard ExtraBold Font
    public class func ptdExtraBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pExtraBold, size: size)!
    }
    
    // Pretendard Bold Font
    public class func ptdBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pBold, size: size)!
    }
    
    // Pretendard SemiBold Font
    public class func ptdSemiBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pSemiBold, size: size)!
    }
    
    // Pretendard Black Font
    public class func ptdBlackFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.pBlack, size: size)!
    }
}

// Example
// $0.font = UIFont.aritaThinFont(ofSize: 25)
// $0.font = UIFont.ptdBlackFont(ofSize: 25)
