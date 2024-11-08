//
//  Interactor.swift
//  vlgrigorevPW2
//
//  Created by Vladimir Grigoryev on 08.11.2024.
//

final class Interactor: BusinessLogic {
    private let presenter: PresentationLogic
    
    init(presenter: PresentationLogic) {
        self.presenter = presenter
    }
    
    func LoadStart(_ request: Model.Start.Request) {
        presenter.PresentStart(Model.Start.Response())
    }
    
    func LoadOther(_ request: Model.Other.Request) {
        presenter.PresentOther(Model.Other.Response())
    }
}
