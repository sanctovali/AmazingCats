//
//  APIService.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import Foundation

typealias JSONCompletionHandler = (Data?, HTTPURLResponse?, Error?) -> Void
typealias JSONTask = URLSessionDataTask

protocol APIService {
	var sessionConfiguration: URLSessionConfiguration { get }
	var session: URLSession { get }
	
	func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask
	
	func fetch<T: Decodable>(request: URLRequest, parse: @escaping (Data) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)
}

//MARK: - Extensions -
extension APIService {
	func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
		
		let dataTask = session.dataTask(with: request) { (data, response, error) in
			guard let HTTPResponse = response as? HTTPURLResponse else {
				let error = NetworkError.missingResponce
				completionHandler(nil, nil, error)
				return
			}
			
			if data == nil {
				if let error = error {
					completionHandler(nil, HTTPResponse, error)
				}
			} else {
				completionHandler(data, HTTPResponse, nil)
			}
		}
		return dataTask
	}
	
	func fetch<T: Decodable>(request: URLRequest, parse: @escaping (Data) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
		let dataTask = JSONTaskWith(request: request) {(json, response, error) in
			
			DispatchQueue.main.async {				
				guard let HTTPResponse = response, error == nil else {
					let error = NetworkError(error?._code ?? 899 )
					completionHandler(.Failure(error))
					return
				}
				
				switch HTTPResponse.statusCode {
				case 200...201:
					if let value = parse(json!) {
						completionHandler(.Success(value))
					} else if let error = error {
						completionHandler(.Failure(error))
					} else {
						let error = NetworkError.parseProblem
						completionHandler(.Failure(error))
					}
				case let statusCode where statusCode >= 400 && statusCode < 500:
					let error = NetworkError(statusCode)
					completionHandler(.Failure(error))
				default:
					break
				}
			}
		}
		dataTask.resume()
	}

}
