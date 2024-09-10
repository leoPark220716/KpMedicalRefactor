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
    
    init(httpStructs: http<RequestType?, ReturnType>) {
        self.httpStructs = httpStructs
    }
    
//    해당 함수 호출로 Request 코드 호출
    func performRequest() async -> (success: Bool, data: ReturnType?) {
        guard let url = constructURL() else {
            print("Invalid URL")
            return (false, nil)
        }
        var request = URLRequest(url: url)
        configureRequest(&request)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return handleResponse(data: data, response: response)
        } catch {
            print("Request Error: \(error)")
            return (false, nil)
        }
    }
//    URL 생성
    private func constructURL() -> URL? {
        let query = httpStructs.urlParse
        let baseURL = fetchBaseURL()
        let location = fetchLocationURL(LocationStatus: URLLocations)
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        let stringURL = "\(baseURL)\(location)\(encodedQuery)"
        return URL(string: stringURL)
    }
//    URL Config 에서 추출
    private func fetchBaseURL() -> String {
        if let config = Bundle.main.object(forInfoDictionaryKey: "Config") as? [String: String],
           let apiDomain = config["API_SERVER"] {
            return apiDomain
        } else {
            return "api_domain"
        }
    }
//    경로 관련 URL 추출
    private func fetchLocationURL(LocationStatus: Int) -> String {
        var configName = ""
        switch LocationStatus{
        case 1:
            configName = "URL_LOCATION_WALLET"
        case 2:
            configName = "URL_LOCATION_COMMON"
        default:
            configName = ""
        }
        if let config = Bundle.main.object(forInfoDictionaryKey: "Config") as? [String: String],
           let apiDomain = config[configName] {
            return apiDomain
        } else {
            return "api_domain"
        }
    }
//    HTTP 메소드 별로 Body 데이터 세팅
    private func configureRequest(_ request: inout URLRequest) {
        request.httpMethod = httpStructs.method
        request.setValue("Bearer \(httpStructs.token)", forHTTPHeaderField: "Authorization")
        request.setValue(httpStructs.UUID, forHTTPHeaderField: "X-Device-UUID")
        
        if httpStructs.method != "GET" {
            do {
                let postData = try JSONEncoder().encode(httpStructs.requestVal)
                request.httpBody = postData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("Encoding Error: \(error)")
            }
        }
    }
//    객체 리턴
    private func handleResponse(data: Data, response: URLResponse) -> (success: Bool, data: ReturnType?) {
        guard let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode else {
            print("Request HTTP response Error: \(response)")
            return (false, nil)
        }
        do {
            let jsonData = try JSONDecoder().decode(ReturnType.self, from: data)
            return (true, jsonData)
        } catch {
            print("JSON Decoding Error: \(error)")
            return (false, nil)
        }
    }
}
