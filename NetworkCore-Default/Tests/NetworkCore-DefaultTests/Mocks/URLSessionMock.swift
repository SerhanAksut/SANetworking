//
//  File.swift
//  
//
//  Created by Serhan Aksut on 13.10.2021.
//

import Foundation

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    var data: Data?
    var urlResponse: HTTPURLResponse?
    var error: Error?
    
    override func dataTask(
        with request: URLRequest,
        completionHandler: @escaping CompletionHandler
    ) -> URLSessionDataTask {
        let data = self.data
        let urlResponse = self.urlResponse
        let error = self.error
        
        return URLSessionDataTaskMock {
            completionHandler(data, urlResponse, error)
        }
    }
}
