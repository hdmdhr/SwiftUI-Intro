//
//  PagingEnvelop.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-16.
//

import Foundation

typealias PagingEnvelop<T: Decodable> = Envelop<InnerPagingEnvelop<T>>


struct InnerPagingEnvelop<T: Decodable>: Decodable {
    let items: [T]
    let currentPage, totalPages, totalItems, perPage: Int
}

