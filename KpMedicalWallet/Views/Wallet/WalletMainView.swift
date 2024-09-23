//
//  WalletMainView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//

import SwiftUI

struct WalletMainView: View {
    @EnvironmentObject var appManager: NavigationRouter
    @StateObject var walletModel = KPHWallet()
    var body: some View {
        VStack{
            if walletModel.isLoading{
                HStack{
                    Spacer()
                    SomeThingLoading()
                    Spacer()
                }
            }else if !walletModel.walletState {
                VStack{
                    HStack{
                        Text("지갑이 존재하지 않습니다.")
                            .modifier(WalletViewEmptyWalletTitleModifier())
                        Spacer()
                    }
                    Text("지갑을 생성해 주세요")
                        .modifier(WalletViewEmptyWalletGuaidLineModifier())
                    HStack{
                        Button{
                            walletModel.goToCreatePasswordView(appManager: appManager)
                        }label: {
                            Text("지갑생성")
                                .modifier(WalletViewCreateWalletButton())
                        }
                        Button{
                            
                        } label: {
                            Text("지갑찾기")
                                .modifier(WalletViewFindWalletButton())
                        }
                    }
                }
                .modifier(WalletViewCardModifier())
                Spacer()
            }else{
                VStack(alignment: .leading, spacing: 20) {
                    Text("Address")
                        .modifier(WalletViewEmptyWalletTitleModifier())
                    HStack {
                        Text("WalletAddres")
                            .modifier(WalletViewAddress())
                        Spacer()
                        Button{
                            UIPasteboard.general.string = "WalletAddres"
                        }label: {
                            Image(systemName: "doc.on.doc")
                                .modifier(WalletViewCopyTextImage())
                        }
                    }
                    .modifier(WalletViewAddressSection())
                    
                    Text("Storage")
                        .modifier(WalletViewEmptyWalletTitleModifier())
                    HStack {
                        Text("ContractAddres")
                            .modifier(WalletViewAddress())
                        Spacer()
                        Button{
                            UIPasteboard.general.string = "ContractAddres"
                        }label: {
                            Image(systemName: "doc.on.doc")
                                .modifier(WalletViewCopyTextImage())
                        }
                    }
                    .modifier(WalletViewAddressSection())
                }
                .modifier(WalletViewCardModifier())
                VStack(alignment: .leading, spacing: 20) {
                    Text("KPM 요청 내역")
                        .bold()
                        .font(.title3)
                    if !walletModel.TrasactionList.isEmpty {
                        List {
                            ForEach(walletModel.TrasactionList.indices, id: \.self) { index in
                                WalletAccessItem(item: $walletModel.TrasactionList[index])
                                    .listRowInsets(EdgeInsets())
                                    .padding(.vertical, 4)
                                    .onAppear{
                                        if index == walletModel.TrasactionList.endIndex - 1 {
                                            walletModel.pagingGetTransactionList(appManager: appManager)
                                        }
                                    }
                            }
                        }
                        .listStyle(PlainListStyle())
                    } else {
                        Spacer()
                        HStack {
                            Text("요청내역이 존재하지 않습니다.")
                                .bold()
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .modifier(WalletViewCardModifier())
                Spacer()
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear{
            Task{
                await walletModel.setDatas(appManager: appManager)
            }
            
        }
        .navigationTitle("KPM Wallet")
        
    }
}

#Preview {
    @Previewable @StateObject var appManager = NavigationRouter()
    WalletMainView()
        .environmentObject(appManager)
}
struct WalletActiveView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Address")
                .modifier(WalletViewEmptyWalletTitleModifier())
            HStack {
                Text("WalletAddres")
                    .modifier(WalletViewAddress())
                Spacer()
                Button{
                    UIPasteboard.general.string = "WalletAddres"
                }label: {
                    Image(systemName: "doc.on.doc")
                        .modifier(WalletViewCopyTextImage())
                }
                
            }
            .modifier(WalletViewAddressSection())
            
            Text("Storage")
                .modifier(WalletViewEmptyWalletTitleModifier())
            HStack {
                Text("ContractAddres")
                    .modifier(WalletViewAddress())
                Spacer()
                Button{
                    UIPasteboard.general.string = "ContractAddres"
                }label: {
                    Image(systemName: "doc.on.doc")
                        .modifier(WalletViewCopyTextImage())
                }
            }
            .modifier(WalletViewAddressSection())
        }
        .modifier(WalletViewCardModifier())
    }
}
struct EmptyWalletView: View {
    var body: some View {
        VStack{
            HStack{
                Text("지갑이 존재하지 않습니다.")
                    .modifier(WalletViewEmptyWalletTitleModifier())
                Spacer()
            }
            Text("지갑을 생성해 주세요")
                .modifier(WalletViewEmptyWalletGuaidLineModifier())
            HStack{
                Button{
                    
                }label: {
                    Text("지갑생성")
                        .modifier(WalletViewCreateWalletButton())
                }
                Button{
                    
                } label: {
                    Text("지갑찾기")
                        .modifier(WalletViewFindWalletButton())
                }
            }
        }
        .modifier(WalletViewCardModifier())
    }
}
struct WalletAccessItem: View {
    @Binding var item: WalletModel.AccessItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack {
                Text(item.Date)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 7)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(item.HospitalName)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(item.Purpose)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Text(item.blockHash)
                    .lineLimit(1)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            Spacer()
            VStack{
                Spacer()
                if item.State {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                } else {
                    Image(systemName: "arrow.left.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
                Text(item.State ? "응답" : "요청")
                    .font(.system(size: 13))
                    .foregroundColor(item.State ? .green : .red)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 4)
                    .background(item.State ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .cornerRadius(5)
                Spacer()
            }
        }
        .padding()
        .cornerRadius(10)
    }
}
