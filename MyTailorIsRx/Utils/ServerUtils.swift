//
//  ServerUtils.swift
//  MyTailorIsRx
//
//  Created by guillaume MAIANO on 01/02/2021.
//

import Foundation

struct ServerUtils {
    public static func readServerInfoPropertyList() -> ServerInfo? {
            var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml // Format of the Property List.
            var plistData: [String: AnyObject] = [:] // the data (login information for server && server url)
            let plistPath: String? = Bundle.main.path(forResource: "ServerInfo", ofType: "plist")! // the path of the data
            let plistXML = FileManager.default.contents(atPath: plistPath!)!
            do {// convert the data to a dictionary and handle errors.
                plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String:AnyObject]

            } catch {
                print("Error reading plist: \(error), format: \(propertyListFormat)")
            }
        if let loginString: String = plistData["login"] as? String,
           let keyString: String = plistData["key"] as? String,
           let urlString: String = plistData["url"] as? String,
           let url: URL = URL(string: urlString) {
                let serverInfo = ServerInfo(login: loginString, key: keyString, url: url)
                return serverInfo
            } else {
                print("Server information missing!")
                return nil
            }
    }
}
