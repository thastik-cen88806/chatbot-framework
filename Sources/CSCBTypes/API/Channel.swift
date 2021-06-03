//
//  Channel
//  CSCBTypes
//
//  Created by ha100 on 05/20/2021.
//  Copyright © 2021 Ceska sporitelna. All rights reserved.
//

import Foundation
import Tagged

/// Channel
///
public struct Channel: Identified, Codable {

    // MARK: - TypeAliases

    public typealias AppID = Tagged<App, String>
    public typealias ChannelID = Tagged<Channel, String>

    // MARK: - Types

    enum CodingKeys: String, CodingKey {

        case id
        case getStarted = "get_started"
        case receiverAppId = "primary_receiver_app_id"
        case cookieDomain = "cookie_domain"
        case whitelistedOrigins = "whitelisted_origins"
    }

    // MARK: - Properties

    let id: ChannelID

    let getStarted: ChannelPayload?
    let receiverAppId: AppID?
    let cookieDomain: String?
    let whitelistedOrigins: Array<URL>?

    // MARK: - Init

    /// Channel
    ///
    /// - Parameters:
    ///   - id: Channel identifier
    ///   - getStarted: Developer defined payload
    ///   - receiverAppId: the application, which will dispatch the first contact
    ///   - cookieDomain: Povolit nastavení cookies pro uvedenou doménu
    ///   - whitelistedOrigins: Povolene URL adresy
    ///
    public init(id: ChannelID,
                getStarted: ChannelPayload?,
                receiverAppId: AppID?,
                cookieDomain: String?,
                whitelistedOrigins: Array<URL>?) {

        self.id = id
        
        self.getStarted = getStarted
        self.receiverAppId = receiverAppId
        self.cookieDomain = cookieDomain
        self.whitelistedOrigins = whitelistedOrigins
    }
}
