//
//  ChatDataHandler.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import Foundation

class ChatDataHandler: ChatDataSet{
    
    
    func MethodCall(jsonData: Data){
        do {
            let decodedData = try JSONDecoder().decode(OpenChatRoomDataModel.ChatMessage.self, from: jsonData)
            if decodedData.from == String(hospitalId) || decodedData.from == account{
                if decodedData.msg_type == 1 {
                    print("decode Success \(decodedData.msg_type)")
                }
                else if decodedData.msg_type == 2 {
                    setAllRead()
                }else{
                    MyMsg(item:  decodedData)
                }
            }
        }
        catch{
            print("decode Error : \(error)")
        }
    }
    
    func getByHttpChatDataHandler(decodedData: [ChatHTTPresponseStruct.Chat_Message]) -> [ChatHandlerDataModel.ChatMessegeItem]{
        var ChatDatas: [ChatHandlerDataModel.ChatMessegeItem] = []
        for item in decodedData.reversed(){
            let time = timeChangeToChatTime(time: item.timestamp)
            let dateChatSet = chatDateViewItem(ChatPreData: ChatDatas, date: time.chatDate)
            if let dateItem = dateChatSet{
                ChatDatas.append(dateItem)
            }
            let timevisibility = MessegeTimeControl(reversed: true, ChatPreData: ChatDatas, msg_type: String(item.msg_type), time: time.chatTime, date: time.chatDate)
            if timevisibility.update, !ChatDatas.isEmpty{
                ChatDatas[ChatDatas.count - 1].showETC = false
            }
            switch HttpMessageType(contentType: item.content_type, fileArray: item.key, bucket: item.bucket,msg_type: item.msg_type){
                
            case .text:
                let item = textMessageItem(type: .text,messege: item.message, time: time.chatTime, date: time.chatDate, amI: returnItemSide(type: item.msg_type), unix: 0,timeStemp: item.timestamp_uuid)
                ChatDatas.append(item)
                
            case .photo:
                let imageArraySet = HttpDetermineFileType(from: item.key, bucket: item.bucket)
                let imageArray = HttPreturnURIArray(image: imageArraySet.fileArray)
                let item = textMessageItem(type: .photo, time: time.chatTime, date: time.chatDate, amI: returnItemSide(type: item.msg_type),imgAr: imageArray.imgArray, unix: 0,timeStemp: item.timestamp_uuid)
                ChatDatas.append(item)
                
            case .file:
                let fileArraySet = HttpDetermineFileType(from: item.key, bucket: item.bucket)
                let fileString = returnfileArrayHTTP(image: fileArraySet.fileArray)
                let item = textMessageItem(type: .file, time: time.chatTime, date: time.chatDate, amI: returnItemSide(type: item.msg_type),file: fileString.file[0], unix: 0,timeStemp: item.timestamp_uuid)
                ChatDatas.append(item)
                
            case .notice:
                print("asdf")
            case .share:
                if let unixTime = item.unixtime {
                    let item = textMessageItem(type: .share, messege: item.message, time: time.chatTime, date: time.chatDate, amI: .other, unix: unixTime, timeStemp: item.timestamp_uuid,status:  item.status,hash: item.hash)
                    ChatDatas.append(item)
                }
                
            case .edit:
                if let unixTime = item.unixtime {
                    let item = textMessageItem(type: .edit, messege: item.message, time: time.chatTime, date: time.chatDate, amI: .other, unix: unixTime, timeStemp: item.timestamp_uuid,status:  item.status,hash: item.hash)
                    ChatDatas.append(item)
                }
                
            case .unowned:
                print("Photo")
            case .move:
                let item = textMessageItem(type: .move, messege: item.message, time: time.chatTime, date: time.chatDate, amI: .other, unix: 0, timeStemp: item.timestamp_uuid)
                ChatDatas.append(item)
            case .save:
                print("✅ Save Check")
                if let unixTime = item.unixtime {
                    let item = textMessageItem(type: .save, messege: item.message, time: time.chatTime, date: time.chatDate, amI: .other, unix: unixTime, timeStemp: item.timestamp_uuid,status:  item.status,hash: item.hash)
                    ChatDatas.append(item)
                }
            }
        }
        return ChatDatas
    }
    private func MyMsg(item: OpenChatRoomDataModel.ChatMessage){
        let time = timeChangeToChatTime(time: item.timestamp)
        let dateChatSet = dateViewAdd(ChatPreData: ChatData, date: time.chatDate)
        // 날짜뷰 세팅
        if let dateItem = dateChatSet.item{
            DispatchQueue.main.async {
                self.ChatData.insert(dateItem, at: 0)
            }
        }
        let timeUpdate = MessegeTimeControl(reversed: false, ChatPreData: ChatData, msg_type: String(item.msg_type), time: time.chatTime, date: time.chatDate)
        if timeUpdate.update,!ChatData.isEmpty{
            DispatchQueue.main.async{
                self.ChatData[0].showETC = false
            }
        }
        switch messageType(contentType: item.content_type,fileArray: item.content?.key,bucket: item.content?.bucket,msg_type: item.msg_type ){
        case .text:
            let item = textMessageItem(type: .text,messege: item.content?.message, time: time.chatTime, date: time.chatDate, amI: returnItemSide(type: item.msg_type), unix: 0,timeStemp: item.timestamp,show: item.on)
            DispatchQueue.main.async {
                self.ChatData.insert(item, at: 0)
            }
        case .photo:
            guard let key = item.content?.key, let bucket = item.content?.bucket else {
                print("❌ Error  Server 👀 Bucket Key Missing")
                return
            }
            let images = determineFileType(from: key, bucket: bucket)
            let iamgeArray = returnURIArray(image: images.imageArray)
            let item = textMessageItem(type: .photo, time: time.chatTime, date: time.chatDate, amI: returnItemSide(type: item.msg_type),imgAr: iamgeArray.imgArray ,unix: 0,timeStemp: item.timestamp,show: item.on)
            if item.amI == .user{
                for index in ChatData.indices{
                    if ChatData[index].progress == true{
                        DispatchQueue.main.async {
                            self.ChatData[index] = item
                        }
                        break
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.ChatData.insert(item, at: 0)
                }
            }
        case .file:
            guard let key = item.content?.key, let bucket = item.content?.bucket else {
                print("❌ Error  Server 👀 Bucket Key Missing")
                return
            }
            let fileTuple = determineFileType(from: key, bucket: bucket)
            let file = returnfileArray(image: fileTuple.imageArray)
            let item = textMessageItem(type: .file, time: time.chatTime, date: time.chatDate, amI: returnItemSide(type: item.msg_type),file:file.file[0] ,unix: 0,timeStemp: item.timestamp,show: item.on)
            DispatchQueue.main.async{
                self.ChatData.insert(item, at: 0)
            }
        case .notice:
            print("Photo")
        case .share:
            if let unixTime = item.block_data?.unixtime {
                let item = textMessageItem(type: .share, messege: item.content?.message, time: time.chatTime, date: time.chatDate, amI: .other, unix: unixTime, timeStemp: item.timestamp,status: item.hospital_data?.status,hash: item.block_data?.hash)
                DispatchQueue.main.async{
                    self.ChatData.insert(item, at: 0)
                }
            }
        case .edit:
            if let unixTime = item.block_data?.unixtime {
                let item = textMessageItem(type: .edit, messege: item.content?.message, time: time.chatTime, date: time.chatDate, amI: .other, unix: unixTime, timeStemp: item.timestamp,status: item.hospital_data?.status,hash: item.block_data?.hash)
                DispatchQueue.main.async{
                    self.ChatData.insert(item, at: 0)
                }
            }
        case .unowned:
            print("Photo")
        case .move:
            let item = textMessageItem(type: .move, messege: item.content?.message, time: time.chatTime, date: time.chatDate, amI: .other, unix: 0, timeStemp: item.timestamp)
            DispatchQueue.main.async{
                self.ChatData.insert(item, at: 0)
            }
        case .save:
            print("✅ Save Check")
            if let unixTime = item.block_data?.unixtime {
                let item = textMessageItem(type: .save, messege: item.content?.message, time: time.chatTime, date: time.chatDate, amI: .other, unix: unixTime, timeStemp: item.timestamp,status: item.hospital_data?.status,hash: item.block_data?.hash)
                DispatchQueue.main.async{
                    self.ChatData.insert(item, at: 0)
                }
            }
        }
    }
    
    //    날짜뷰
    private func chatDateViewItem(ChatPreData: [ChatHandlerDataModel.ChatMessegeItem],date: String)->(ChatHandlerDataModel.ChatMessegeItem?) {
        if ChatPreData.isEmpty{
            let item = ChatHandlerDataModel.ChatMessegeItem(type: .text, ReadCount: false, time: "", amI: .sepDate, chatDate: date, showETC: false, progress: false,unixTime: 0)
            return item
        }else{
            for index in ChatPreData.indices.reversed() {
                if ChatPreData[index].progress == false{
                    if ChatPreData[index].chatDate != date{
                        let item = ChatHandlerDataModel.ChatMessegeItem(type: .text, ReadCount: false, time: "", amI: .sepDate, chatDate: date, showETC: false, progress: false,unixTime: 0)
                        return item
                    }else{
                        return nil
                    }
                }
            }
            return nil
        }
    }
    // 소켓 연결상태에서 날짜뷰 추가.
    func dateViewAdd(ChatPreData: [ChatHandlerDataModel.ChatMessegeItem],date: String)->(error:Bool, item: ChatHandlerDataModel.ChatMessegeItem?) {
        if ChatPreData.isEmpty{
            let item = ChatHandlerDataModel.ChatMessegeItem(type: .text, ReadCount: false, time: "", amI: .sepDate, chatDate: date, showETC: false, progress: false,unixTime: 0)
            return (false, item)
        }else{
            for index in ChatPreData.indices {
                if ChatPreData[index].progress == false{
                    if ChatPreData[index].chatDate != date{
                        let item = ChatHandlerDataModel.ChatMessegeItem(type: .text, ReadCount: false, time: "", amI: .sepDate, chatDate: date, showETC: false, progress: false, unixTime:  0)
                        return (false, item)
                    }else{
                        return (true, nil)
                    }
                }
            }
            return (true, nil)
        }
    }
    
    
    
    
    private func MessegeTimeControl(reversed: Bool,ChatPreData: [ChatHandlerDataModel.ChatMessegeItem], msg_type: String, time: String, date: String)->(update: Bool,amI: ChatHandlerDataModel.ChatMessegeItem.AmI?) {
        guard var lastItem = ChatPreData.last else {
            print("LastItem equese")
            return (false,nil)
        }
        let indices = reversed ? Array(ChatPreData.indices.reversed()) : Array(ChatPreData.indices)
        for index in indices {
            if ChatPreData[index].progress == false{
                lastItem = ChatPreData[index]
                break
            }
        }
        //    마지막 채팅의 발신자가 누구인지
        let LastUser = lastItem.amI
        //    시간이 이전 것과 같은 지
        let isSameTime = lastItem.time == time
        //  메시지보낸사람이 나인지
        let isUserMessage = msg_type == "3"
        // type 할당
        let amI: ChatHandlerDataModel.ChatMessegeItem.AmI = isUserMessage ? .user : .other
        //    이전 체팅과 amI 가 같은지
        let isSame = isSameTime ? amI == LastUser : false
        
        return (isSame,amI)
    }
    private func HttpMessageType(contentType: String, fileArray:[String], bucket:[String],msg_type: Any? = nil) -> ChatHandlerDataModel.ChatMessegeItem.MessageTypes {
        print("messageType \(contentType)")
        print("messageType\(String(describing: msg_type))")
        switch contentType {
        case "text":
            print(msg_type as Any)
            if msg_type == nil{
                return .text
            }
            return testMessgaeType(msg_type:msg_type).msg_type
        default:
            // fileType 함수 호출 전에 두 매개변수 모두 nil이 아닌지 확인
            if fileArray[0] != "N/A" {
                //                return .photo
                return HttpDetermineFileType(from: fileArray, bucket: bucket).fileType
            } else {
                return .unowned  // 파일 유형 정보가 없는 경우 적절하게 처리
            }
        }
    }
    func messageType(contentType: String, fileArray: OpenChatRoomDataModel.KeyType? = nil, bucket: OpenChatRoomDataModel.KeyType? = nil,msg_type: Any? = nil) -> ChatHandlerDataModel.ChatMessegeItem.MessageTypes {
        print("messageType \(contentType)")
        print("messageType \(String(describing: msg_type))")
        switch contentType {
        case "text":
            print(msg_type as Any)
            if msg_type == nil{
                return .text
            }
            return testMessgaeType(msg_type:msg_type).msg_type
        default:
            // fileType 함수 호출 전에 두 매개변수 모두 nil이 아닌지 확인
            if let keyType = fileArray, let bucketType = bucket {
                return determineFileType(from: keyType, bucket: bucketType).fileType
            } else {
                return .unowned  // 파일 유형 정보가 없는 경우 적절하게 처리
            }
        }
    }
    private func testMessgaeType(msg_type: Any?) -> (success: Bool, msg_type: ChatHandlerDataModel.ChatMessegeItem.MessageTypes){
        if let stringType = msg_type as? String{
            if stringType == "9"{
                return (true, .notice)
            }else if stringType == "7"{
                return (true, .edit)
            }else if stringType == "8"{
                return (true, .share)
            }else if stringType == "5"{
                return (true, .move)
            }else if stringType == "6" {
                return (true, .save)
            }
        }else if let intType = msg_type as? Int{
            if intType == 9 {
                return (true, .notice)
            }else if intType == 7{
                return (true, .edit)
            }else if intType == 8{
                return (true, .share)
            }else if intType == 5{
                return (true, .move)
            }else if intType == 6{
                return (true, .save)
            }
        }
        return (false, .text)
    }
    func returnfileArrayHTTP(image: [(String,String)]) -> (success: Bool, file: [String]){
        var Array: [String] = []
        for index in 0 ..< image.count{
            Array.append("https://\(image[index].1).s3.ap-northeast-2.amazonaws.com/\(image[index].0)")
        }
        if !Array.isEmpty{
            return (false, Array)
        }
        return (true, Array)
    }
    func returnURIArray(image: [(String,String)]) -> (success: Bool, imgArray: [URL]){
        var Array: [String] = []
        print("이미지 배열 출력한다.")
        for index in 0 ..< image.count{
            Array.append("https://\(image[index].1).s3.ap-northeast-2.amazonaws.com/\(image[index].0)")
        }
        print("여기까지")
        var ImageArray: [URL] = []
        ImageArray = Array.compactMap { urlString in
            urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed).flatMap { URL(string: $0) }
        }
        if !ImageArray.isEmpty{
            return (false, ImageArray)
        }
        return (true, ImageArray)
    }
    func returnfileArray(image: [(String,String)]) -> (success: Bool, file: [String]){
        var Array: [String] = []
        print("이미지 배열 출력한다.")
        for index in 0 ..< image.count{
            print("이미지 이름 : \(image[index].0)")
            print("이미지 버켓 : \(image[index].1)")
            Array.append("https://\(image[index].1).s3.ap-northeast-2.amazonaws.com/\(image[index].0)")
            print("https://\(image[index].1).s3.ap-northeast-2.amazonaws.com/\(image[index].0)")
        }
        print("여기까지")
        if !Array.isEmpty{
            return (false, Array)
        }
        return (true, Array)
    }
    func determineFileType(from keyType: OpenChatRoomDataModel.KeyType, bucket: OpenChatRoomDataModel.KeyType) -> (fileType: ChatHandlerDataModel.ChatMessegeItem.MessageTypes, imageArray: [(String, String)]) {
        print("테스트 determineFileType 호출")
        var imageArray: [String] = []
        var bucketArray: [String] = []
        // Key 처리
        switch keyType {
        case .string(let fileString):
            print("테스트 Key String: \(fileString)")
            imageArray = returnStringToArray(jsonString: fileString).arr
        case .array(let fileArray):
            print("테스트 Key Array: \(fileArray)")
            imageArray = fileArray
        }
        
        // Bucket 처리
        switch bucket {
        case .string(let bucketString):
            print("테스트 Bucket String: \(bucketString)")
            bucketArray = returnStringToArray(jsonString: bucketString).arr
        case .array(let bucketArrayValues):
            print("테스트 Bucket Array: \(bucketArrayValues)")
            bucketArray = bucketArrayValues
        }
        
        // 이미지와 버킷 배열의 결합
        if imageArray.isEmpty || bucketArray.isEmpty || imageArray.count != bucketArray.count {
            return (.unowned, [])
        }
        
        let combinedArray = zip(imageArray, bucketArray).map { ($0, $1) }
        let fileType = fileType(for: imageArray.first ?? "") // 첫 번째 파일 경로로 파일 유형 결정
        print("✅  타입 반환 반환 \(fileType)")
        print("✅  conbineArray 반환 \(combinedArray[0])")
        return (fileType, combinedArray)
    }
    /// 주어진 이미지 정보(이름과 버킷)를 사용하여 AWS S3 URL 배열을 생성하고 반환
    /// - Parameter image: 튜플 배열로, 각 튜플은 (이미지 이름, 버킷 이름)으로 구성
    /// - Returns: 성공 여부와 생성된 URL 배열을 반환. URL 배열이 비어있지 않으면 성공(false), 비어있으면 실패(true)로 간주
    private func HttpDetermineFileType(from keyType: [String], bucket: [String]) -> (fileType: ChatHandlerDataModel.ChatMessegeItem.MessageTypes, fileArray: [(String, String)]) {
        print("👀 determineFileType 호출")
        let imageArray: [String] = keyType
        let bucketArray: [String] = bucket
        // 이미지와 버킷 배열의 결합
        if imageArray.isEmpty || bucketArray.isEmpty || imageArray.count != bucketArray.count {
            return (.unowned, [])
        }
        
        let combinedArray = zip(imageArray, bucketArray).map { ($0, $1) }
        let fileType = fileType(for: imageArray.first ?? "") // 첫 번째 파일 경로로 파일 유형 결정
        return (fileType, combinedArray)
    }
    
    /// 주어진 파일 키와 버킷 정보를 사용하여 파일 유형을 결정 이미지와 버킷 정보를 결합하여 반환
    /// - Parameters:
    ///   - keyType: 파일 키의 배
    ///   - bucket: 버킷 이름의 배열
    /// - Returns: 결정된 파일 유형과 결합된 이미지 및 버킷 정보의 배열을 반환
    func HttPreturnURIArray(image: [(String,String)]) -> (success: Bool, imgArray: [URL]){
        var Array: [String] = []
        for index in 0 ..< image.count{
            Array.append("https://\(image[index].1).s3.ap-northeast-2.amazonaws.com/\(image[index].0)")
        }
        var ImageArray: [URL] = []
        ImageArray = Array.compactMap { urlString in
            urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed).flatMap { URL(string: $0) }
        }
        if !ImageArray.isEmpty{
            return (false, ImageArray)
        }
        return (true, ImageArray)
    }
    
    
    
    private func fileType(for filePath: String) -> ChatHandlerDataModel.ChatMessegeItem.MessageTypes {
        if filePath.contains("png") || filePath.contains("jpg") {
            return .photo
        } else {
            return .file
        }
    }
    
    
    func textMessageItem(type: ChatHandlerDataModel.ChatMessegeItem.MessageTypes,messege: String? = nil, time: String, date: String,amI: ChatHandlerDataModel.ChatMessegeItem.AmI,imgAr: [URL]? = nil,file:String? = nil,unix: Int,timeStemp: String? = nil,status: Int? = nil,progress: Bool? = false, show: Bool? = nil,hash: String? = nil)->(ChatHandlerDataModel.ChatMessegeItem) {
        let newItem = ChatHandlerDataModel.ChatMessegeItem(
            type: type,
            messege: messege,
            ReadCount: show ?? returnReadCheck(hospitalTime: hospitalTime, patientTime: timeStemp),
            FileURI: file,
            time: time,
            amI: amI,
            chatDate: date,
            showETC: true,
            ImageArray: imgAr,
            progress: progress ?? false,
            unixTime: unix,
            hash: hash,
            status: status,
            timeStemp: timeStemp
        )
        return (newItem)
    }
    
    
    private func returnItemSide(type: Int) -> ChatHandlerDataModel.ChatMessegeItem.AmI{
        if type == 3{
            return .user
        }
        return .other
    }
    // 스트링 데이터 Json으로 변경
    func UpdateChatList(ReciveText: String) -> (err:Bool, jsonData:Data?){
        guard let jsonData = ReciveText.data(using: .utf8) else{
            print("❌ Error to jsonInvalid")
            return (true,nil)
        }
        return (false,jsonData)
    }
    func setAllRead() {
        // 글로벌 큐에서 병렬로 작업 수행
        DispatchQueue.global(qos: .userInitiated).async {
            // 변경할 인덱스를 수집
            var indicesToUpdate: [Int] = []
            for index in self.ChatData.indices {
                if self.ChatData[index].amI == .user && self.ChatData[index].ReadCount == false {
                    indicesToUpdate.append(index)
                }
            }
            // 메인 스레드에서 UI 업데이트
            DispatchQueue.main.async {
                for index in indicesToUpdate {
                    self.ChatData[index].ReadCount = true
                }
            }
        }
    }
    func handleFileImport(result: Result<URL, Error>) {
        switch result {
        case .success(let file):
            if file.startAccessingSecurityScopedResource() {
                defer { file.stopAccessingSecurityScopedResource() }
                do {
                    let fileData = try Data(contentsOf: file)
                    let fileExtension = file.pathExtension
                    let fileNameBase = file.deletingPathExtension().lastPathComponent
                    let isSpecialFile = fileNameBase == "1" || fileNameBase == "2"
                    let fileName = isSpecialFile ? "\(fileNameBase)\(fileExtension)" : fileNameBase
                    let extensions = [".\(fileExtension)"]
                    let fileNames = [fileName]
                    Task {
                        let check = await sendMessage(msg_type: 3, from: account, to: String(hospitalId), content_type: "file",file_cnt: 1,file_ext: extensions,file_name: fileNames)
                        if check{
                            SendFileData(data: fileData)
                            DispatchQueue.main.async {
                                self.appManager.showToast(message: "파일을 성공적으로 전송 했습니다.")
                            }
                            
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.appManager.showToast(message: "데이터 변환에 실패하셨습니다.")
                    }
                    print("❌ File 데이터 변환 실패: \(error)")
                }
            } else {
                DispatchQueue.main.async {
                    self.appManager.showToast(message: "파일 접근 권한이 없습니다.")
                }
            }
        case .failure(let error):
            print("❌ File Get error \(error.localizedDescription)")
        }
    }
    func sendImages (extend: [String], name:[String],imagesCount: Int,SendingImagesByte:[Data]) async -> Bool{
        let check = await sendMessage(msg_type: 3,from: account, to: String(hospitalId), content_type: "file",file_cnt: imagesCount,file_ext:extend,file_name:name)
        if check{
            for index in 0..<imagesCount{
                SendFileData(data: SendingImagesByte[index])
            }
            return true
        }else{
            await appManager.showToast(message: "이미지 전송에 실패했습니다.")
            return false
        }
    }
}
