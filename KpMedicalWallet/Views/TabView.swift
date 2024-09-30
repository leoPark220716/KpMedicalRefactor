//
//  TabView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import SwiftUI

struct DefaultTabView: View {
    @EnvironmentObject private var appManager: NavigationRouter
    var body: some View {
        TabView(selection: $appManager.TabViewSelection){
            HomeView(appManager: appManager)
                .tabItem {
                    Label("메인",systemImage:"house.circle.fill")
                }
                .tag(TabViewTabs .home)
            ChatListView()
                .tabItem {
                    Label("상담",systemImage: "message.circle.fill")
                }
                .tag(TabViewTabs .chat)
            MyHospitalView()
                .tabItem {
                    Label("내병원",systemImage:"stethoscope.circle.fill")
                }
                .tag(TabViewTabs .hospital)
            AccountView()
                .tabItem {
                    Label("계정",systemImage:"person.crop.circle")
                }
                .tag(TabViewTabs .account)

        }
        .navigationTitle(appManager.TitleString)
        .navigationBarTitleDisplayMode(.inline)
        .padding(.bottom)
        .onAppear{
            appManager.GetChatList()
        }
    }
}

struct DefaultTabView_Priview: PreviewProvider{
    static var previews: some View {
        
        @StateObject var router = NavigationRouter()
        
        DefaultTabView()
            .environmentObject(router)
    }
}
