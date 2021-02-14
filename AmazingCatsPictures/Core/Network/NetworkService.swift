//
//  NetworkService.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import Foundation

class NetworkService: APIService {
	
	var sessionConfiguration: URLSessionConfiguration
	
	lazy var session: URLSession = {
		return URLSession(configuration: self.sessionConfiguration)
	}()
	
	init(sessionConfiguration: URLSessionConfiguration = .default) {
		self.sessionConfiguration = sessionConfiguration
	}
	
	func parse<T: Decodable>(from json: Data) -> [T?] {
		do {
			let decodedResponce = try JSONDecoder().decode([T?].self, from: json)
			return decodedResponce
		} catch {
			return [nil]
		}
	}
}
