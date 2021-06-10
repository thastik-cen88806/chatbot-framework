//
//  String+Extension
//  ChatbotFrameworkExternal
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import CSCBTypes

extension String {

    func match(regex: String) throws -> String {

        do {

            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))

            let element = results.map { result in
                String(self[Range(result.range, in: self)!])
            }.first

            guard let result = element else {

                throw CBError.regexNoMatch(text: self)
            }

            return result
        } catch {

            throw CBError.regexFormat(text: error.localizedDescription)
        }
    }
}
