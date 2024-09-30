//
//  HomeView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appManager: NavigationRouter
    @StateObject var viewModel = HomeViewModel()
    @StateObject var recodeModel: ReacoderModel
    init(appManager: NavigationRouter) {
        _recodeModel = StateObject(wrappedValue: ReacoderModel(appManager: appManager))
    }
    @ViewBuilder
    private func frontCardViewSection(geo: GeometryProxy) -> some View {
        if let item = recodeModel.combineArray.last {
            TreatmentCardView(item: item)
        } else {
            Button {
                appManager.push(to: .userPage(item: UserPage(page: .SearchHospital)))
            } label: {
                HomeViewSuggestHospitals(geo: geo, viewModel: viewModel)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
    }
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                frontCardViewSection(geo: geo)
                Button{
                    appManager.push(to: .userPage(item: UserPage(page: .SearchHospital)))
                } label: {
                    SearchHospitalView(geo: geo)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                HStack{
                    Button{
                        appManager.push(to: .userPage(item: UserPage(page: .advice),appManager: appManager))
                    }label: {
                        PillView(geo: geo)
                            .padding(.leading)
                    }
                    Spacer()
                    Button{
                        appManager.push(to: .userPage(item: UserPage(page: .myReservationView)))
                    } label: {
                        calendarView(geo: geo)
                            .padding(.trailing)
                    }
                }
            }
            .padding(.bottom)
            .onAppear{
                viewModel.token = appManager.jwtToken
                do{
                    try viewModel.requestRecomendHospitalImages()
                }catch let error as TraceUserError{
                    appManager.displayError(ServiceError: error)
                }catch{
                    appManager.displayError(ServiceError: .unowned(""))
                }
                recodeModel.setRecodeData()
            }
        }
    }
}

struct HomeViewSuggestHospitals: View {
    let geo: GeometryProxy
    @ObservedObject var viewModel: HomeViewModel
    var body: some View {
        VStack{
            HStack {
                Text(PlistManager.shared.string(forKey: "home_hospital_round_line1"))
                    .foregroundStyle(Color.black)
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .bold()
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 18))
            }
            .padding([.top,.horizontal])
            HStack {
                AsyncImage(url: URL(string: viewModel.recomendImage1)){ image in
                    image
                        .suggestImageModifier(geo: geo)
                } placeholder: {
                    ProgressView()
                        .modifier(SuggestImage(geo: geo))
                }
                
                AsyncImage(url: URL(string: viewModel.recomendImage2)){ image in
                    image
                        .suggestImageModifier(geo: geo)
                } placeholder: {
                    ProgressView()
                        .modifier(SuggestImage(geo: geo))
                }
                .padding(.horizontal)
                AsyncImage(url: URL(string: viewModel.recomendImage3)){ image in
                    image
                        .suggestImageModifier(geo: geo)
                } placeholder: {
                    ProgressView()
                        .modifier(SuggestImage(geo: geo))
                }
            }
            .padding(.vertical)
            
            Text(PlistManager.shared.string(forKey: "home_hospital_round_button"))
                .frame(height: geo.size.height * 0.01)
                .modifier(ActiveButton())
                .padding([.horizontal,.bottom])
            
            
            
            
        }
        .modifier(CardViewModifier(coler: Color.white))
    }
}
struct SearchHospitalView: View {
    let geo: GeometryProxy
    var body: some View {
        VStack {
            HStack{
                Text(PlistManager.shared.string(forKey: "home_hospital_find_line1"))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .bold()
                    .padding([.top,.leading])
                Spacer()
            }
            HStack{
                Text(PlistManager.shared.string(forKey: "home_hospital_find_line2"))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .bold()
                    .padding(.leading)
                Spacer()
            }
            Spacer()
            
            Text(PlistManager.shared.string(forKey: "home_hospital_find_button"))
                .frame(height: geo.size.height * 0.01)
                .modifier(ActiveButton())
                .padding([.horizontal,.bottom])
            
            
        }
        .background(
            Image("SelectHP")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped() // 뷰의 경계를 벗어나는 부분을 잘라냄
        )
        .modifier(CardViewModifier(coler: Color("serchHospitalColor")))
    }
}
struct PillView: View{
    let geo: GeometryProxy
    var body: some View{
        VStack{
            HStack{
                Text("처방내역")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .bold()
                    .padding([.leading,.top])
                Spacer()
            }
            Spacer()
        }
        .background(
            Image("Pill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped() // 뷰의 경계를 벗어나는 부분을 잘라냄
        )
        .modifier(CardViewModifier(coler: Color.white))
        .frame(width: geo.size.width * 0.45,height: geo.size.height * 0.2)
    }
}
struct calendarView: View{
    let geo: GeometryProxy
    var body: some View{
        VStack{
            HStack{
                Text("예약현황")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .bold()
                    .padding([.leading,.top])
                Spacer()
            }
            Spacer()
        }
        .background(
            Image("date_")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped() // 뷰의 경계를 벗어나는 부분을 잘라냄
        )
        .modifier(CardViewModifier(coler: Color.white))
        .frame(width: geo.size.width * 0.45,height: geo.size.height * 0.2)
    }
}


struct HomeView_Priview: PreviewProvider{
    static var previews: some View {
        @StateObject var router = NavigationRouter()
        HomeView(appManager: router)
            .environmentObject(router)
    }
}
