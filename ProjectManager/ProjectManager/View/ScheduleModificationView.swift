//
//  ScheduleModificationView.swift
//  ProjectManager
//
//  Created by 전민수 on 2022/09/10.
//

import UIKit

final class ScheduleModificationView: UIView {

    // MARK: Properties

    private let scheduleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private let scheduleTitleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemBackground
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.placeholder = "Title"
        textField.font = UIFont.preferredFont(forTextStyle: .callout)
        textField.setContentHuggingPriority(
            .required,
            for: .vertical
        )
//        textField.layer.borderWidth = 1.0
        
        textField.layer.shadowOpacity = 1
//        textField.layer.shadowRadius = 1.0
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowColor = UIColor.gray.cgColor
        
        return textField
    }()
    
    private let datePicker: UIDatePicker? = {
        let datePicker = UIDatePicker()
        
        guard let localeID = Locale.preferredLanguages.first,
              let deviceLocale = Locale(identifier: localeID).languageCode else {
            return nil
        }
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: deviceLocale)
        datePicker.minimumDate = Date()
        datePicker.setContentHuggingPriority(
            .required,
            for: .vertical
        )
        
        return datePicker
    }()
    
    private let scheduleDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.text = "Description"
        textView.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        textView.clipsToBounds = false
        textView.layer.shadowOpacity = 1
        textView.layer.shadowOffset = CGSize(width: 0, height: 2)
        textView.layer.shadowColor = UIColor.gray.cgColor
        
        return textView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    
    private func configureView() {
        self.addSubview(scheduleStackView)
        scheduleStackView.addArrangedSubview(scheduleTitleTextField)
        scheduleStackView.addArrangedSubview(datePicker!)
        scheduleStackView.addArrangedSubview(scheduleDescriptionTextView)
    }
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            scheduleStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scheduleStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scheduleStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scheduleStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
