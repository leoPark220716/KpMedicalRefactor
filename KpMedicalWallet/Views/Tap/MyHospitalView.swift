//
//  MyHospitalView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/14/24.
//

import SwiftUI

struct MyHospitalView: View {
    @EnvironmentObject var appManager: NavigationRouter
    @StateObject var viewModel = HospitalListMainViewModel()
    var body: some View {
        VStack{
            if viewModel.isLoading {
                SomeThingLoading()
            } else if viewModel.hospitalList.isEmpty {
                SomethingEmpty(text: "등록된 내 병원이 존재하지 않습니다.")
            } else if !viewModel.hospitalList.isEmpty{
                List {
                    ForEach(viewModel.hospitalList.indices, id: \.self) { index in
                        if index < viewModel.hospitalList.count {
                            Button {
                                viewModel.goHospitalDetailView(index: index)
                            } label: {
                                HospitalListItemView(hospital: viewModel.hospitalList[index])
                            }
                            .onAppear {
                                if index == viewModel.hospitalList.endIndex - 1 {
                                    viewModel.addMyHospitalList()
                                }
                            }
                        }
                        
                    }
                }
            }
        }.onAppear{
            viewModel.appManager = appManager
            viewModel.myHospitalListSetUp()
            print("Hospital list on disappear: \(viewModel.hospitalList)")
        }
        .onDisappear{
            viewModel.resetHospitalListArray()
            viewModel.setQuaryReSet()
            print("Hospital list on disappear: \(viewModel.hospitalList)")
        }
        
    }
}

#Preview {
    @Previewable @StateObject var router = NavigationRouter()
    MyHospitalView()
        .environmentObject(router)
}
