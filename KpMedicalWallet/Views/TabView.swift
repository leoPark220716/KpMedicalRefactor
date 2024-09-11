//
//  TabView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import SwiftUI

struct DefaultTabView: View {
    
    
    
    var body: some View {
        VStack{
            Spacer()
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .onTapGesture {
                    let AuteData = AuthData()
                    AuteData.deleteAllKeyChainItems()
                }
            Spacer()
            Text("Check")
                .onTapGesture {
//                    print(viewModel.appManager.fcmToken)
                }
            Spacer()
        }
    }
}

//#Preview {
//    DefaultTabView()
//}
