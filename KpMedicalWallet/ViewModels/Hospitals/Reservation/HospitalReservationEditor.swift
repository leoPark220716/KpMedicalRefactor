//
//  HospitalReservationEditor.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/18/24.
//

import Foundation

class HospitalReservationEditor: HospitalDetailViewDataClass{
    @Published var symptom: String = ""
    let maxCharacters = 50
    @Published var SymptomAccess: Bool = false
    @Published var isRequestFinish: Bool = false
    @Published var isRequestFalse: Bool = false
    @MainActor
    func limitText(){
        if symptom != "" {
            SymptomAccess = true
        }
        if symptom.count > maxCharacters{
            SymptomAccess = false
        }
    }
    @MainActor
    func setSymptomData(){
        reservationData.symptom = symptom
    }
    func requestSaveReservation(){
        Task{
            do{
                let request = try createRequestReservationSave()
                let call = KPWalletAPIManager(httpStructs: request, URLLocations: 1)
                let response = try await call.performRequest()
                if response.success{
                    await MainActor.run {
                        isRequestFinish = true
                    }
                }else{
                    await MainActor.run {
                        isRequestFalse = true
                    }
                }
            }catch let error as TraceUserError{
                await appManager?.displayError(ServiceError: error)
            }catch{
                await appManager?.displayError(ServiceError: .unowned(error.localizedDescription))
            }
        }
    }
    
    func createReservationRequestBody() -> reservationRequest{
        return reservationRequest(
            hospital_id: reservationData.hospital_id,
            staff_id: reservationData.staff_id,
            date: reservationData.date,
            time: reservationData.time,
            purpose: reservationData.symptom,
            time_slot: reservationData.time_slot)
    }
    func createRequestReservationSave() throws -> http<reservationRequest?,KPApiStructFrom<reservationResponse>> {
        guard let token = appManager?.jwtToken else{
            throw TraceUserError.clientError("jwtTokenNull")
        }
        let body = createReservationRequestBody()
        return http(
            method: "POST",
            urlParse: "v2/hospitals/reservations",
            token: token,
            UUID: UserVariable.GET_UUID(),
            requestVal: body)
    }
}
