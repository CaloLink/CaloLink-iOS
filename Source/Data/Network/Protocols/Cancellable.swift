//
//  Cancellable.swift
//  CaloLink
//
//  Created by 김성훈 on 4/12/25.
//

import Foundation

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable { }
