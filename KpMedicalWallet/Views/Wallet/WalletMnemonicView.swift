//
//  WalletMnemonicView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//

import SwiftUI

struct WalletMnemonicView: View {
    @EnvironmentObject var appManager: NavigationRouter
    @EnvironmentObject var walletModel: KPHWallet
    @State private var showAlert = false
    @State private var createMnemonics = false
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var body: some View {
        if !createMnemonics{
            VStack{
                VStack{
                    if walletModel.mnemonicArray.isEmpty{
                        Text( "니모닉을 생성해 주세요")
                            .modifier(WalletViewMnemonicsGuaidLine())
                    }else{
                        LazyVGrid(columns: columns){
                            ForEach(walletModel.mnemonicArray.indices, id: \.self){ value in
                                Text(walletModel.mnemonicArray[value])
                                    .modifier(WalletViewMnemonicsText())
                            }
                        }
                    }
                    Button{
                        if walletModel.mnemonicArray.isEmpty{
                            do{
                                try walletModel.generateMnmonics()
                            }catch{
                                appManager.displayError(ServiceError: .clientError(""))
                            }
                        }else{
                            UIPasteboard.general.string = walletModel.Mnemonicse
                            appManager.toast = normal_Toast(message: "클립보드에 복사되었습니다.")
                        }
                    }label: {
                        Text(!walletModel.mnemonicArray.isEmpty ? "Copy" : "니모닉 문구 생성")
                            .modifier(WalletViewMnemonicsCreateButton())
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray)
                )
                .padding()
                VStack{
                    HStack{
                        Text("Notice")
                            .font(.system(size: 20))
                            .bold()
                        Spacer()
                    }
                    .padding([.horizontal,.top])
                    ScrollView{
                        Text(PlistManager.shared.string(forKey: "mnemonic_create_guaidLine"))
                            .padding()
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray)
                )
                .padding()
                Spacer()
                Button {
                    if !walletModel.mnemonicArray.isEmpty{
                        self.showAlert = true
                    }
                } label: {
                    Text("지갑 생성")
                        .modifier(NotBindingActiveUnActiveButton(active: !walletModel.mnemonicArray.isEmpty))
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("지갑을 생성하시겠습니까?"),
                    message: Text("니모닉 문구는 한 번만 제공되며 다시 확인할 수 없습니다."),
                    primaryButton: .destructive(Text("확인")) {
                        createMnemonics = true
                        walletModel.OnTapCreateWalletButton(appManager: appManager)
                    },
                    secondaryButton: .cancel()
                )
            }
            .normalToastView(toast: $appManager.toast)
            .navigationTitle("니모닉 생성")
//            .navigationBarBackButtonHidden(isLoading ? true : false)
            .navigationBarTitleDisplayMode(.inline)
        }else{
            SomeThingLoadingWithText(text: "지갑을 생성하고 있습니다.")
        }
        
    }
}

#Preview {
    @Previewable @StateObject var appManager = NavigationRouter()
    @Previewable @StateObject var walletModel = KPHWallet()
    WalletMnemonicView()
        .environmentObject(appManager)
        .environmentObject(walletModel)
}
