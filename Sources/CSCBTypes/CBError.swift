//
//  CBError
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

public enum CBError: Error, AutoEquatable, AutoCaseName {

    case arrayElementsOverflow(text: String)
    case invalidUri(url: String)
    case networkTimeout(url: String)
    case textLengthOverflow(text: String)
    case tokenZeroDecode(error: String)
    case tokenZeroHTMLExtract(error: String)
    case tokenZeroDataDecoding(data: Data)
    case tokenZeroNoHTMLData
    case tokenJWTMissingExpiration
    case tokenJWTExpired
    case regexFormat(text: String)
    case regexNoMatch(text: String)
}

protocol AutoEquatable {}

protocol AutoCaseName {}
