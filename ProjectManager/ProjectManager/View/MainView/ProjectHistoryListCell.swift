//
//  ProjectHistoryListCell.swift
//  ProjectManager
//
//  Created by 수꿍, 휴  on 2022/09/26.
//

import UIKit
import OSLog

final class ProjectHistoryListCell: UITableViewCell, ReusableCell {
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 5

        return stackView
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .title3)

        return label
    }()

    private var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        os_log(.default, log: .ui, "Didn't use nib File")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        dateLabel.textColor = .gray
    }

    func setContents(title: String, date: String?) {
        titleLabel.text = title
        dateLabel.text = date
    }

    private func configureUI() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)

        let inset = CGFloat(10)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: inset
            ),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -inset
            ),
            stackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: inset
            ),
            stackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -inset
            )
        ])
    }
}
