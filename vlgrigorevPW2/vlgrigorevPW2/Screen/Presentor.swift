//
//  Presenter.swift
//  vlgrigorevPW2
//
//  Created by Vladimir Grigoryev on 08.11.2024.
//

import UIKit

final class Presentor: PresentationLogic {
    weak var view: WishMakerViewController?
    
    func PresentStart(_ response: Model.Start.Response) {
        view?.displayStart()
    }
    
    func PresentOther(_ response: Model.Other.Response) {
        view?.displayOther()
    }
    
    func routTo() {
        view?.navigationController?.pushViewController(UIViewController(), animated: true)
    }
}
