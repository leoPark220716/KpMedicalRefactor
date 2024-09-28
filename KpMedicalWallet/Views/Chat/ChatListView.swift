//
//  ChatListView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var appManager: NavigationRouter
    var body: some View {
        VStack{
            if appManager.chatItem.isEmpty{
                SomethingEmpty(text: "상담 내역이 존재하지 않습니다.")
            }else if !appManager.chatItem.isEmpty{
                List{
                    ForEach(appManager.chatItem.indices, id: \.self){ index in
                        Button{
                            appManager.push(to:
                                    .userPage(item: UserPage(page: .advice),
                                              appManager: appManager
                                              ,hospitalId:appManager.chatItem[index].hospital_id,
                                              hospitalName: appManager.chatItem[index].hospital_name,
                                              hospital_icon: appManager.chatItem[index].icon))
                        }label: {
                            ChatListItem(item: $appManager.chatItem[index])
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                }
            }
            
        }.navigationTitle("")
    }
}

#Preview {
    @Previewable @StateObject var appManager = NavigationRouter()
    ChatListView()
        .environmentObject(appManager)
}
struct ChatListItem: View {
    @Binding var item: ChatHTTPresponseStruct.ChatListArray
    
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: item.icon)){ image in
                image.resizable() // 이미지를 resizable로 만듭니다.
                    .aspectRatio(contentMode: .fill) // 이미지의 종횡비를 유지하면서 프레임에 맞게 조정합니다.
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            } placeholder: {
                ProgressView()
            }
            VStack(alignment:.leading){
                HStack{
                    Text(item.hospital_name)
                        .bold()
                        .font(.system(size: 17))
                    if item.unread_cnt != 0{
                        Text("\(item.unread_cnt)")
                            .font(.caption2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .background(Color.red)
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 2)
                Text(item.last_message.message)
                    .font(.callout)
                    .lineLimit(2)
            }
            .padding(.leading,3)
            Spacer()
            Text(returnyyyy_MM_dd(time: item.last_message.timestamp).chatTime)
                .font(.system(size: 13))
                .foregroundStyle(.gray)
        }
    }
    private func returnyyyy_MM_dd (time: String) -> (success: Bool, chatTime: String){
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
                print("날짜 변환 실패")
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
    private func isToday(dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 한국 시간대 설정

        // 입력된 날짜를 Date 객체로 변환
        guard let date = dateFormatter.date(from: dateString) else {
            print("??")
            return false
        }

        // 현재 한국 시간
        let now = Date()
        let calendar = Calendar.current
        _ = TimeZone(identifier: "Asia/Seoul")!
        let today = calendar.startOfDay(for: now)
        let inputDate = calendar.startOfDay(for: date)
        print(today)
        print(inputDate)
        return today == inputDate
    }
}

