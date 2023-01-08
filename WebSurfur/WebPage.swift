//
//  WebPage.swift
//  WebSurfur
//
//  Created by SeanLi on 1/8/23.
//

import Foundation
import WebKit
import SwiftUI
import AppKit

class WebViewManager : ObservableObject {
    var webview: WKWebView = WKWebView()
    
    init(loadString: String) {
        webview.load(URLRequest(url: URL(string: loadString)!))
    }
    
    func searchFor(searchText: String) {
        if let searchTextNormalized = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
           let url = URL(string: "https://baidu.com/search?q=\(searchTextNormalized)") {                        self.loadRequest(request: URLRequest(url: url))
        }
    }
    
    func loadRequest(request: URLRequest) {
        webview.load(request)
    }
    
    func goBack(){
        webview.goBack()
    }
    
    func goForward(){
        webview.goForward()
    }
    
    func refresh(){
        webview.reload()
    }
}

struct Webview : NSViewRepresentable {
    var manager : WebViewManager
    
    init(manager: WebViewManager) {
        self.manager = manager
    }
    
    func makeNSView(context: Context) -> WKWebView  {
        return manager.webview
    }
    
    func updateNSView(_ NSView: WKWebView, context: Context) {
        
    }
}


struct WebView: View {
    @StateObject var manager = WebViewManager(loadString: "https://cn.bing.com")
    @Binding var txt: String
    var body: some View {
        ZStack {
            HStack {
                TextField("Search", text: $txt)
            }
        }
        Webview(manager: manager)
            .toolbar {
                ToolbarItemGroup {
                    
                    Button(action: {
                        manager.goBack()
                    }) {
                        Image(systemName: "arrow.left")
                    }
                    Spacer()
                    
                    Button(action: {
                        manager.goForward()
                        
                    }) {
                        Image(systemName: "arrow.right")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        manager.refresh()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
    }
}
