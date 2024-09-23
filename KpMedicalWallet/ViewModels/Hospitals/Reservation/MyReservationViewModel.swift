//
//  MyReservationViewModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/20/24.
//

import Foundation

class MyReservationViewModel: ObservableObject{
    @Published var reservations: [reservationArray] = []
    @Published var isLoading: Bool = true
    var appManager: NavigationRouter?
    var pages = (start: 0, limit: 30)
    var returnPages: String{
        var component = URLComponents()
        component.queryItems = [
            URLQueryItem(name: "start", value: "\(pages.start)"),
            URLQueryItem(name: "limit", value: "\(pages.limit)")
        ]
        return component.url?.query ?? ""
    }
    func addReservationList(){
        Task{
            do{
                try await httpRequestGetList()
            }catch let error as TraceUserError {
                await appManager?.displayError(ServiceError: error)
            }catch{
                await appManager?.displayError(ServiceError: .unowned("unowned"))
            }
        }
    }
    @MainActor
    func setLoadingTrue(){
        isLoading = true
    }
    @MainActor
    func setLoadingfalse(){
        isLoading = false
    }
    
    func setStart(){
        pages.start = reservations.count
    }
    
    @MainActor
    func goToReservationDetailView(index: Int){
        appManager?.push(to: .userPage(item: UserPage(page: .reservationDetail), reservation: reservations[index]))
    }
    @MainActor
    func initViewDatas(){
        reservations = []
        pages.start = 0
    }
    func setUpMyReservationList(){
        Task{
            do{
                await setLoadingTrue()
                try await httpRequestGetList()
            }catch let error as TraceUserError {
                await appManager?.displayError(ServiceError: error)
            }catch{
                await appManager?.displayError(ServiceError: .unowned("unowned"))
            }
        }
    }
    
    private func httpRequestGetList() async throws  {
        do{
            let request = try createGetReservationListRequest()
            let call = KPWalletAPIManager(httpStructs: request, URLLocations: 1)
            let response = try await call.performRequest()
            if response.success{
                guard let reservation = response.data?.data.reservations else{
                    throw TraceUserError.serverError("role false")
                }
                await MainActor.run {
                    reservations.append(contentsOf: reservation)
                }
            }
            await setLoadingfalse()
        }catch{
            throw error
        }
        
    }
    
    private func createGetReservationListRequest() throws -> http<Empty?,KPApiStructFrom<reservation>>{
        do{
            guard let token = appManager?.jwtToken else{
                throw TraceUserError.clientError("AppManager nil")
            }
            return http<Empty?, KPApiStructFrom<reservation>>(
                method: "GET",
                urlParse: "v2/hospitals/reservations/list?\(returnPages)",
                token: token,
                UUID: UserVariable.GET_UUID()
            )
        }catch{
            throw error
        }
        
    }
}
