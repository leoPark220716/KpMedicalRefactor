//
//  HomeViewModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/14/24.
//

import Foundation

class HomeViewModel: ObservableObject{
    var token = ""
    @Published var recomendImage1 = ""
    @Published var recomendImage2 = ""
    @Published var recomendImage3 = ""
    
    func requestRecomendHospitalImages() throws {
        if recomendImage1 == ""{
            Task{
                do{
                    let request = createRecomendHospitalsImages()
                    let call = KPWalletAPIManager(httpStructs: request, URLLocations: 1)
                    let response = try await call.performRequest()
                    if response.success{
                        let defaultImage = "https://example.com/default-image.png"  // 기본 이미지 URL
                        
                        guard let recommendHospitals = response.data?.data.recommendHospitals else {
                            throw TraceUserError.authData("")
                        }
                        let icons = recommendHospitals.map { $0.icon }
                        let iconUrls = icons + Array(repeating: defaultImage, count: max(0, 3 - icons.count))
                        await MainActor.run {
                            recomendImage1 = iconUrls[0]
                            recomendImage2 = iconUrls[1]
                            recomendImage3 = iconUrls[2]
                        }
                    }
                }catch{
                    throw error
                }
            }
        }
    }
    
    private func createRecomendHospitalsImages() -> http<Empty?, HomViewResponse>{
        return http(
            method: "GET",
            urlParse: "v2/recommend",
            token: token,
            UUID: UserVariable.GET_UUID()
        )
    }
}
