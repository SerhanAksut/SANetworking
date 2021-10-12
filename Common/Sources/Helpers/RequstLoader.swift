//
//  File.swift
//  
//
//  Created by Serhan Aksut on 12.10.2021.
//

import Foundation

public struct RequestLoader {
    public let baseURL: String
    public let urlSession: URLSession
    
    public init(
        baseURL: String,
        urlSession: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
}
