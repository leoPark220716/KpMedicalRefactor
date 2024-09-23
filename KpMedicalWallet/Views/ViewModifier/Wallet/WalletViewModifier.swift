//
//  WalletViewModifier.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//

import SwiftUI

struct WalletViewEmptyWalletTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .bold()
            .font(.title3)
    }
}
struct WalletViewEmptyWalletGuaidLineModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.gray)
            .bold()
            .padding()
            .padding(.top)
    }
}
struct WalletViewCreateWalletButton: ViewModifier{
    func body(content: Content) -> some View {
        content
            .bold()
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundStyle(Color.white)
            .background(Color("AccentColor"))
            .cornerRadius(10)
            .padding(.top)
    }
}
struct WalletViewFindWalletButton: ViewModifier{
    func body(content: Content) -> some View {
        content
            .bold()
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(Color.blue)
            .background(Color.white)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.blue, lineWidth: 1)
            )
            .padding(.top)
    }
}
struct WalletViewCardModifier: ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding()
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding()
    }
}

struct WalletViewAddress: ViewModifier{
    func body(content: Content) -> some View {
        content
            .lineLimit(1)
            .truncationMode(.middle)
    }
}
struct WalletViewCopyTextImage: ViewModifier{
    func body(content: Content) -> some View {
        content
            .foregroundColor(.blue)
            .font(.system(size: 15))
    }
}
struct WalletViewAddressSection: ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
struct WalletViewMnemonicsText: ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 14))
            .frame(width: 100, height: 40)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}
struct WalletViewMnemonicsGuaidLine: ViewModifier{
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.gray)
            .bold()
            .padding()
            .padding(.top)
    }
}
struct WalletViewMnemonicsCreateButton:ViewModifier{
    func body(content: Content) -> some View {
        content
            .bold()
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundStyle(Color.white)
            .background(Color("AccentColor"))
            .cornerRadius(10)
            .padding(.top)
    }
}
