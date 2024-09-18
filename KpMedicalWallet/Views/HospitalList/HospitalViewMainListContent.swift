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
            emptyListView()
        } else {
            hospitalListView()
        }
    }
    
    private func loadingView() -> some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
            Spacer()
        }
    }
    
    private func emptyListView() -> some View {
        VStack {
            Spacer()
            Text("해당 병원이 존재하지 않습니다.")
                .foregroundColor(.gray)
            Spacer()
        }
    }
    private func hospitalListView() -> some View {
        List {
            ForEach(viewModel.hospitalList.indices, id: \.self) { index in
                Button {
                    viewModel.goHospitalDetailView(index: index)
                } label: {
                    if index < viewModel.hospitalList.count {
                        HospitalListItemView(hospital: $viewModel.hospitalList[index])
                    }
                }
                .onAppear {
                    if index == viewModel.hospitalList.endIndex - 1 {
                        viewModel.addHospitalList()
                        print("✅PageNation \(viewModel.requestQuery.start)")
                    }
                }
            }
        }
        .listStyle(InsetListStyle())
    }
}
