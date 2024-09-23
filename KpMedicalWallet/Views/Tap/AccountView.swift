//
//  AccountView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/14/24.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var appManager: NavigationRouter
    @State var otp: Bool = false
    var body: some View {
        VStack {
            // 사용자 정보
            HStack {
                VStack(alignment: .leading){
                    Text(appManager.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(appManager.dob)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .padding()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .padding([.leading, .trailing])
            // 나의 프로젝트
            VStack(alignment: .leading) {
                Text("내 병원 관리")
                    .font(.headline)
                    .padding([.top])
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: 100)
                        .overlay(
                            HStack(spacing: 0) {
                                ProjectInfoView(title: "등록병원", count: "0개")
                                Divider()
                                ProjectInfoView(title: "예약현황", count: "0건")
                                Divider()
                                ProjectInfoView(title: "정보처리", count: "준비중")
                            }
                        )
                        .padding(.bottom)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    Spacer()
                }
                // 와디즈 계좌
                Button{
                    otp.toggle()
                }label: {
                    HStack {
                        Text("K&P 지갑")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                        Text("준비중")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white) // 배경색을 설정하여 테두리가 더 잘 보이게 함
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("AccentColor"), lineWidth: 1) // 테두리 설정
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .padding(.top)
                }
            }
            .padding([.leading, .trailing])
            // 메시지, 쿠폰, 포인트
            VStack {
                MenuRowView(title: "앱 알림설정", toggleKey: "counselingNotification")
                Button{
                    Task{
                        await appManager.logOut()
                    }
                } label: {
                    HStack {
                        Text("LogOut")
                            .foregroundStyle(Color.pink)
                            .font(.subheadline)
                            .bold()
                        Spacer()
                    }
                    .padding()
                    .background(Color.white) // 배경색을 설정하여 테두리가 더 잘 보이게 함
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .padding(.top)
                }
                
            }
            .padding([.leading, .trailing])
            .onAppear{
                
            }
            Spacer()
        }
        .sheet(isPresented: $otp){
            AppOtpView(viewCase: OtpViewModel.routeType.walletView)
        }
        .background(Color.gray.opacity(0.09).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    @Previewable @StateObject var appManager = NavigationRouter()
    AccountView()
        .environmentObject(appManager)
}
struct ProjectInfoView: View {
    let title: String
    let count: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom,4)
            Text(count)
                .font(.headline)
        }
        .frame(maxWidth: .infinity) // 추가: 각 요소를 균등하게 분배하기 위해 최대 너비를 사용
        .padding()
    }
}
struct MenuRowView: View {
    let title: String
    let toggleKey: String
    @State private var isToggled: Bool
    
    init(title: String, toggleKey: String) {
        self.title = title
        self.toggleKey = toggleKey
        self._isToggled = State(initialValue: UserDefaults.standard.bool(forKey: toggleKey, defaultValue: false))
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
            Spacer()
            Toggle("", isOn: $isToggled)
                .onChange(of: isToggled) {
                    UserDefaults.standard.setBool(value: isToggled, forKey: toggleKey)
                }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding([.top, .bottom], 5)
    }
}
extension UserDefaults {
    func setBool(value: Bool, forKey key: String) {
        self.set(value, forKey: key)
    }
    
    func bool(forKey key: String, defaultValue: Bool) -> Bool {
        return self.object(forKey: key) as? Bool ?? defaultValue
    }
}
