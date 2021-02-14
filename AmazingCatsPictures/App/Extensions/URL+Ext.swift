//
//  URL+Ext.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import Foundation

import Foundation
import SystemConfiguration

extension URL {
	init?(scheme: String = "https", host: String, path: String, queryItems: [URLQueryItem], parameters: [URLQueryItem]? = nil) {
		var components = URLComponents()
		components.scheme = scheme
		components.host = host
		components.path = path
		components.queryItems = queryItems
		if parameters != nil {
			components.queryItems = parameters
		}
		guard components.url != nil else { return nil }
		self = components.url!
	}
	
	static var isConnectionAvailable: Bool {
		
		var zeroAddress = sockaddr()
		zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
		zeroAddress.sa_family = sa_family_t(AF_INET)
		guard let networkReachability = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress) else { return false }
		var flags = SCNetworkReachabilityFlags()
		SCNetworkReachabilitySetDispatchQueue(networkReachability, DispatchQueue.global(qos: .default))
		if SCNetworkReachabilityGetFlags(networkReachability, &flags) == false { return false }
		let isConnectionAvailable = flags.contains(.reachable)
		let needConnection = flags.contains(.connectionRequired)
		return isConnectionAvailable && !needConnection
	}
}
