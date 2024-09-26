//
//  TimeHandler.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import Foundation


class TimeHandler:SocketHandler {
    func timeChangeToChatTime (time: String?) -> (success: Bool, chatTime: String, chatDate: String){
        guard let time = time else {
            return (false,"","")
        }
        // ISO 8601 형식을 파싱하기 위한 DateFormatter 설정
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        // 문자열을 Date 객체로 변환
        if let date = isoFormatter.date(from: time) {
            // 변환된 Date 객체를 원하는 형식으로 다시 포맷
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "a hh:mm" // "오후 05:31" 형식
            outputFormatter.amSymbol = "오전"
            outputFormatter.pmSymbol = "오후"
            // 최종 결과 문자열 출력
            let timeDateStr = outputFormatter.string(from: date)
            outputFormatter.dateFormat = "yyyy-MM-dd"
            let dateStr = outputFormatter.string(from: date)
            return (true,timeDateStr,dateStr)
        } else {
            return (false,"","")
        }
    }
    func returnyyyy_MM_dd (time: String) -> (success: Bool, chatTime: String){
        // ISO 8601 형식을 파싱하기 위한 DateFormatter 설정
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        // 문자열을 Date 객체로 변환
        if isToday(dateString: time){
            if let date = isoFormatter.date(from: time) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "a hh:mm" // "오후 05:31" 형식
                outputFormatter.amSymbol = "오전"
                outputFormatter.pmSymbol = "오후"
                let timeDateStr = outputFormatter.string(from: date)
                return (true,timeDateStr)
            }else{
                return (false,"")
            }
        }else{
            if let date = isoFormatter.date(from: time) {
                // 변환된 Date 객체를 원하는 형식으로 다시 포맷
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "MM월 dd일"
                // 최종 결과 문자열 출력
                let formattedDateStr = outputFormatter.string(from: date)
                print(formattedDateStr)
                return (true,formattedDateStr)
            } else {
                print("날짜 변환 실패")
                return (false,"")
            }
        }
    }
    func returnReadCheck(hospitalTime: String? = "1000-01-01T01:01:01.000", patientTime: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        guard let Hdate = dateFormatter.date(from: hospitalTime!) else {
            return false
        }
        guard let Pdate = dateFormatter.date(from: patientTime) else {
            return false
        }
        return Hdate >= Pdate
    }
    private func isToday(dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 한국 시간대 설정

        // 입력된 날짜를 Date 객체로 변환
        guard let date = dateFormatter.date(from: dateString) else {
            return false
        }

        // 현재 한국 시간
        let now = Date()
        let calendar = Calendar.current
        _ = TimeZone(identifier: "Asia/Seoul")!
        let today = calendar.startOfDay(for: now)
        let inputDate = calendar.startOfDay(for: date)
        return today == inputDate
    }
    
    
}
