//
//  File.swift
//  
//
//  Created by Serhan Aksut on 28.09.2021.
//

public enum NetworkError: Error {
    case unauthorized
    case notFound
    case internalServer
    case serviceUnavailable
    case badStatus
    case noContent
    case unknown
}
