//
//  FIleItem.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import SwiftUI

struct FileChatView: View {
    var urlString: String
    @StateObject var downloadManager = DownloadManager()
    @EnvironmentObject var router: NavigationRouter
    var body: some View {
        HStack(alignment:.center){
            Image(systemName: "folder.fill")
                .foregroundStyle(Color.blue.opacity(0.5))
                .padding(.leading)
            VStack(alignment: .leading,spacing: 3){
                Text("\(downloadManager.name).\(downloadManager.file_extension)")
                    .font(.system(size: 14))
                Text("용량 \(downloadManager.fileSize) KB")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.gray)
            }
            .padding(.leading,0)
            Spacer()
        }
        .frame(width: 200, height: 70)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20) // 모서리 둥근 사각형
                .stroke(Color.blue.opacity(0.5), lineWidth: 2) // 파란색, 두께 2의 태두리
        )
        .onAppear{
            if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encodedString) {
                let fullFileName = url.lastPathComponent
                if let hashIndex = fullFileName.firstIndex(of: "#") {
                    let fileName = String(fullFileName[..<hashIndex]) // '#' 이전의 문자열을 추출
                    DispatchQueue.main.async {
                        downloadManager.name = fileName
                    }
                }
                let fileExtension = url.pathExtension // 파일 확장자를 추출
                print("File extension: \(fileExtension)") // 출력: pdf
                DispatchQueue.main.async {
                    downloadManager.file_extension = fileExtension
                }
                downloadManager.checkContentLength(urlString: encodedString)
            }
        }
        .onTapGesture {
            router.showToast(message: "다운로드를 시작합니다.")
            downloadManager.startDownload(urlString: urlString)
        }
        .onChange(of: downloadManager.doen){
            print("Call ToastView")
            if downloadManager.doen == true{
                router.showToast(message: "다운로드가 완료되었습니다.")
                downloadManager.doen = false
            }
        }
    }
}
