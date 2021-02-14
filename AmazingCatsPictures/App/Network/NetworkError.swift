//
//  NetworkError.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import Foundation

public enum NetworkError: Int, Error {
	
	case badRequest = 400
	case pageNotFound = 404
	case notAcceptable = 406
	
	case internalError = 500
	case serviceUnavailable = 503
	
	case missingResponce = 804
	case parseProblem = 898
	case unspecifiedError = 899
	case noConnection = -1009
	
	public init(_ rawValue: Int) {
		self = NetworkError(rawValue: rawValue) ?? .unspecifiedError
	}
}


extension NetworkError: LocalizedError {
	
	public var errorDescription: String? {
		let descriptionEnding = "\nPlease try again later..."
		switch self {
		case .badRequest:
			return "The request is invalid." + descriptionEnding
		case .pageNotFound:
			return "The server can not find the requested resource." + descriptionEnding
		case .missingResponce:
			return "Missing HTTP response." + descriptionEnding
		case .parseProblem:
			return "Can't parse one or more fields from responce data." + descriptionEnding
		case .internalError:
			return "Server internal error." + descriptionEnding
		case .serviceUnavailable:
			return "Service is unavailable now." + descriptionEnding
		case .noConnection:
			return "no internet"
		default:
			return "Whoops... There is some error." + descriptionEnding
		}
	}
}
