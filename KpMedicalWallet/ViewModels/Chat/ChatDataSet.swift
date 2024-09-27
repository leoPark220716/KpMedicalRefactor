//
//  ChatDataSet.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/27/24.
//

import Foundation
import PhotosUI
import SwiftUI
class ChatDataSet: TimeHandler{
    @Published var ChatData: [ChatHandlerDataModel.ChatMessegeItem] = []
    var HaveToCreateRoom: Bool = false
    var chatId: Int = 0
    @Published var HospitalImage: String = ""
    @Published var SendingImages: [UIImage] = []
    @Published var SendingImagesByte: [Data] = []
    @Published var selectedItems: [PhotosPickerItem] = []
    var hospitalTime: String = ""
}
