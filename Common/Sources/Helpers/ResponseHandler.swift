//
//  File.swift
//  
//
//  Created by Serhan Aksut on 28.09.2021.
//

import Foundation

import enum Common.NetworkError

public func checkURLResponse(
    data: Data?,
    response: URLResponse?,
    error: Error?
) throws -> Data {
    guard let response = response as? HTTPURLResponse else {
        throw NetworkError.unknown
    }
    let statusCode = response.statusCode
    if let error = getErrorIfExists(with: statusCode) {
        throw error
    }
    if let data = data, !data.isEmpty {
        return data
    }
    throw NetworkError.noContent
}

private func getErrorIfExists(with statusCode: Int) -> NetworkError? {
    let isSuccess = Constants.successCodes.contains(statusCode)
    let isBusinessError = statusCode == Constants.businessError
    if isSuccess || isBusinessError {
        return nil
    }
    if Constants.unauthorizedCodes.contains(statusCode) {
        return .unauthorized
    }
    if statusCode == Constants.notFound {
        return .notFound
    }
    if statusCode == Constants.internalServer {
        return .internalServer
    }
    if statusCode == Constants.serviceUnavailable {
        return .serviceUnavailable
    }
    return .badStatus
}

// MARK: - Constants
private enum Constants {
    static let successCodes = Set(200...299)
    static let businessError = 400
    static let unauthorizedCodes = Set([401, 403])
    static let notFound = 404
    static let internalServer = 500
    static let serviceUnavailable = 503
}
