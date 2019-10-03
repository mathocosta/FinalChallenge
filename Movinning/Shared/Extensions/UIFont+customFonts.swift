//
//  UIFont+customFonts.swift
//  Splay
//
//  Created by Paulo José on 23/09/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

extension UIFont {

    class var actionStyle: UIFont {
        return UIFont(name: "Oswald-Medium", size: 20.0) ?? UIFont()
    }

    class var itemCondensedDarkStyle: UIFont {
        return UIFont(name: "Oswald-ExtraLight", size: 20.0) ?? UIFont()
    }

    class var cardStyle: UIFont {
        return UIFont(name: "Oswald-Medium", size: 18.0) ?? UIFont()
    }

    class var sectionDarkStyle: UIFont {
        return UIFont(name: "Oswald-Medium", size: 18.0) ?? UIFont()
    }

    class var sectionLightStyle: UIFont {
        return UIFont(name: "Oswald-Medium", size: 18.0) ?? UIFont()
    }

    class var listItemLightStyle: UIFont {
        return UIFont(name: "Avenir-Roman", size: 18.0) ?? UIFont()
    }

    class var listItemDarkStyle: UIFont {
        return UIFont(name: "Avenir-Roman", size: 18.0) ?? UIFont()
    }

    class var detailCondensedLightStyle: UIFont {
        return UIFont(name: "Oswald-Light", size: 18.0) ?? UIFont()
    }

    class var detailCondensedDarkStyle: UIFont {
        return UIFont(name: "Oswald-Light", size: 18.0) ?? UIFont()
    }

    class var detailLightStyle: UIFont {
        return UIFont(name: "Avenir-Light", size: 16.0) ?? UIFont()
    }

    class var detailDarkStyle: UIFont {
        return UIFont(name: "Avenir-Light", size: 16.0) ?? UIFont()
    }

    class var cardDetailStyle: UIFont {
        return UIFont(name: "Oswald-ExtraLight", size: 16.0) ?? UIFont()
    }

    class var listItemDetailDarkStyle: UIFont {
        return UIFont(name: "Avenir-Light", size: 12.0) ?? UIFont()
    }

    class var listItemDetailLightStyle: UIFont {
        return UIFont(name: "Avenir-Light", size: 12.0) ?? UIFont()
    }
    
    class var inputContentStyle: UIFont {
        return UIFont(name: "Avenir-Light", size: 20) ?? UIFont()
    }
    
    class var inputLabelStyle: UIFont {
        return UIFont(name: "Oswald-Regular", size: 18) ?? UIFont()
    }

}
