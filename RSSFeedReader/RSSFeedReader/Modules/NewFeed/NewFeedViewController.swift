//
//  NewFeedViewController.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 01/09/2021.
//

import UIKit
import PureLayout

class NewFeedViewController: UIViewController {
    
    //MARK: - UIElements
    
    private let backgroundView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let newFeedLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.text = "New feed:"
        return label
    }()
    
    private let feedUrlTextField: UITextField = {
        let textField = UITextField.newAutoLayout()
        textField.borderStyle = .line
        return textField
    }()
    
    private let addButton: UIButton = {
        let button = UIButton.newAutoLayout()
        button.setTitle("Add", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton.newAutoLayout()
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView.newAutoLayout()
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let tapGuestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        return recognizer
    }()
    
    private var didSetConstranits = false
    
    private var backgroundViewBottomContraint: NSLayoutConstraint?
    
    override func loadView() {
        view = UIView()
        
        view.addSubview(backgroundView)
        
        backgroundView.addSubview(newFeedLabel)
        backgroundView.addSubview(feedUrlTextField)
        backgroundView.addSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(addButton)
        buttonsStackView.addArrangedSubview(cancelButton)
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        backgroundView.addGestureRecognizer(tap)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !didSetConstranits {
            didSetConstranits = true
            
            backgroundView.autoSetDimension(.height, toSize: 200)
            backgroundView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            backgroundView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            backgroundViewBottomContraint = backgroundView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            
            newFeedLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 40)
            newFeedLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 40)
            newFeedLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
            
            feedUrlTextField.autoPinEdge(toSuperviewEdge: .left, withInset: 40)
            feedUrlTextField.autoPinEdge(toSuperviewEdge: .right, withInset: 40)
            feedUrlTextField.autoPinEdge(.top, to: .bottom, of: newFeedLabel, withOffset: 20)
            
            buttonsStackView.autoPinEdge(.top, to: .bottom, of: feedUrlTextField, withOffset: 20)
            buttonsStackView.autoPinEdge(toSuperviewEdge: .left, withInset: 40)
            buttonsStackView.autoPinEdge(toSuperviewEdge: .right, withInset: 40)
            buttonsStackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
        }
        super.updateViewConstraints()
    }
    
    //MARK: - Public properties
    
    weak var delegate: NewFeedViewControllerDelegate?
    
    //MARK: - Private properties
    
    private var viewModel = NewFeedViewModel()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

//MARK: - Private extension -

private extension NewFeedViewController {
    
    //MARK: - View Setup
    
    private func setupView() {
        setKeyboardObservers()
    }
    
    //MARK: - Keyboard Bbservers
    
    private func setKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height
        backgroundViewBottomContraint?.autoRemove()
        backgroundViewBottomContraint = backgroundView.autoPinEdge(toSuperviewEdge: .bottom, withInset: keyboardHeight!)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        backgroundViewBottomContraint?.autoRemove()
        backgroundViewBottomContraint = backgroundView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
}

//MARK: - IBActions -

extension NewFeedViewController {
    
    @objc private func didTapAddButton(_ sender: Any) {
        guard let url = feedUrlTextField.text,
              url != ""
        else { return }
        if viewModel.feedAlreadyAdded(feedUrl: url) {
            let alerter = Alerter(title: .feedExitsts, message: .feedAlreadyAdded, preferredStyle: .alert)
            alerter.addAction(title: .ok, style: .default, handler: nil)
            alerter.showAlert(on: self, completion: nil)
        }
        else {
            delegate?.didAddNewFeed(feedUrl: url)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapBackgroundView(_ sender: Any) {
        feedUrlTextField.resignFirstResponder()
    }
    
}
