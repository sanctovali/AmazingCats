//
//  CatApiRouter.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import Foundation

let API_KEY = "0ad83b2b-3d70-4ae7-aed6-5e013d532ad1"

protocol URLEndpoint {
	var host: String { get }
	var path: String { get }
	var request: URLRequest { get }
	var method: String { get }
}

enum CatApiRouter: URLEndpoint {
	
	case random(Int)
	
	var host: String {
		return "api.thecatapi.com"
	}
	
	var path: String {
		switch self {
		case .random:
			return "/v1/images/search"
		}
	}
	
	var method: String {
		switch self {
		case .random:
			return "GET"
		}
	}
	
	var headers: [String : String] {
		switch self {
		case .random:
			return ["Content-Type" : "application/json", "x-api-key" : API_KEY]
		}
	}
	
	var queryItems: [URLQueryItem] {
		switch self {
		case .random(let count):
			return [URLQueryItem(name: "format", value: "static"), URLQueryItem(name: "limit", value: "\(count)")]
		}
	}
	
	var request: URLRequest {
		switch self {
		case .random:
			let url = URL(host: host, path: path, queryItems: queryItems)!
			var request = URLRequest(url: url)
			request.httpMethod = method
			request.allHTTPHeaderFields = headers
			return request
		}
	}
	
}
