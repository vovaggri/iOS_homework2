//
//  Protocols.swift
//  vlgrigorevPW2
//
//  Created by Vladimir Grigoryev on 08.11.2024.
//

protocol BusinessLogic {
    func LoadStart(_ request: Model.Start.Request)
    func LoadOther(_ request: Model.Other.Request)
}

protocol PresentationLogic {
    func PresentStart(_ response: Model.Start.Response)
    func PresentOther(_ response: Model.Other.Response)
    
    func routTo()
}
