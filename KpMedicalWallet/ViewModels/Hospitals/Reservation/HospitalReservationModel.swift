//
//  HospitalReservationModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/18/24.
//

import Foundation
import NMapsMap

class HospitalReservationModel: HospitalSchedule{
    
    @Published var telephone = "" {
        didSet{
            let formatted = formatKoreanPhoneNumber(telephone)
            if telephone != formatted {
                telephone = formatted
            }
        }
    }
    @Published var address = ""
    
    func setUpDetailView(){
        Task{
            do{
                try await getHospitalInfomation()
            }catch let error as TraceUserError{
                await appManager?.displayError(ServiceError: error)
            }catch{
                await appManager?.displayError(ServiceError: .unowned("\(PlistManager.shared.string(forKey: "unknownsError")) \(error.localizedDescription)"))
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
    
}