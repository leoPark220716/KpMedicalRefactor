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
            HomeView()
                .tabItem {
                    Label("메인",systemImage:"house.circle.fill")
                }
                .tag(TabViewTabs .home)
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
        .navigationTitle("님 안녕하세요")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.bottom)
    }
}

struct DefaultTabView_Priview: PreviewProvider{
    static var previews: some View {
        
        @StateObject var router = NavigationRouter()
        
        DefaultTabView()
            .environmentObject(router)
    }
}
