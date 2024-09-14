//
//  HomeView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appManager: NavigationRouter
    @EnvironmentObject private var errorHandler: GlobalErrorHandler
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                HomeViewSuggestHospitals(geo: geo)
                    .padding(.horizontal)
                    .padding(.bottom)
                Button{
                    appManager.push(to: .userPage(item: UserPage(page: .SearchHospital)))
                } label: {
                    SearchHospitalView(geo: geo)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                HStack{
                    PillView(geo: geo)
                        .padding(.leading)
                    Spacer()
                    calendarView(geo: geo)
                        .padding(.trailing)
                }
            }
            .modifier(ErrorAlertModifier(errorHandler: errorHandler))
            .padding(.bottom)
        }
    }
}

struct HomeViewSuggestHospitals: View {
    let geo: GeometryProxy
    var body: some View {
            VStack{
                HStack {
                    Text("등록된 병원을 구경해보세요")
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
                    AsyncImage(url: URL(string: "https://picsum.photos/200/300")){ image in
                        image
                            .suggestImageModifier(geo: geo)
                    } placeholder: {
                        ProgressView()
                            .modifier(SuggestImage(geo: geo))
                    }
                    
                    AsyncImage(url: URL(string: "https://picsum.photos/200/300")){ image in
                        image
                            .suggestImageModifier(geo: geo)
                    } placeholder: {
                        ProgressView()
                            .modifier(SuggestImage(geo: geo))
                    }
                    .padding(.horizontal)
                    AsyncImage(url: URL(string: "https://picsum.photos/200/300")){ image in
                        image
                            .suggestImageModifier(geo: geo)
                    } placeholder: {
                        ProgressView()
                            .modifier(SuggestImage(geo: geo))
                    }
                }
                .padding(.vertical)
                Button{
                } label: {
                    Text("둘러보기")
                        .frame(height: geo.size.height * 0.01)
                        .modifier(ActiveButton())
                        .padding([.horizontal,.bottom])
                    
                }
                
            }
            .modifier(CardViewModifier(coler: Color.white))
    }
}
struct SearchHospitalView: View {
    let geo: GeometryProxy
    var body: some View {
        VStack {
            HStack{
                Text("손쉽게 원하는 병원을")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .bold()
                    .padding([.top,.leading])
                Spacer()
            }
            HStack{
                Text("병원찾기")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .bold()
                    .padding(.leading)
                Spacer()
            }
            Spacer()
            Button{
                
            } label: {
                Text("둘러보기")
                    .frame(height: geo.size.height * 0.01)
                    .modifier(ActiveButton())
                    .padding([.horizontal,.bottom])
            }
            
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
        HomeView()
            .environmentObject(router)
    }
}
