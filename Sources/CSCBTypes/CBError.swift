//
//  CBError
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

public enum CBError: Error {

    case arrayElementsOverflow(text: String)
    case invalidUri(url: String)
    case networkTimeout(url: String)
    case textLengthOverflow(text: String)
    case tokenZeroDecode(error: String)
    case tokenZeroHTMLExtract(error: String)
    case tokenZeroNoHTMLData
    case tokenZeroNoCookies(response: URLResponse?)
}
