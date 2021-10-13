
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
        requestLoader.load(request: .mockUser) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                guard case .invalidURL(let url) = error as! RequestError else { return }
                XCTAssertEqual(url, "/\(mockPath)")
            }
        }
    }
    
    func test__networkError_unknown_when_response_handled_with_nil_urlResponse() {
        urlSession.data = .mockUserData
        requestLoader.load(request: .mockUser) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertEqual(error as! NetworkError, .unknown)
            }
        }
    }
    
    func test__networkError_unauthorized_when_response_handled_with_unauthorized_statusCode() {
        urlSession.urlResponse = .mockUnauthorizedError
        requestLoader.load(request: .mockUser) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertEqual(error as! NetworkError, .unauthorized)
            }
        }
    }
    
    func test__networkError_notFound_when_response_handled_with_notFound_statusCode() {
        urlSession.urlResponse = .mockNotFoundError
        requestLoader.load(request: .mockUser) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertEqual(error as! NetworkError, .notFound)
            }
        }
    }
    
    func test__networkError_internalServer_when_response_handled_with_internalServer_statusCode() {
        urlSession.urlResponse = .mockInternalServerError
        requestLoader.load(request: .mockUser) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertEqual(error as! NetworkError, .internalServer)
            }
        }
    }
    
    func test__networkError_serviceUnavailable_when_response_handled_with_serviceUnavailable_statusCode() {
        urlSession.urlResponse = .mockServiceUnavailableError
        requestLoader.load(request: .mockUser) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertEqual(error as! NetworkError, .serviceUnavailable)
            }
        }
    }
    
    func test__networkError_badStatus_when_response_handled_with_badStatus_statusCode() {
        urlSession.urlResponse = .mockBadStatusError
        requestLoader.load(request: .mockUser) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertEqual(error as! NetworkError, .badStatus)
            }
        }
    }
    
    func test__responseModel_when_response_handled_with_success() {
        urlSession.data = .mockUserData
        urlSession.urlResponse = .mockSuccess
        requestLoader.load(request: .mockUser) { result in
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
        urlSession.data = .mockErrorData
        urlSession.urlResponse = .mockBusinessError
        requestLoader.load(request: .mockError) { result in
            switch result {
            case .success(let model):
                let expectedResult = ErrorModel()
                XCTAssertEqual(model, expectedResult)
            case .failure:
                break
            }
        }
    }
    
    func test__networkError_noContent_when_response_handled_with_no_body_but_success() {
        urlSession.urlResponse = .mockSuccess
        requestLoader.load(request: .mockUser) { result in
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
private extension Request where Response == User {
    static var mockUser: Self {
        Request(
            path: mockPath,
            httpMethod: .get,
            headers: [
                "someKey": "someValue"
            ],
            query: [
                "someKey": "someValue"
            ],
            decoder: { data -> User in
                User()
            }
        )
    }
}

private extension Request where Response == ErrorModel {
    static var mockError: Self {
        Request(
            path: mockPath,
            httpMethod: .post,
            headers: [
                "someKey": "someValue"
            ],
            body: [
                "someKey": "someValue"
            ],
            decoder: { data -> ErrorModel in
                ErrorModel()
            }
        )
    }
}

private extension HTTPURLResponse {
    static var mockSuccess: Self {
        HTTPURLResponse(
            url: URL(string: "\(mockBaseURL)/v1/user/info")!,
            statusCode: Set(200...299).randomElement() ?? 200,
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
    
    static var mockUnauthorizedError: Self {
        HTTPURLResponse(
            url: URL(string: "\(mockBaseURL)/\(mockPath)")!,
            statusCode: Set([401, 403]).randomElement() ?? 401,
            httpVersion: nil,
            headerFields: nil
        ) as! Self
    }
    
    static var mockNotFoundError: Self {
        HTTPURLResponse(
            url: URL(string: "\(mockBaseURL)/\(mockPath)")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        ) as! Self
    }
    
    static var mockInternalServerError: Self {
        HTTPURLResponse(
            url: URL(string: "\(mockBaseURL)/\(mockPath)")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        ) as! Self
    }
    
    static var mockServiceUnavailableError: Self {
        HTTPURLResponse(
            url: URL(string: "\(mockBaseURL)/\(mockPath)")!,
            statusCode: 503,
            httpVersion: nil,
            headerFields: nil
        ) as! Self
    }
    
    static var mockBadStatusError: Self {
        HTTPURLResponse(
            url: URL(string: "\(mockBaseURL)/\(mockPath)")!,
            statusCode: 1,
            httpVersion: nil,
            headerFields: nil
        ) as! Self
    }
}

private extension Data {
    static var mockUserData: Self {
        try! JSONEncoder().encode(User())
    }
    
    static var mockErrorData: Self {
        try! JSONEncoder().encode(ErrorModel())
    }
}

private let mockBaseURL: String = {
    "https://test-mock.com/api"
}()

private let mockPath: String = {
    "v1/user/info"
}()
