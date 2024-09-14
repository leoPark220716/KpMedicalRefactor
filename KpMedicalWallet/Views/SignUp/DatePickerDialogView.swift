//
//  DatePickerDialogView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/13/24.
//

import SwiftUI

struct DatePickerDialogView: View {
    @Binding var birthDate: Date
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            DatePicker("Birth Date", selection: $birthDate,in:  ...Date(), displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding()
                .environment(\.locale, Locale(identifier: "ko_KR"))
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
                    .font(.headline)
            }
            .padding()
        }
    }
}


