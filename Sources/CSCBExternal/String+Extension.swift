//
//  String+Extension
//  ChatbotFrameworkExternal
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation

extension String {

    func match(regex: String) -> String? {

        do {

            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))

            return results.map { result in
                String(self[Range(result.range, in: self)!])
            }.first

        } catch {

            print(">>> invalid regex: \(error.localizedDescription)")
            return nil
        }
    }
}
