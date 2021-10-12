//
//  File.swift
//  
//
//  Created by Serhan Aksut on 28.09.2021.
//

import Foundation

public typealias RequestHeader = [String: String]
public typealias RequestBody = [String: Any?]
public typealias RequestQuery = [String: String?]
public typealias ResponseDecoder<Model: Decodable> = (Data) throws -> Model
