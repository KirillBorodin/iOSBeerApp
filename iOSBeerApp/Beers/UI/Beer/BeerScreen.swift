//
//  BeerView.swift
//  iOSBeerApp
//
//  Created by Kirill on 09.02.2025.
//

import SwiftUI
import WebKit
import os

struct BeerScreen: View {
    let url: URL
    @StateObject private var viewModel = BeerViewModel()
    
    var body: some View {
        ZStack {
            BeerWebView(url: url, viewModel: viewModel)
            
            if viewModel.isLoading {
                ProgressView("Loading…")
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.blue)
                    .foregroundColor(.blue)
            }
        }
    }
}

struct BeerWebView: UIViewRepresentable {
    
    private let logger = Logger(subsystem: "BeerWebView", category: "BeerScreen")
    
    let url: URL
    let viewModel: BeerViewModel
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, viewModel: viewModel)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        logger.info("Loading URL: \(url)")
        
        // Prevent unnecessary reloads
        if uiView.url != url {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
    
    // Coordinator for handling web view events
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: BeerWebView
        let viewModel: BeerViewModel
        
        init(_ parent: BeerWebView, viewModel: BeerViewModel) {
            self.parent = parent
            self.viewModel = viewModel
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.logger.error("Provisional navigation error: \(error.localizedDescription)")
            viewModel.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.logger.error("WebView started loading")
            viewModel.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.logger.error("WebView has been loaded")
            viewModel.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.logger.error("WebView failed to load: \(error.localizedDescription)")
            viewModel.isLoading = false
        }
    }
}

