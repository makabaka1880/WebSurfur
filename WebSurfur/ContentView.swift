//
//  ContentView.swift
//  WebSurfur
//
//  Created by SeanLi on 1/8/23.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("URLs") var pages: [Page] = [Page(link: "file://\(Bundle.main.bundlePath)/Contents/Resources/Welcome.html", title: "Welcome to WebSurfur!")]
    @State private var showPopover: Bool = false
    @State private var cacheURL: String = NSPasteboard.general.string(forType: .string) ?? "https://"
    @State private var cacheTitle: String = "Title of the Page"
    var body: some View {
        NavigationView {
            List($pages) { $page in
                NavigationLink {
                    WebView(manager: WebViewManager(loadString: page.link), txt: $page.title)
                } label: {
                    Text(page.title)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        pages.removeAll {
                            $0.id == page.id
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .onAppear {
                print("file://\(Bundle.main.bundlePath)/Contents/Resources/Welcome.html")
            }
            .toolbar {
                Button {
                    showPopover.toggle()
                } label: {
                    Label("New", systemImage: "plus")
                }
                .popover(isPresented: $showPopover) {
                    VStack {
                        TextField("Url here...", text: $cacheURL).textFieldStyle(.plain)
                        TextField("Title here...", text: $cacheTitle).textFieldStyle(.plain)
                        Button("OK") {
                            pages.append(.init(link: cacheURL, title: cacheTitle))
                            showPopover.toggle()
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else { return nil }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

