//
//  DynamicImageView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import SwiftUI

struct DynamicImageView: View {
    var images: [URL]
    let totalWidth: CGFloat // 전체 그리드의 너비 설정
    let imageHeight: CGFloat
    let oneItem: CGFloat
    
    var body: some View {
        VStack(spacing: 3) {
            if images.count == 1 {
                // 이미지가 하나인 경우
                URLImage(url: images.first!)
                    .frame(width: oneItem, height: oneItem)
                    .clipped()
            } else {
                ForEach(imageRows(images), id: \.self) { rowImages in
                    HStack(spacing: 3) {
                        ForEach(rowImages, id: \.self) { url in
                            URLImage(url: url)
                                .frame(width: totalWidth / CGFloat(rowImages.count), height: imageHeight)
                                .clipped()
                        }
                    }
                }
            }
        }
    }
    // 이미지를 행별로 그룹화
    private func imageRows(_ images: [URL]) -> [[URL]] {
        let rowItemCounts = calculateRowItemCounts(images.count)
        var rows: [[URL]] = []
        var startIndex = 0
        
        for count in rowItemCounts {
            let endIndex = startIndex + count
            if endIndex <= images.count {
                rows.append(Array(images[startIndex..<endIndex]))
            }
            startIndex = endIndex
        }
        return rows
    }
    
    // 각 행에 몇 개의 이미지가 배치될지 계산
    private func calculateRowItemCounts(_ itemCount: Int) -> [Int] {
        switch itemCount {
        case 2...3:
            return [itemCount]
        case 4:
            return [2, 2]
        case 5:
            return [3, 2]
        case 6:
            return [3, 3]
        case 7:
            return [3, 2, 2]
        default:
            var counts = Array(repeating: 3, count: itemCount / 3)
            if itemCount % 3 != 0 {
                counts.append(itemCount % 3)
            }
            return counts
        }
    }
}
