//
//  File.swift
//  
//
//  Created by Serhan Aksut on 28.09.2021.
//

import Foundation

public enum RequestError: Error {
    case invalidURL(String)
    case invalidRequestBody(RequestBody)
}
