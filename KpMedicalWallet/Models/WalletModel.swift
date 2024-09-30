//
//  WalletModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//
import Foundation
import BigInt
struct WalletModel{
    struct SaveContract: Codable{
        let access_token: String
        let uid: String
        let contract: String
    }
    struct SaveContractResponseData: Codable{
        let access_token: String
        let affected_rows: Int
        let error_code: Int
        let error_stack: String
    }
    
    
    struct SaveWalletData: Codable{
        let access_token: String
        let uid: String
        let address: String
        let encrypt_rsa: String
        let type: Int
    }
    
    struct WalletInfomationResponse: Codable{
        let access_token: String
        let encrypt_rsa: String
        let address: String?
        let contract: String?
        let error_code: Int
        let error_stack: String
    }
    struct AccessItem{
        let HospitalName: String
        let Purpose: String
        let State: Bool
        let Date: String
        let blockHash: String
        let unixTime: Int
        let room_key: String
        let msg_type: String
        let timestamp_uuid: String
    }
    
    
    
    
    
    struct TransactionItems: Codable{
        let room_key: String
        let timestamp_uuid: String
        let msg_type: Int
        let from: String
        let to: String
        let content_type: String
        let message: String
        let file_cnt: Int
        let bucket: [String]
        let key: [String]
        let hospital_id: Int
        let unixtime: Int
        let index: Int
        let pub_key: String
        let hash: String
        let status: Int
        let timestamp: String
        let hospital_name: String
    }
    struct getListData: Codable{
        let transactions: [TransactionItems]
        let error_code: Int
        let error_stack: String
    }
    struct updateContractBody: Codable{
        let room_key:String
        let msg_type: Int
        let timestamp_uuid:String
    }
    struct updateContractResponse : Codable{
        let status: Int
        let success: String
        let message: String
        let data: datafiled
    }
    struct datafiled: Codable{
        let affectedRows: Int
        let error_code: Int
        let error_stack: String
    }
}
struct getShaerFromSmartContract {
    let items: [ShareStructForm]
    init(from dictionary: [String: Any]) throws {
        
        guard let data = dictionary["0"] as? [[Any]] else {
            throw NSError(domain: "Invalid data", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing or invalid data array"])
        }
        self.items = try data.map { array in
            do {
                return try ShareStructForm(from: array)
            } catch {
                print("Failed to parse Item from array: \(array), error: \(error.localizedDescription)")
                throw error
            }
        }
    }
}
struct SharedData {
    let index: BigUInt
    let hospital_id :BigUInt
    let hospital_key: String
}
struct ShareStructForm: Codable {
    var index: BigUInt
    var patient_key: String
    
    init(index: BigUInt,patient_key: String){
        self.index = index
        self.patient_key = patient_key
    }
    init(from array: [Any]) throws {
        guard array.count == 2 else {
            throw NSError(domain: "Invalid Array", code: 1, userInfo: [NSLocalizedDescriptionKey: "Array does not contain exactly 8 elements"])
        }
        guard let index = array[0] as? BigUInt else {
            throw NSError(domain: "Invalid id", code: 1, userInfo: [NSLocalizedDescriptionKey: "\(array[0])"])
        }
        guard let patient_key = array[1] as? String else {
            throw NSError(domain: "Invalid value", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid value"])
        }
        self.index = index
        self.patient_key = patient_key
        
    }
}
struct MedicalCombineArrays: Codable{
    var doc: DoctorRecord
    var pha : PharmacistRecord
    var unixTiem: Int
    var hospitalId: Int
    var ImageUrl: String?
}
struct MedicalData: Codable {
    var index: BigUInt
    var hospitalId: BigUInt
    var doctorRecode: String
    var pharmaciRecode: String
    var patientKey: String
    var hospitalKey: String
    var departmentCode: BigUInt
    var unixTime: BigUInt
    
    init(index: BigUInt, hospitalId: BigUInt, doctorRecode: String, pharmaciRecode: String, patientKey: String, departmentCode: BigUInt, unixTime: BigUInt) {
        self.index = index
        self.hospitalId = hospitalId
        self.doctorRecode = doctorRecode
        self.pharmaciRecode = pharmaciRecode
        self.patientKey = patientKey
        self.hospitalKey = ""
        self.departmentCode = departmentCode
        self.unixTime = unixTime
        
    }
    init(from array: [Any]) throws {
        guard array.count == 8 else {
            throw NSError(domain: "Invalid Array", code: 1, userInfo: [NSLocalizedDescriptionKey: "Array does not contain exactly 8 elements"])
        }
        guard let index = array[0] as? BigUInt else {
            throw NSError(domain: "Invalid id", code: 1, userInfo: [NSLocalizedDescriptionKey: "\(array[0])"])
        }
        guard let hospitalId = array[1] as? BigUInt else {
            throw NSError(domain: "Invalid value", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid value"])
        }
        guard let doctorRecode = array[2] as? String else {
            throw NSError(domain: "Invalid enc", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid encryptedData"])
        }
        guard let pharmaciRecode = array[3] as? String else {
            throw NSError(domain: "Invalid key", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid key"])
        }
        guard let patientKey = array[4] as? String else {
            throw NSError(domain: "Invalid data", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid validation"])
        }
        guard let hospitalKey = array[5] as? String else {
            throw NSError(domain: "Invalid data", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid emptyField"])
        }
        guard let departmentCode = array[6] as? BigUInt else {
            throw NSError(domain: "Invalid data", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid status"])
        }
        guard let unixTime = array[7] as? BigUInt else {
            throw NSError(domain: "Invalid data", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid timestamp"])
        }
        
        self.index = index
        self.hospitalId = hospitalId
        self.doctorRecode = doctorRecode
        self.pharmaciRecode = pharmaciRecode
        self.patientKey = patientKey
        self.hospitalKey = hospitalKey
        self.departmentCode = departmentCode
        self.unixTime = unixTime
    }
}

struct getRecodeFromSmartContract {
    let items: [MedicalData]
//        let success: Bool
    
    init(from dictionary: [String: Any]) throws {
//            guard let success = dictionary["_success"] as? Bool else {
//                throw NSError(domain: "Invalid data", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing or invalid _success key"])
//            }
        guard let data = dictionary["0"] as? [[Any]] else {
            throw NSError(domain: "Invalid data", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing or invalid data array"])
        }
//            self.success = success
        self.items = try data.map { array in
            do {
                return try MedicalData(from: array)
            } catch {
                print("Failed to parse Item from array: \(array), error: \(error.localizedDescription)")
                throw error
            }
        }
    }
}
struct DoCRoot: Codable {
    var doctor_record: DoctorRecord
}
struct DoctorRecord: Codable {
    let doctorID: String
    let staffID: Int
    let userID: String
    let symptoms: Symptoms
    let diseases: [Disease]
    let medicalTests: [MedicalTest]
    let treatments: [Treatment]
    let medicalSupplies: [MedicalSupply]
    let files: [File]
    var departmentCode: Int?
    var imgUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case doctorID = "doctor_id"
        case staffID = "staff_id"
        case userID = "user_id"
        case symptoms
        case diseases
        case medicalTests = "medical_tests"
        case treatments
        case medicalSupplies = "medical_spplies"
        case files
        case departmentCode
        case imgUrl
    }
}

struct Symptoms: Codable {
    let content: String
    let files: [File]
}

struct Disease: Codable ,Equatable,Hashable{
    let diseaseID: Int
    let diseaseCode: String
    let name: String
    let name_eng : String
    
    enum CodingKeys: String, CodingKey {
        case diseaseID = "disease_id"
        case diseaseCode = "disease_code"
        case name
        case name_eng
    }
}

struct MedicalTest: Codable {
    let testID: Int
    let feeCode: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case testID = "test_id"
        case feeCode = "fee_code"
        case name
    }
}

struct Treatment: Codable {
    let treatmentID: Int
    let feeCode: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case treatmentID = "treatment_id"
        case feeCode = "fee_code"
        case name
    }
}

struct MedicalSupply: Codable {
    let supplyID: Int
    let supplyCode: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case supplyID = "supply_id"
        case supplyCode = "supply_code"
        case name
    }
}

struct File: Codable,Equatable,Hashable {
    let name: String
    let bucket: String
    let key: String
}

struct PharmacistRecord: Codable {
    let type1: [MedicationType1]
    let type2: [MedicationType2]
    
    enum CodingKeys: String, CodingKey {
        case type1 = "type_1"
        case type2 = "type_2"
    }
}
struct MedicationType1: Codable ,Equatable, Hashable{
    let medicationID: Int
    let medicationCode: Int
    let name: String
    let formulation: String
    let period: Period
    
    enum CodingKeys: String, CodingKey {
        case medicationID = "medication_id"
        case medicationCode = "medication_code"
        case name
        case formulation
        case period
    }
}

struct Period: Codable, Equatable, Hashable{
    let morning: Int
    let lunch: Int
    let dinner: Int
    let days: Int
}

struct MedicationType2: Codable {
    let medicationID: Int
    let medicationCode: Int
    let name: String
    let formulation: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case medicationID = "medication_id"
        case medicationCode = "medication_code"
        case name
        case formulation
        case count
    }
}

struct PhaRoot: Codable {
    let pharmacist_record: PharmacistRecord
}
struct filesReusetBody:Codable{
    let bucket:String
    let key:String
}
struct filesReusetDataBody:Codable{
    let files:[filesReusetBody]
}
struct responseFileStruct:Codable{
    let files: [responsFilesData]
}
struct responsFilesData:Codable{
    let bucket:String
    let key:String
    let url:String
}
