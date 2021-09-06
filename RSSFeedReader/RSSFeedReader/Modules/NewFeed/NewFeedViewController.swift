//
//  NewFeedViewController.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 01/09/2021.
//

import UIKit

class NewFeedViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var feedUrlTextField: UITextField!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var backgroundViewBottomConstraint: NSLayoutConstraint!
    
    
    //MARK: - Public properties
    
    static let identifier = "NewFeedViewController"
    weak var delegate: NewFeedViewControllerDelegate?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
}

//MARK: - Private extension -

private extension NewFeedViewController {
    
    //MARK: - View Setup
    
    private func setupView() {
        setKeyboardObservers()
    }
    
    //MARK: - UI Configuration
    
    private func configureUI() {
        backgroundView.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
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
        backgroundViewBottomConstraint.constant = keyboardHeight! - view.safeAreaInsets.bottom + 20
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        backgroundViewBottomConstraint.constant =  0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
}

//MARK: - IBActions -

extension NewFeedViewController {
    
    @IBAction func didTapAddButton(_ sender: Any) {
        guard let url = feedUrlTextField.text,
              url != ""
        else { return }
        let myFeeds = CurrentUser.shared.getMyFeeds()
        if myFeeds.contains(url) {
            let alerter = Alerter(title: .feedExitsts, message: .feedAlreadyAdded, preferredStyle: .alert)
            alerter.addAction(title: .ok, style: .default, handler: nil)
            alerter.showAlert(on: self, completion: nil)
        }
        else {
            delegate?.didAddNewFeed(feedUrl: url)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapBackgroundView(_ sender: Any) {
        feedUrlTextField.resignFirstResponder()
    }
    
}
