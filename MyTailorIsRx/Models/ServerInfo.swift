//
//  ServerInfo.swift
//  MyTailorIsRx
//
//  Created by guillaume MAIANO on 01/02/2021.
//

import Foundation

struct ServerInfo: MyTailorLogin, MyTailorKey {
    // Domain Driver Design - as per the Daniels
    var login: String
    var key: String
    let url: URL
}

protocol MyTailorLogin {
    var login: String { get set }
}

protocol MyTailorKey {
    var key: String { get set }
}
