//
//  HttpRequest.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation

struct KPWalletAPIManager<RequestType: Codable, ReturnType: Codable> {
    
    private let httpStructs: http<RequestType?, ReturnType>
    private let URLLocations: Int
    
    init(httpStructs: http<RequestType?, ReturnType>,URLLocations: Int) {
        self.httpStructs = httpStructs
        self.URLLocations = URLLocations
    }
    
    //    해당 함수 호출로 Request 코드 호출
    func performRequest() async throws -> (success: Bool, data: ReturnType?, ErrorMessage: String?) {
        do {
            guard let url = try constructURL() else {
                print("Invalid URL")
                throw TraceUserError.clientError("\(PlistManager.shared.string(forKey: "clientError")) \(PlistManager.shared.string(forKey: "urlFail"))")
            }
            var request = URLRequest(url: url)
            try configureRequest(&request)
            let (data, response) = try await URLSession.shared.data(for: request)
            return try handleResponse(data: data, response: response)
        } catch {
            throw TraceUserError.httpRequestError("\(PlistManager.shared.string(forKey: "performRequest")) \(error)")
        }
    }
    //    URL 생성
    private func constructURL() throws -> URL? {
        do{
            let query = httpStructs.urlParse
            let baseURL = try UtilityURLReturn.API_SERVER()
            let location = try fetchLocationURL(LocationStatus: URLLocations)
            if location == "" || baseURL == ""{
                throw TraceUserError.clientError("\(PlistManager.shared.string(forKey: "constructURL")) \(PlistManager.shared.string(forKey: "configError"))")
            }
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                throw TraceUserError.clientError("\(PlistManager.shared.string(forKey: "constructURL")) \(PlistManager.shared.string(forKey: "urlFail"))")
            }
            let stringURL = "\(baseURL)\(location)\(encodedQuery)"
            return URL(string: stringURL)
        } catch {
            throw TraceUserError.clientError("\(PlistManager.shared.string(forKey: "constructURL")) \(error)")
        }
    }
    //    경로 관련 URL 추출
    private func fetchLocationURL(LocationStatus: Int) throws -> String {
        var locationName = ""
        switch LocationStatus{
        case 1:
            locationName = try UtilityURLReturn.LOCATION_WALLET()
        case 2:
            locationName = try UtilityURLReturn.LOCATION_COMMON()
        default:
            locationName = ""
        }
        return locationName
    }
    //    HTTP 메소드 별로 Body 데이터 세팅
    private func configureRequest(_ request: inout URLRequest) throws {
        request.httpMethod = httpStructs.method
        request.setValue("Bearer \(httpStructs.token)", forHTTPHeaderField: "Authorization")
        request.setValue(httpStructs.UUID, forHTTPHeaderField: "X-Device-UUID")
        if let verify_token = httpStructs.verify_token{
            request.setValue("\(verify_token)", forHTTPHeaderField: "verify-token")
        }
        if httpStructs.method != "GET" {
            do {
                let postData = try JSONEncoder().encode(httpStructs.requestVal)
                request.httpBody = postData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw TraceUserError.clientError("\(PlistManager.shared.string(forKey: "clientError")) \(PlistManager.shared.string(forKey: "configureRequest"))")
            }
        }
    }
    //    객체 리턴
    private func handleResponse(data: Data, response: URLResponse) throws -> (success: Bool, data: ReturnType?,ErrorMessage: String?) {
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Response is not an HTTPURLResponse")
            throw TraceUserError.clientError("\(PlistManager.shared.string(forKey: "handleResponse"))") // 적절한 에러 처리
        }
        let statusCode = httpResponse.statusCode
        let responseBody = String(data: data, encoding: .utf8) ?? "Unable to decode response body"
        print("✅ response Body \(responseBody)")
        if 202 == statusCode || 203 == statusCode{
            return (false, nil, nil)
        }
        else if (400..<500).contains(statusCode) {
            print("HTTP Client Error with status code: \(statusCode) \n \(responseBody))")
            throw TraceUserError.clientError("\(PlistManager.shared.string(forKey: "handleResponse")) : \(statusCode), \(responseBody)")
        } else if (500..<600).contains(statusCode) {
            print("HTTP Server Error with status code: \(statusCode)")
            throw TraceUserError.serverError("\(PlistManager.shared.string(forKey: "handleResponse")) : \(statusCode), \(responseBody)")
        }
        do {
            let jsonData = try JSONDecoder().decode(ReturnType.self, from: data)
            
            return (true, jsonData, nil)
        } catch {
            print("JSON Decoding Error: \(error)")
            throw TraceUserError.jsonParseError("\(PlistManager.shared.string(forKey: "handleResponse")) : \(error)")
        }
    }
}
