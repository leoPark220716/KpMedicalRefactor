//
//  TreatmentCardView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/30/24.
//

import SwiftUI

struct TreatmentCardView: View {
    let item: MedicalCombineArrays
    @State var valuse: (DocId: String, DocName: String, hosname: String) = ("", "", "")
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white)
            .frame(height: 230)
            .shadow(radius: 10, x: 5, y: 5)
            .overlay(
                VStack(spacing: 0) {
                    HStack {
                        imageSection
                        VStack(alignment: .leading) {
                            Text(valuse.hosname)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.black)
                            Text("증상 : \(item.doc.symptoms.content)")
                                .lineLimit(2)
                                .bold()
                                .foregroundColor(.gray)
                            Text("병명 : \(item.doc.diseases.isEmpty ? "미상" : item.doc.diseases[0].name)")
                                .lineLimit(1)
                                .bold()
                                .foregroundColor(.gray)
                            HStack {
                                if let department = Department(rawValue: item.doc.departmentCode ?? 0) {
                                    Text(department.name)
                                        .font(.system(size: 15))
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 5)
                                        .background(Color("AccentColor"))
                                        .cornerRadius(20)
                                }
                                Text("👨🏻‍⚕️ \(valuse.DocName)")
                                    .font(.system(size: 15))
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 10)
                                    .padding(.vertical, 5)
                                    .background(Color("AccentColor"))
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.bottom)
                        Spacer()
                    }
                    HStack() {
                        Spacer()
                        Text("진료내역 확인")
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .font(.system(size: 20, weight: .semibold))
                        Spacer()
                    }
                    .background(Color("AccentColor"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            )
            .padding()
            .onAppear{
                let setus = sepStrings(inputString: item.doc.doctorID)
                if !setus.er{
                    valuse.hosname = setus.hsNmae
                    valuse.DocId = setus.DocId
                    valuse.DocName = setus.DocName
                }
            }
    }
    private func sepStrings(inputString: String) -> (er :Bool, DocId: String, DocName:String, hsNmae: String){
        let componets = inputString.components(separatedBy: ",")
        guard componets.count == 3 else{
            return (true,"","","")
        }
        return (false,componets[0],componets[1],componets[2] )
    }
    @ViewBuilder
    private var imageSection: some View {
        if let img = item.ImageUrl {
            AsyncImage(url: URL(string: img)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 90, height: 90)
            .cornerRadius(25)
            .padding()
            .shadow(radius: 10, x: 5, y: 5)
        } else {
            Image("no_image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 90)
                .cornerRadius(25)
                .padding()
                .shadow(radius: 10, x: 5, y: 5)
        }
    }
}
