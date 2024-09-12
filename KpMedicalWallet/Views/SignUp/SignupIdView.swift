//
//  SignUpView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import SwiftUI

struct SignupIdView: View {
    @State private var firstPart: String = ""
    @State private var secondPart: String = ""
    @State private var id: String = ""
    var body: some View {
        VStack {
            HStack{
                Text(PlistManager.shared.string(forKey: "login_hint"))
                    .padding(.horizontal)
                Spacer()
            }
            TextField(PlistManager.shared.string(forKey: "login_hint"), text: $id)
                .modifier(IDFildModifier())
                .padding(.horizontal)
            
        }
        
    }
}

#Preview {
    SignupIdView()
}
