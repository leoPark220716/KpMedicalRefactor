//
//  HospitalReservationModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/18/24.
//

import Foundation
import NMapsMap

class HospitalReservationModel: HospitalSchedule{
    @Published var nameHospital = ""
    
    @Published var telephone = "" {
        didSet{
            let formatted = formatKoreanPhoneNumber(telephone)
            if telephone != formatted {
                telephone = formatted
            }
        }
    }
    @Published var address = ""
    @Published var liked = false
    func setUpDetailView(){
        Task{
            do{
                try await getHospitalInfomation()
            }catch{
                await appManager?.displayError(ServiceError: error)
            }
        }
    }
    
    private func getHospitalInfomation() async throws {
        
        do{
            let request = try createRequestStructHospitalDetailView()
            let call = KPWalletAPIManager.init(httpStructs: request, URLLocations: 1)
            let response = try await call.performRequest()
            if response.data?.status == 200 {
                guard let info = response.data?.data else {
                    throw TraceUserError.clientError(PlistManager.shared.string(forKey: "getHospitalInfomation"))
                }
                await setHospitalInfomation(info: info)
            }else{
                throw TraceUserError.managerFunction(PlistManager.shared.string(forKey: "hospital_detail_user_guaid"))
            }
        }catch{
            throw error
        }
        
    }
    
    // 요청 객체 생성
    private func createRequestStructHospitalDetailView() throws -> http<Empty?, KPApiStructFrom<HospitalDataClass>> {
        if let token = appManager?.jwtToken, let id = hospitalId{
            return http<Empty?, KPApiStructFrom<HospitalDataClass>>(
                method: "GET",
                urlParse: "v2/hospitals/detail?hospital_id=\(id)",
                token: token,
                UUID: UserVariable.GET_UUID()
            )
        }else{
            throw TraceUserError.clientError(PlistManager.shared.string(forKey: "createRequestStructHospitalDetailView"))
        }
    }
    
    @MainActor
    private func setHospitalInfomation(info: HospitalDataClass){
        mapCoord = NMGLatLng(lat: info.hospital.y, lng: info.hospital.x)
        HospitalSchedules = info.doctors.flatMap{$0.main_schedules}
        DoctorProfile = info.doctors
        hospitalIamges = info.hospital.img_url
        telephone = info.hospital.phone
        address = info.hospital.location
        let department: [Int] = info.hospital.department_id.compactMap{Int($0)}
        hospitalDepartments = department
        HospitalSubSchedules = info.doctors.flatMap{$0.sub_schedules}
        reservationData.hospital_id = info.hospital.hospital_id
        nameHospital = info.hospital.hospital_name
        liked = info.hospital.marked == 1
    }
    
    
    func formatKoreanPhoneNumber(_ numberString: String) -> String {
        let cleanPhoneNumber = numberString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // 지역번호가 있는 경우
        if cleanPhoneNumber.count == 9 { // 지역번호 + 7자리 번호
            let index = cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: 2)
            return "\(cleanPhoneNumber.prefix(2))-\(cleanPhoneNumber[index...].prefix(3))-\(cleanPhoneNumber.suffix(4))"
        } else if cleanPhoneNumber.count == 10 { // 02 지역번호 또는 휴대폰 번호
            if cleanPhoneNumber.hasPrefix("02") { // 서울 지역번호
                let index = cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: 2)
                return "\(cleanPhoneNumber.prefix(2))-\(cleanPhoneNumber[index...].prefix(4))-\(cleanPhoneNumber.suffix(4))"
            } else { // 다른 지역번호 또는 휴대폰 번호
                let index = cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: 3)
                return "\(cleanPhoneNumber.prefix(3))-\(cleanPhoneNumber[index...].prefix(3))-\(cleanPhoneNumber.suffix(4))"
            }
        } else if cleanPhoneNumber.count == 11 { // 휴대폰 번호
            let index = cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: 3)
            return "\(cleanPhoneNumber.prefix(3))-\(cleanPhoneNumber[index...].prefix(4))-\(cleanPhoneNumber.suffix(4))"
        } else { // 다른 형식의 번호
            return numberString // 원본 번호를 그대로 반환
        }
    }
    // 뷰 이동 핸들 객체
    @MainActor
    func goToChooseDepartmentView(){
        appManager?.push(to: .userPage(item: UserPage(page: .chooseDepartment),reservationModel: self))
    }
    @MainActor
    func goToChooseDoctorView(){
        appManager?.push(to: .userPage(item: UserPage(page: .chooseDoctor),reservationModel: self))
    }
    @MainActor
    func goToChooseDateView(){
        appManager?.push(to: .userPage(item: UserPage(page: .chooseDate),reservationModel: self))
    }
    @MainActor
    func goToChooseTimeView(){
        appManager?.push(to: .userPage(item: UserPage(page: .chooseTime),reservationModel: self))
    }
    @MainActor
    func goToReservationFinalView(){
        appManager?.push(to: .userPage(item: UserPage(page: .reservationFinal),reservationModel: self))
    }
    @MainActor
    func goToSymptomEditorView(){
        appManager?.push(to: .userPage(item: UserPage(page: .reservationSymptom),reservationModel: self))
    }
    
    
    @MainActor
    func DateViewGoToNextView(){
        if isSetDoctor{
            goToChooseTimeView()
        }else{
            goToChooseDoctorView()
        }
    }
    
    @MainActor
    func DoctorViewGoToNextView(){
        if isSetDate{
            goToChooseTimeView()
        }else{
            goToChooseDateView()
        }
    }
    @MainActor
    func goToMyReservationView(){
        appManager?.goToRootView()
        appManager?.push(to: .userPage(item: UserPage(page: .myReservationView)))
    }
    
    
    //   에약 취소 호출
    func requestCencleReservation(reservationId: Int) throws {
        Task{
            do{
                let request = try createRequestReservationDelete(reservationId: reservationId)
                let call = KPWalletAPIManager(httpStructs: request, URLLocations: 1)
                let response = try await call.performRequest()
                if response.success{
                    await MainActor.run {
                        appManager?.goBack()
                        appManager?.toast = normal_Toast(message: PlistManager.shared.string(forKey: "success_cancle_reservation"))
                    }
                    
                }else{
                    throw TraceUserError.serverError(PlistManager.shared.string(forKey: "reservation_cancle_error"))
                }
            }catch{
                throw error
            }
        }
    }
    
    // 예약 취소
    private func createRequestReservationDelete(reservationId: Int) throws ->
    http<ReservationCencle?,KPApiStructFrom<reservationResponse>>{
        do{
            guard let token = appManager?.jwtToken else{
                throw TraceUserError.clientError("appManagerNil")
            }
            let body  = ReservationCencle(reservation_id: reservationId)
            return http(
                method: "DELETE",
                urlParse: "v2/hospitals/reservations/back",
                token: token,
                UUID: UserVariable.GET_UUID(),
                requestVal: body
            )
        }catch{
            throw error
        }
    }
    
    func requestLikedMyHospital() {
        Task{
            do{
                let request = try createRequestLikedChange()
                let call = KPWalletAPIManager(httpStructs: request, URLLocations: 1)
                let response = try await call.performRequest()
                if response.success{
                    await changeLiked(like: response.data?.data.mark_id != -1 ? true : false)
                }else{
                    await appManager?.displayError(ServiceError: .serverError(PlistManager.shared.string(forKey: "requestLikedMyHospitalServerError")))
                }
            }catch let error as TraceUserError{
                await appManager?.displayError(ServiceError: error)
            }catch{
                await appManager?.displayError(ServiceError: .unowned(PlistManager.shared.string(forKey: "requestLikedMyHospital")))
            }
        }
    }
    @MainActor
    private func changeLiked(like: Bool){
        liked = like
    }
    
    // 내병원 등록 및 취소 request
    func createRequestLikedChange() throws -> http<requestLikedHospitalBody?, KPApiStructFrom<requestLikedHospitalResponseBody>> {
        guard let hospitalId = hospitalId else{
            throw TraceUserError.clientError(PlistManager.shared.string(forKey: "createRequestLikedChange_hospitalId"))
        }
        guard let token = appManager?.jwtToken else{
            throw TraceUserError.clientError(PlistManager.shared.string(forKey: "createRequestLikedChange_hospitalId"))
        }
        let body = requestLikedHospitalBody(hospital_id: hospitalId)
        return http(
            method: "POST",
            urlParse: "v2/users/marks",
            token: token,
            UUID: UserVariable.GET_UUID(),
            requestVal: body
        )
    }
}
