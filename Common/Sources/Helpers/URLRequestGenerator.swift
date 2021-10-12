//
//  File.swift
//  
//
//  Created by Serhan Aksut on 12.10.2021.
//

import Foundation

import struct Common.Request
import enum Common.RequestError

public func createURLRequest<Response>(
    from request: Request<Response>,
    baseURL: String
) throws -> URLRequest {
    guard var url = URL(string: baseURL)?.appendingPathComponent(request.path) else {
        throw RequestError.invalidURL("\(baseURL)/\(request.path)")
    }
    if let query = request.query {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = query.map(URLQueryItem.init)
        url = components?.url ?? url
    }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.httpMethod.rawValue
    request.headers?.forEach {
        urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
    }
    if let body = request.body, !body.isEmpty {
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            throw RequestError.invalidRequestBody(body)
        }
    }
    return urlRequest
}
