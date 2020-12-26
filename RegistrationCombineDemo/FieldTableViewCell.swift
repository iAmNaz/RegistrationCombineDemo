//
//  FieldTableViewCell.swift
//  RegistrationCombineDemo
//
//  Created by naz. on 12/4/20.
//

import UIKit

class FieldTableViewCell: UITableViewCell {
    var fieldModel: FieldModel! {
        didSet {
            textField.placeholder = fieldModel.hint
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func textChanged(_ sender: UITextField) {
        print(sender.text ?? "")
        fieldModel.value = sender.text ?? ""
    }
}
