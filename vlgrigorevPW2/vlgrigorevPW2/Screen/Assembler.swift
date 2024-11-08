//
//  Assembler.swift
//  vlgrigorevPW2
//
//  Created by Vladimir Grigoryev on 08.11.2024.
//

import UIKit

enum Assembler {
    static func build() -> UIViewController {
        let presenter = Presentor()
        let interactor = Interactor(presenter: presenter)
        let view = WishMakerViewController(interactor: interactor)
        presenter.view = view
        return view!
    }
}
