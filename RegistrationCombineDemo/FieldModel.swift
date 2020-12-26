//
//  FieldModel.swift
//  RegistrationCombineDemo
//
//  Created by naz. on 12/4/20.
//

import Foundation

class FieldModel {
    var id = UUID()
    var hint = "Not set"
    @Published var value = ""
    
    init(hint: String) {
        self.hint = hint
    }
}

extension FieldModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FieldModel, rhs: FieldModel) -> Bool {
        return lhs.id == rhs.id
    }
}

