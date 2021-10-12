//
//  File.swift
//  
//
//  Created by Serhan Aksut on 12.10.2021.
//

import struct Common.Request

import struct Helpers.RequestLoader
import func Helpers.createURLRequest
import func Helpers.checkURLResponse

@available(iOS 15.0, *)
public extension RequestLoader {
    func load<Response>(
        request: Request<Response>
    ) async throws -> Response {
        let urlRequest = try createURLRequest(from: request, baseURL: baseURL)
        let (data, urlResponse) = try await urlSession.data(for: urlRequest)
        let resultData = try checkURLResponse(data: data, response: urlResponse, error: nil)
        let model = try request.decoder(resultData)
        return model
    }
}
