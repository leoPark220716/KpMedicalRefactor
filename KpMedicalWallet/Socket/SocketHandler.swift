//
//  SocketHandler.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import Foundation
import Combine
class SocketHandler: SocketHttpRequest{
    var onMessageReceived: ((String) -> Void)?
    
    // 소켓 객체 연결
    func Connect() async {
        print("👀WebSocket connect try")
        do{
            let url = try returnSocketURL()
            print("👀WebSocket connect try URL : \(url)")
            let request = URLRequest(url: url)
            webSocketTask = URLSession.shared.webSocketTask(with: request)
            webSocketTask?.resume()
            print("👀WebSocket connected")
        }catch{
            await appManager.displayError(ServiceError: error)
        }
    }
    // 소켓 객체 연결 해제
    func disconnect() {
        webSocketTask?.cancel()
        print("👀WebSocket connection closed and timer invalidated.")
    }
    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else {
                return // self가 nil이면 함수 종료
            }
            switch result {
            case .failure(let error):
                if isActiveOnChatView == true {
                    print("❌Receive error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.appManager.displayError(ServiceError: .socketError("소켓연결에 실패하셨습니다. 다시 시도해주세요."))
                    }
                }
            case .success(let message):
                switch message {
                case .string(let text):
                    print(text)
                    print("Received string: \(text)")
                    self.onMessageReceived?(text) // 메시지 수신 시 클로저 호출
                    
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    print("Unknown message type")
                }
                // 연결이 활성화되어 있으므로 계속해서 메시지 수신 대기
                self.receiveMessage()
            }
        }
    }
    
}
