//
//  File.swift
//  
//
//  Created by Serhan Aksut on 28.09.2021.
//

import Foundation

import struct Common.Request

import struct Helpers.RequestLoader
import func Helpers.createURLRequest
import func Helpers.checkURLResponse

public extension RequestLoader {
    func load<Response>(
        request: Request<Response>,
        completion: @escaping (Result<Response, Error>) -> ()
    ) {
        do {
            let urlRequest = try createURLRequest(from: request, baseURL: baseURL)
            let task = urlSession.dataTask(with: urlRequest) { data, response, error in
                do {
                    let data = try checkURLResponse(data: data, response: response, error: error)
                    let model = try request.decoder(data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
