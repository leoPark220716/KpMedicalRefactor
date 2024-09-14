//
//  SignupFinalView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/13/24.
//

import SwiftUI

struct SignupFinalView: View {
    @EnvironmentObject var router: NavigationRouter
    @State var justTrue: Bool = true
    let pageStatus: Bool
    let name: String
    var body: some View {
        VStack{
            Spacer()
            if pageStatus{
                SignupSuccessView(name: name)
            }else{
                Signup202View(name: name)
            }
            Spacer()
            Button {
                router.goToRootView()
            } label: {
                Text(PlistManager.shared.string(forKey: "signup_final_go_root"))
                    .modifier(ActiveUnActiveButton(active: $justTrue))
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct Signup202View: View {
    let name: String
    var body: some View {
        VStack{
            Text("회원가입에 실패하셨습니다.")
                .font(.title)
                .bold()
                .padding(.leading)
            HStack{
                VStack(alignment: .leading){
                    Text("죄송합니다. \(name) 님")
                        .bold()
                        .padding(.horizontal,30)
                        .padding([.vertical])
                    Text("죄송합니다 고객님 고객님이 요청하신 아이디가 존재합니다.")
                        .padding(.horizontal,30)
                        .font(.system(size: 14))
                        .padding(.bottom)
                        .lineLimit(3)
                    
                }
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color.red)
                    .font(.system(size: 30))
                    .imageScale(.large)
                    .padding()
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()
        }
    }
}
struct SignupSuccessView: View {
    let name: String
    var body: some View {
        VStack{
            Text("회원가입에 성공하셨습니다.")
                .font(.title)
                .bold()
                .padding(.leading)
            HStack{
                VStack(alignment: .leading){
                    Text("환영합니다 \(name) 님")
                        .bold()
                        .padding(.horizontal,30)
                        .padding([.vertical])
                    Text("로그인을 진행한 후 KpMedical의 다양한 서비스를 이용하실 수 있습니다.")
                        .padding(.horizontal,30)
                        .font(.system(size: 14))
                        .padding(.bottom)
                        .lineLimit(3)
                    
                }
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color("AccentColor"))
                    .font(.system(size: 30))
                    .imageScale(.large)
                    .padding()
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()
        }
    }
}


struct SignupFinalView_Priview: PreviewProvider{
    static var previews: some View {
        
        @StateObject var router = NavigationRouter()
        
        SignupFinalView(pageStatus: true, name: "박준성")
            .environmentObject(router)
    }
}
