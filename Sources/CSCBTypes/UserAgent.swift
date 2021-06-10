//
//  UserAgent
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
#if !os(macOS)
import UIKit
#endif

/// Credits: - https://burgers.io/better-user-agent
///
/// SeeAlso: - https://gist.github.com/bryanburgers/daa09d5d8c3b61c6d98a
///
public final class UserAgent {

    public static var agent: String {

        #if !os(macOS)
        let bundleDict = Bundle.main.infoDictionary!
        let appName = bundleDict["CFBundleName"] as! String
        let appVersion = bundleDict["CFBundleShortVersionString"] as! String
        let appDescriptor = appName + "/" + appVersion

        let currentDevice = UIDevice.current
        let osDescriptor = "iOS/" + currentDevice.systemVersion

        let hardwareString = self.hardwareString

        return appDescriptor + " " + osDescriptor + " (" + hardwareString + ")"
        #else
        return "" // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        #endif
    }

    static var hardwareString: String {

        var name: [Int32] = [CTL_HW, HW_MACHINE]
        var localname: [Int32] = [CTL_HW, HW_MACHINE]
        var size = 2

        localname = name
        sysctl(&name, 2, nil, &size, &localname, 0)

        var hw_machine = [CChar](repeating: 0, count: Int(size))

        sysctl(&name, 2, &hw_machine, &size, &localname, 0)

        let hardware: String = String(cString: hw_machine)

        return hardware
    }
}
