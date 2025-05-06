//
//  DIContainer.swift
//  CaloLink
//
//  Created by 김성훈 on 5/6/25.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
    private var dependencies: [String: Any] = [:]

    private init() {}

    // MARK: - Register
    func register<T>(_ type: T.Type, instance: T) {
        let key = String(describing: type)
        dependencies[key] = instance
    }

    // MARK: - Resolve
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let instance = dependencies[key] as? T else {
            fatalError("\(key) 의존성이 등록되지 않았습니다.")
        }
        return instance
    }
}
