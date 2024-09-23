//
//  HospitalViewMainListContent.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/18/24.
//

import SwiftUI

struct HospitalViewMainListContent: View{
    @ObservedObject var viewModel: HospitalListMainViewModel
    var body: some View {
        contentView()
    }
    @ViewBuilder
    private func contentView() -> some View {
        if viewModel.isLoading {
            loadingView()
        } else if viewModel.hospitalList.isEmpty {
            if !viewModel.isMyHospital{
                emptyListView()
            }else{
                emptyMyListView()
            }
        } else {
            hospitalListView()
        }
    }
    
    private func loadingView() -> some View {
        SomeThingLoading()
    }
    
    private func emptyListView() -> some View {
        SomethingEmpty(text: "해당 병원이 존재하지 않습니다.")
    }
    private func emptyMyListView() -> some View {
        SomethingEmpty(text: "등록된 내 병원이 존재하지 않습니다.")
    }
    private func hospitalListView() -> some View {
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
                            switch viewModel.isMyHospital{
                            case true:
                                viewModel.addMyHospitalList()
                            case false:
                                viewModel.addHospitalList()
                            }
                            print("✅PageNation \(viewModel.requestQuery.start)")
                        }
                    }
                }
                
            }
        }
        .listStyle(viewModel.isMyHospital ? .inset : InsetListStyle())
    }
}
