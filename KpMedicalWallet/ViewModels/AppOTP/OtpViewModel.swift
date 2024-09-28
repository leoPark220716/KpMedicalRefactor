//
//  OtpViewModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//

import Foundation

class OtpViewModel: ObservableObject{
    var appManager: NavigationRouter?
    var socket: ChatHandler?
    @Published var password: String = ""
    var checkPassword: String = ""
    @Published var otpStatus: Bool = false
    @Published var Dismiss: Bool = false
    @Published var matchCheck: Bool = true
    var viewCase: routeType
    @Published var rows = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["Re", "0", "<"]
    ]
    @Published var guaidLineString: String = ""
    
    init(socket: ChatHandler? = nil,viewCase: routeType){
        self.socket = socket
        self.viewCase = viewCase
    }
    @MainActor
    func reArrangeNumbers() {
        var numbers = (1...9).map { String($0) } + ["0"] // 숫자 문자열 배열 생성
        numbers.shuffle() // 배열을 랜덤하게 섞는다
        
        // 랜덤하게 섞인 숫자들로 rows 배열 업데이트
        rows[0] = Array(numbers[0..<3])
        rows[1] = Array(numbers[3..<6])
        rows[2] = Array(numbers[6..<9])
        rows[3][0] = "Re"
        rows[3][1] = numbers[9]
        rows[3][2] = "<"
    }
    @MainActor
    func ButtonAction(_ item: String){
        if item == "<"{
            password = String(password.dropLast())
        }else if item == "Re"{
            reArrangeNumbers()
        }else if password.count < 6{
            password.append(item)
            if password.count == 6 && otpStatus{
                checkOtp()
            }else if password.count == 6 && checkPassword == ""{
                checkPassword = password
                password = ""
                reArrangeNumbers()
                guaidLineString = "인증번호를 한번더 입력해주세요."
            }else if password.count == 6 && checkPassword == password{
                saveOtpStatus()
            }else if password.count == 6 && checkPassword != password{
                matchCheck = false
                password = ""
                reArrangeNumbers()
            }
        }
    }
    func setOtpStatus(appManager: NavigationRouter){
        print("Call setOtpStatus")
        Task{
            self.appManager = appManager
            let auth = AuthData()
            let state = auth.checkPasswordExists(account: appManager.GetUserAccountString().account)
            await MainActor.run {
                otpStatus = state
                print(state)
                if state {
                    guaidLineString = "인증번호를 입력해주세요."
                }else{
                    guaidLineString = "인증번호를 생성해주세요."
                }
            }
        }
    }
    func saveOtpStatus(){
        print("Call Save")
        guard let account = appManager?.GetUserAccountString() else{
            return
        }
        Task{
            let auth = AuthData()
            let state = auth.savePassword(password: password,account: account.account)
            await MainActor.run {
                Dismiss = state
            }
        }
    }
    func checkOtp(){
        guard let account = appManager?.GetUserAccountString() else{
            return
        }
        Task{
            let auth = AuthData()
            let state = auth.verifyPassword(password: password,account: account.account)
            if state{
                DispatchQueue.main.async{
                    self.Dismiss = state
                }
                await routeNextView()
            }else{
                DispatchQueue.main.async{
                    self.matchCheck = false
                    self.password = ""
                }
                await reArrangeNumbers()
            }
            
        }
    }
    @MainActor
    func createOtpReset(){
        guaidLineString = "인증번호를 생성해주세요."
        checkPassword = ""
        password = ""
        reArrangeNumbers()
    }
    func routeNextView() async {
        
        switch viewCase {
        case .edit:
            print("")
        case .save:
            guard let appManager = appManager, let socket = socket else{
                return
            }
            let walletContract = KPHWalletContractManager(appManager: appManager,socket: socket)
            walletContract.SmartContractConfirm(hospitalId: UInt32(socket.hospitalId), date: socket.timeUUID,stempUUID: socket.stempUUID)
        case .share:
            print("")
        case .walletView:
            await MainActor.run {
                appManager?.push(to: .userPage(item: UserPage(page: .walletMain)))
            }
        }
    }
    enum routeType{
        case edit
        case save
        case share
        case walletView
    }
}
