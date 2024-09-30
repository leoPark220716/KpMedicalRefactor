//
//  ReacoderModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/30/24.
//

import Foundation
import BigInt

class ReacoderModel:WalletContractCrypto{
    var DocRecode: [DoctorRecord] = []
    var PhaRecode: [PharmacistRecord] = []
    @Published var combineArray: [MedicalCombineArrays] = []
    var contract: String = ""
    init(appManager: NavigationRouter) {
        super.init()
        Task{
            do{
                try SetTokenAndAccount(appManager: appManager)
                try await setUpWeb3Datas()
            }catch let error as TraceUserError{
                await appManager.displayError(ServiceError: error)
            }catch{
                await appManager.displayError(ServiceError: .unowned(error.localizedDescription))
            }
        }
    }
    
    private func RecodeModelReturningUnDecodArray(dic: [String:Any]) -> (success: Bool, contractResult: getRecodeFromSmartContract?){
        print(dic)
        do{
            let smartContract = try getRecodeFromSmartContract(from: dic)
            print("✅contract parse success")
            return (true, smartContract)
        }catch{
            print("Error Print \(error)")
            return (false, nil)
        }
    }
    
    func setRecodeData(){
        if combineArray.isEmpty{
            Task{
                self.contract =  try await self.getContract()
                print("👀 SmartContractConfirm \(self.contract)")
                let password = try self.GetPasswordKeystore(account: self.UserAccount)
                print("👀 SmartContractConfirm \(password)")
                let privateKeyData = try self.GetWalletPrivateKey(password: password.password)
                let confirm = try await self.callConfirmReadRecode(privateKey: privateKeyData, param1: 9999, param2: 100, methodName: "getMyRecord", password: password.password, contractAddress: self.contract)
                if !confirm.success {
                    print("❌컨트랙트 가져오기 실패")
                    return
                }
                let ParseContract = RecodeModelReturningUnDecodArray(dic: confirm.result)
                if !ParseContract.success{
                    print("❌pase 실패")
                    return
                }
                guard let array = ParseContract.contractResult else{
                    return
                }
                let setSymetricKey = self.getSymetricKeysInRecodeMode(array: array)
                if !setSymetricKey.success{
                    print("❌setSymetricKey")
                    return
                }
                let decodedData = try decodeMedicalDataArray(array: setSymetricKey.contractResult!)
                if !decodedData.success{
                    print("❌복호화 실패")
                }
                print("✅✅✅✅✅✅✅✅✅✅복호화 확인✅✅✅✅✅✅✅✅✅✅")
                print(decodedData.contractResult!)
                
                let docarray = finalMedicalDocDatas(array: decodedData.contractResult!)
                if docarray.success {
                        self.DocRecode = docarray.DocArray
                    
                }
                let phaarray = finalMedicalPhaDatas(array: decodedData.contractResult!)
                if phaarray.success {
                    
                        self.PhaRecode = phaarray.PhaArray
                    
                }
                let combinData = await finalMedicalCombineDatasList(array: decodedData.contractResult!, token: token)
                if combinData.success{
                    DispatchQueue.main.async {
                        self.combineArray = combinData.comArray
                    }
                }
            }
        }
    }
    
    func LastRecodeData() async throws -> (success: Bool,item:DoctorRecord?){
        print("Call LastRecodedData LastRecodeData")
        self.contract =  try await self.getContract()
        print("👀 SmartContractConfirm \(self.contract)")
        let password = try self.GetPasswordKeystore(account: self.UserAccount)
        print("👀 SmartContractConfirm \(password)")
        let privateKeyData = try self.GetWalletPrivateKey(password: password.password)
        let confirm = try await self.callConfirmReadRecode(privateKey: privateKeyData, param1: 9999, param2: 100, methodName: "getMyRecord", password: password.password, contractAddress: self.contract)
        if !confirm.success {
            print("❌컨트랙트 가져오기 실패")
            return (false,nil)
        }
        let ParseContract = RecodeModelReturningUnDecodArray(dic: confirm.result)
        if !ParseContract.success{
            print("❌pase 실패")
            return (false,nil)
        }
        guard let array = ParseContract.contractResult else{
            return (false,nil)
        }
        let setSymetricKey = self.getSymetricKeysInRecodeMode(array: array)
        if !setSymetricKey.success{
            print("❌개인키 가져오기 실패")
            return (false,nil)
        }
        guard let symetricArray = setSymetricKey.contractResult else {
            return (false,nil)
        }
        let decodedData = try decodeMedicalDataArray(array: symetricArray)
        if !decodedData.success{
            print("❌복호화 실패")
            return (false,nil)
        }
        print("✅✅✅✅✅✅✅✅✅✅복호화 확인✅✅✅✅✅✅✅✅✅✅")
        print(decodedData.contractResult!)
        let docarray = finalMedicalDocDatas(array: decodedData.contractResult!)
        if !docarray.success {
            return (false,nil)
        }
        let combinData = finalMedicalCombineDatas(array: decodedData.contractResult!)
        if !combinData.success{
            return (false,nil)
        }
        return (true,docarray.DocArray.last)
        
    }
    private func sepStrings(inputString: String) -> (er :Bool, DocId: String, DocName:String, hsNmae: String){
        let componets = inputString.components(separatedBy: ",")
        guard componets.count == 3 else{
            return (true,"","","")
        }
        return (false,componets[0],componets[1],componets[2] )
    }
    private func returnDepartName(departCode: Int) -> String{
        if let department = Department(rawValue: departCode) {
            return department.name
        }else{
            return "일반의"
        }
    }
    //    대칭키 추출
    private func getSymetricKeysInRecodeMode(array: getRecodeFromSmartContract) -> (success: Bool, contractResult: [MedicalData]?){
        var returnItem: [MedicalData] = []
        guard let privatKey = getPrivateKeyFromKeyChain(account: UserAccount) else{
            return (false,nil)
        }
        for item in array.items{
            //            대칭키 복호화 후 새로운 배열 리턴
            let symetricKey = prkeyDecoding(privateKey: privatKey, encodeKey: item.patientKey)
            if symetricKey.success{
                print("✅decode Key success")
                print("decode key value : \(symetricKey.decodeKey)")
                returnItem.append(MedicalData(index: item.index, hospitalId: item.hospitalId, doctorRecode: item.doctorRecode, pharmaciRecode: item.pharmaciRecode, patientKey: symetricKey.decodeKey, departmentCode: item.departmentCode, unixTime: item.unixTime))
                
            }else{
                print("❌시메트릭키 뽑아오기 실패")
                print("Undecode key value : \(item.patientKey)")
            }
        }
        return (true, returnItem)
    }
    
    
    //    묶음 데이터
    private func finalMedicalCombineDatas(array: [MedicalData]) -> (success: Bool,comArray: [MedicalCombineArrays]){
        var combineDatas: [MedicalCombineArrays] = []
        for item in array{
            let parseData = getDecodeComRecode(PhaJosnString: item.pharmaciRecode,DocJsonString: item.doctorRecode,departCode: Int(item.departmentCode),unix: Int(item.unixTime),hospitalId: Int(item.hospitalId))
            if parseData.success{
                combineDatas.append(parseData.com!)
            }
        }
        print("✅✅✅✅✅✅✅✅✅✅Check CombineDatas✅✅✅✅✅✅✅✅✅✅")
        print(combineDatas)
        if combineDatas.isEmpty{
            return (false,[])
        }
        
        return (true,combineDatas)
    }
    //  묶음 데이터   리스트
    private func finalMedicalCombineDatasList(array: [MedicalData], token: String) async -> (success: Bool, comArray: [MedicalCombineArrays]) {
        var combineDatas: [MedicalCombineArrays] = []
        
        // 기존 데이터 처리
        for item in array {
            let parseData = getDecodeComRecode(PhaJosnString: item.pharmaciRecode, DocJsonString: item.doctorRecode, departCode: Int(item.departmentCode), unix: Int(item.unixTime), hospitalId: Int(item.hospitalId))
            if parseData.success {
                combineDatas.append(parseData.com!)
            }
        }
        
        print("✅✅✅✅✅✅✅✅✅✅Check CombineDatas✅✅✅✅✅✅✅✅✅✅")
        print(combineDatas)
        
        if combineDatas.isEmpty {
            return (false, [])
        }
        
        // 비동기 작업 결과를 저장할 배열
        var updatedCombineDatas = combineDatas
        
        // 비동기 작업을 수행하고 결과를 모음
        await withTaskGroup(of: (Int, String?).self) { group in
            for (index, i) in combineDatas.enumerated() {
                if !i.doc.symptoms.files.isEmpty {
                    group.addTask {
                        let imgURL = try? await self.getContractLists(bucket: i.doc.symptoms.files[0].bucket, key: i.doc.symptoms.files[0].key)
                        return (index, imgURL)
                    }
                }
            }
            
            // 결과를 모아 배열 업데이트
            for await (index, imgURL) in group {
                if let imgURL = imgURL {
                    updatedCombineDatas[index].ImageUrl = imgURL
                }
            }
        }
        
        return (true, updatedCombineDatas)
    }

    
    
    
    //    묶음 기록 반환
    private func getDecodeComRecode(PhaJosnString: String,DocJsonString: String,departCode: Int,unix: Int,hospitalId: Int) -> (success: Bool ,com : MedicalCombineArrays?){
        let Pha = PhaJosnString.data(using: .utf8)!
        let Doc = DocJsonString.data(using: .utf8)!
        var ComRecode: MedicalCombineArrays
        var PhaRecodeData: PharmacistRecord
        var DocRecodeData: DoctorRecord
        do{
            let PhaData = try JSONDecoder().decode(PhaRoot.self, from: Pha)
            print("✅ success Pha : \(PhaData.pharmacist_record.type1)")
            PhaRecodeData = PhaData.pharmacist_record
        }catch{
            print("❌pha Err : \(error)")
            return (false, nil)
        }
        do{
            var DocData = try JSONDecoder().decode(DoCRoot.self, from: Doc)
            print("✅ success Doc : \(DocData.doctor_record.doctorID)")
            DocData.doctor_record.departmentCode = departCode
            DocRecodeData = DocData.doctor_record
        }catch{
            print("❌doc Err : \(error)")
            return (false, nil)
        }
        ComRecode = MedicalCombineArrays(doc: DocRecodeData, pha: PhaRecodeData,unixTiem: unix, hospitalId: hospitalId)
        return (true, ComRecode)
    }
//    private func getImageURL(token: String, bucket: String,key: String)async -> (String){
//        let img = await model.TokenToServer(httpMethod: "GET", tocken: token, bucket: bucket, key: key)
//        return img
//    }
    
    //
    private func finalMedicalDocDatas(array: [MedicalData]) -> (success: Bool,DocArray: [DoctorRecord]){
        var DocRecode: [DoctorRecord] = []

        for item in array {
            let parseData = getDecodeDocRecode(DocJsonString: item.doctorRecode,depart: Int(item.departmentCode))
            if parseData.success{
                DocRecode.append(parseData.doc!)
                print("✅✅✅✅✅✅✅✅✅✅")
                print(DocRecode[0])
            }
        }
        print(DocRecode.count)
        if DocRecode.count != 0{
            print("Doc is not Empty")
            print(DocRecode)
            return (true,DocRecode)
        }
        return (false,[])
    }
    private func finalMedicalPhaDatas(array: [MedicalData]) -> (success: Bool,PhaArray: [PharmacistRecord]){
        var PhaRecode: [PharmacistRecord] = []
        for item in array{
            let parseData = getDecodePhaRecode(PhaJosnString: item.pharmaciRecode)
            if parseData.success{
                PhaRecode.append(parseData.pha!)
            }
        }
        if !PhaRecode.isEmpty{
            return (true,PhaRecode)
        }
        return (false,[])
    }
    //    처방데이터 기록 반환
    private func getDecodePhaRecode(PhaJosnString: String) -> (success: Bool ,pha : PharmacistRecord?){
        let Pha = PhaJosnString.data(using: .utf8)!
        var PhaRecodeData: PharmacistRecord
        do{
            let PhaData = try JSONDecoder().decode(PhaRoot.self, from: Pha)
            print("✅ success Pha : \(PhaData.pharmacist_record.type1)")
            PhaRecodeData = PhaData.pharmacist_record
        }catch{
            print("❌pha Err : \(error)")
            return (false, nil)
            
        }
        return (true, PhaRecodeData)
    }
    //    의사 기록 반환
    private func getDecodeDocRecode(DocJsonString: String,depart: Int) -> (success: Bool ,doc : DoctorRecord?){
        let Doc = DocJsonString.data(using: .utf8)!
        var DocRecodeData: DoctorRecord
        do{
            var DocData = try JSONDecoder().decode(DoCRoot.self, from: Doc)
            print("✅ success Doc : \(DocData.doctor_record.doctorID)")
            DocData.doctor_record.departmentCode = depart
            DocRecodeData = DocData.doctor_record
        }catch{
            print("❌doc Err : \(error)")
            return (false, nil)
            
        }
        return (true, DocRecodeData)
    }
    //    데이터 복호화
    private func decodeMedicalDataArray(array: [MedicalData]) throws -> (success: Bool, contractResult: [MedicalData]?){
        var returnItem: [MedicalData] = []
        for item in array{
            let doctorRecode = try decodeMedicalData(symatricKey: item.patientKey, encodeData: item.doctorRecode)
            let pharmaciRecode = try decodeMedicalData(symatricKey: item.patientKey, encodeData: item.pharmaciRecode)
            if doctorRecode.success && pharmaciRecode.success{
                returnItem.append(MedicalData(index: item.index,
                                              hospitalId: item.hospitalId,
                                              doctorRecode: doctorRecode.result,
                                              pharmaciRecode: pharmaciRecode.result,
                                              patientKey: item.patientKey,
                                              departmentCode: item.departmentCode,
                                              unixTime: item.unixTime))
            }else{
                return (false,nil)
            }
        }
        return (true,returnItem)
    }
    
    
    
    

    
}

