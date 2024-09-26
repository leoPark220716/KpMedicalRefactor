//
//  DownloadManager.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import Foundation
class DownloadManager: NSObject, ObservableObject, URLSessionDownloadDelegate {
    @Published var alertMsg = ""
    @Published var downloadtasSession : URLSessionDownloadTask!
    @Published var name = ""
    @Published var file_extension = ""
    @Published var fileSize = 626
    @Published var doen = false
    func startDownload(urlString: String){
        print("Server URL")
        guard let ValidURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: ValidURL) else {
            print("Invalid URL")
            return
        }
        print(url)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue:  nil)
        
        downloadtasSession = session.downloadTask(with: url)
        downloadtasSession.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            var savedURL = documentsURL.appendingPathComponent("\(name).\(file_extension)")
            
            // 파일 이름에 숫자 추가하기 위해 중복 검사
            var fileCounter = 1
            while FileManager.default.fileExists(atPath: savedURL.path) {
                // 파일 이름에 숫자를 추가하여 새로운 경로 생성
                let newFileName = "\(name)_\(fileCounter).\(file_extension)"
                savedURL = documentsURL.appendingPathComponent(newFileName)
                fileCounter += 1
            }
            
            try FileManager.default.moveItem(at: location, to: savedURL)
            print("File saved at: \(savedURL)")
        } catch {
            print("Error saving file: \(error)")
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        print(progress)
        if progress == 1.0{
            print("Call ToastView true")
            DispatchQueue.main.async{
                self.doen = true
            }
        }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error{
            print(error.localizedDescription)
        }
    }
    func checkContentLength(urlString: String)  {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"  // HEAD 메소드를 사용하여 본문을 다운로드하지 않고 헤더만 조회
        
        print("✅ Check URL for File \(urlString)")
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching headers: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            if let contentLengthString = httpResponse.allHeaderFields["Content-Length"] as? String,
               let contentLength = Int(contentLengthString) {
                print("Content-Length: \(contentLength) bytes")
                let contentLengthInKB = contentLength / 1024
                DispatchQueue.main.async {
                    self.fileSize = contentLengthInKB
                }
            } else {
                print("Content-Length header is missing or invalid.")
            }
        }
        task.resume()
    }
}
