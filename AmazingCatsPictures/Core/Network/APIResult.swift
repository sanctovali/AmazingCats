//
//  APIResult.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import Foundation

enum APIResult<T> {
	case Success(T)
	case Failure(Error)
}
