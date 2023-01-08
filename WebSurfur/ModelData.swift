//
//  ModelData.swift
//  WebSurfur
//
//  Created by SeanLi on 1/8/23.
//

import Foundation

struct Page: Codable, Hashable, Identifiable {
    var id: UUID = .init()
    var link: String = "https://cn.bing.com"
    var title: String = "Bing"
}
