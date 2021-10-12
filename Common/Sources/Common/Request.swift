//
//  File.swift
//  
//
//  Created by Serhan Aksut on 28.09.2021.
//

public struct Request<Response: Decodable> {
    public let path: String
    public let httpMethod: HTTPMethod
    public let headers: RequestHeader?
    public let query: RequestQuery?
    public let body: RequestBody?
    public let decoder: ResponseDecoder<Response>
    
    public init(
        path: String,
        httpMethod: HTTPMethod,
        headers: RequestHeader? = nil,
        query: RequestQuery? = nil,
        body: RequestBody? = nil,
        decoder: @escaping ResponseDecoder<Response>
    ) {
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.query = query
        self.body = body
        self.decoder = decoder
    }
}
