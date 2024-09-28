//
//  ChatDataSet.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/27/24.
//

import Foundation
import PhotosUI
import SwiftUI
import BigInt
class ChatDataSet: TimeHandler{
    @Published var ChatData: [ChatHandlerDataModel.ChatMessegeItem] = []
    var HaveToCreateRoom: Bool = false
    var chatId: Int = 0
    @Published var HospitalImage: String = ""
    @Published var SendingImages: [UIImage] = []
    @Published var SendingImagesByte: [Data] = []
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var otp: Bool = false
    var otpType: OtpViewModel.routeType = .save
    var hospitalTime: String = ""
    var lastChatTime: String?
    // 스컨 데이터 저장요청 파라미터
    var timeUUID: BigUInt = 0
    var stempUUID: String = ""
    override init(hospitalId: Int, account: String, token: String, fcmToken: String, appManager: NavigationRouter, hospital_icon: String) {
        super.init(hospitalId: hospitalId, account: account, token: token, fcmToken: fcmToken, appManager: appManager, hospital_icon: hospital_icon)
        DispatchQueue.main.async {
            self.HospitalImage = hospital_icon
        }
    }
    func setSaveContractData(stemp: String, timeUUID: Int){
        self.timeUUID = BigUInt(timeUUID)
        self.stempUUID = stemp
    }
}