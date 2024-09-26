//
//  URLImage.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import SwiftUI

struct URLImage: View {
    @StateObject private var loader: ImageLoader
    var placeholder: Image
    
    init(url: URL, placeholder: Image = Image(systemName: "photo")) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
    }
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable().aspectRatio(contentMode: .fill)
            } else {
                placeholder
                    .resizable().aspectRatio(contentMode: .fill)
            }
        }
        .onAppear {
            loader.load()
        }
        .onDisappear {
            loader.cancel()
        }
    }
}
struct URLImageForView: View {
    @StateObject private var loader: ImageLoader
    var placeholder: Image
    
    init(url: URL, placeholder: Image = Image(systemName: "photo")) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
    }
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable().aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loader.load()
        }
        .onDisappear {
            loader.cancel()
        }
    }
}

