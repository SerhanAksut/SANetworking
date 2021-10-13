
import XCTest

@testable import NetworkCore_Default
@testable import Common
@testable import Helpers

final class NetworkCore_DefaultTests: XCTestCase {
    var urlSession: URLSessionMock!
    var requestLoader: RequestLoader!
    
    override func setUp() {
        urlSession = URLSessionMock()
        requestLoader = RequestLoader(
            baseURL: mockBaseURL,
            urlSession: urlSession
        )
    }
    
    override func tearDown() {
        urlSession = nil
        requestLoader = nil
    }
    
    func test__requestError_when_baseURL_is_empty_string() {
        requestLoader = RequestLoader(baseURL: "")
        let request = Request<User>(
            path: mockPath,
            httpMethod: .get,
            decoder: { data -> User in
                User()
            }
        )
        requestLoader.load(request: request) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                guard case .invalidURL(let url) = error as! RequestError else { return }
                XCTAssertEqual(url, "/\(mockPath)")
            }
        }
    }
    
    func test__responseModel_when_response_handled_with_success() {
        let request = Request<User>(
            path: "/v1/sample/sampleEndpoint",
            httpMethod: .get,
            decoder: { data -> User in
                User()
            }
        )
        urlSession.data = .mockUser
        urlSession.urlResponse = .mockSuccess
        requestLoader.load(request: request) { result in
            switch result {
            case .success(let model):
                let expectedResult = User()
                XCTAssertEqual(model, expectedResult)
            case .failure:
                break
            }
        }
    }
    
    func test__responseModel_when_response_handled_with_business_error() {
        let request = Request<ErrorModel>(
            path: "/v1/sample/sampleEndpoint",
            httpMethod: .get,
            decoder: { data -> ErrorModel in
                ErrorModel()
            }
        )
        urlSession.data = .mockError
        urlSession.urlResponse = .mockBusinessError
        requestLoader.load(request: request) { result in
            switch result {
            case .success(let model):
                let expectedResult = ErrorModel()
                XCTAssertEqual(model, expectedResult)
            case .failure:
                break
            }
        }
    }
    
    func test__networkError_unknow_when_response_handled_with_nil_urlResponse() {
        let request = Request<User>(
            path: "/v1/sample/sampleEndpoint",
            httpMethod: .get,
            decoder: { data -> User in
                User()
            }
        )
        urlSession.data = .mockUser
        requestLoader.load(request: request) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertEqual(error as! NetworkError, .unknown)
            }
        }
    }
    
    func test__networkError_noContent_when_response_handled_with_no_body_but_success() {
        let request = Request<User>(
            path: "/v1/sample/sampleEndpoint",
            httpMethod: .get,
            decoder: { data -> User in
                User()
            }
        )
        urlSession.urlResponse = .mockSuccess
        requestLoader.load(request: request) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertEqual(error as! NetworkError, .noContent)
            }
        }
    }
}

// MARK: - Mock Data
private extension HTTPURLResponse {
    static var mockSuccess: Self {
        HTTPURLResponse(
            url: URL(string: "\(mockBaseURL)/v1/user/info")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ) as! Self
    }
    
    static var mockBusinessError: Self {
        HTTPURLResponse(
            url: URL(string: "\(mockBaseURL)/\(mockPath)")!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        ) as! Self
    }
}

private extension Data {
    static var mockUser: Self {
        try! JSONEncoder().encode(User())
    }
    
    static var mockError: Self {
        try! JSONEncoder().encode(ErrorModel())
    }
}

private let mockBaseURL: String = {
    "https://test-mock.com/api"
}()

private let mockPath: String = {
    "v1/user/info"
}()
