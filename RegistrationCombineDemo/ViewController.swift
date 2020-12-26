//
//  ViewController.swift
//  RegistrationCombineDemo
//
//  Created by naz. on 12/4/20.
//

import Combine
import UIKit

class ViewController: UITableViewController {
    @IBOutlet var formTableView: UITableView!
    @IBOutlet var submitButton: UIBarButtonItem!
    
    fileprivate var cellIdentifier = "Cell"
    fileprivate var datasource: UITableViewDiffableDataSource<Int, FieldModel>!
    fileprivate let fieldModels = FieldModels()
    
    // Publisher bound to our UI which is the submit button
    fileprivate var validationPublisher: AnyPublisher<Bool, Never>!
    
    // Where we keep references of publishers so that they could be deallocated later
    fileprivate var store = Set<AnyCancellable>()
    
    @IBAction func submitAction(_ sender: Any) {
        print("Submit was tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupTableDataSource()
        bindValidation6()
        bindSubmitButton1()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        applyDataSource()
    }
    
    fileprivate func layout() {
        formTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    /// Initialize the tableview data source
    fileprivate func setupTableDataSource() {
        datasource = UITableViewDiffableDataSource<Int, FieldModel>(tableView: formTableView, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! FieldTableViewCell
            cell.fieldModel = model
            return cell
        })
    }
    
    /// Populate the tableview with rows
    fileprivate func applyDataSource() {
        let models = [
            fieldModels.first,
            fieldModels.second,
            fieldModels.third,
            fieldModels.fourth,
            fieldModels.fifth,
            fieldModels.sixth
        ]
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, FieldModel>()
        snapshot.appendSections([1])
        snapshot.appendItems(models, toSection: 1)
        
        datasource.apply(snapshot)
    }
}

/// We bind the submit button and validate values
extension ViewController {
    /// Bind the submit button using assign
    func bindSubmitButton1() {
        validationPublisher
            .assign(to: \.isEnabled, on: submitButton)
            .store(in: &store)
    }
    
    /// Aternatively bind using sink
    func bindSubmitButton2() {
        validationPublisher
            .sink { isEnabled in
            self.submitButton.isEnabled = isEnabled
        }
        .store(in: &store)
    }
    
    /// If we prefer to just validate two field values
    fileprivate func bindValidation2() {
        validationPublisher = Publishers.CombineLatest(fieldModels.first.$value, fieldModels.second.$value)
            .map { value1, value2 in
                let valid = !value1.isEmpty && !value2.isEmpty
                return valid
            }
            // If not bound to other objects a publisher could be returned
            .eraseToAnyPublisher()
    }
    
    /// If validate three field values
    fileprivate func bindValidation3() {
        validationPublisher = Publishers.CombineLatest3(fieldModels.first.$value, fieldModels.second.$value, fieldModels.third.$value)
            .map { value1, value2, value3 in
                let valid = !value1.isEmpty && !value2.isEmpty && !value3.isEmpty
                return valid
            }
            .eraseToAnyPublisher()
    }
    
    /// CombineLatest4 can take 4 publishers then we can validate all four
    fileprivate func bindValidation4() {
        validationPublisher = Publishers.CombineLatest4(fieldModels.first.$value, fieldModels.second.$value, fieldModels.third.$value, fieldModels.fourth.$value)
            .map { value1, value2, value3, value4 in
                let valid = !value1.isEmpty && !value2.isEmpty && !value3.isEmpty && !value4.isEmpty
                return valid
            }
            .eraseToAnyPublisher()
    }
    
    /// We do not have CombineLatest5...nth instead we use the result of previous CombineLatest publishers to a new CombineLatest
    fileprivate func bindValidation6() {
        let validation1: AnyPublisher<Bool, Never>! = Publishers.CombineLatest3(fieldModels.first.$value, fieldModels.second.$value, fieldModels.third.$value)
            .map { value1, value2, value3 in
                let valid = !value1.isEmpty && !value2.isEmpty && !value3.isEmpty
                return valid
            }
            .eraseToAnyPublisher()
        
        let validation2: AnyPublisher<Bool, Never>! = Publishers.CombineLatest3(fieldModels.fourth.$value, fieldModels.fifth.$value, fieldModels.sixth.$value)
            .map { value1, value2, value3 in
                let valid = !value1.isEmpty && !value2.isEmpty && !value3.isEmpty
                return valid
            }
            .eraseToAnyPublisher()
        
        validationPublisher = Publishers.CombineLatest(validation1, validation2)
            .map { result1, result2 in
                let valid = result1 && result2
                return valid
            }
            .eraseToAnyPublisher()
    }
}
