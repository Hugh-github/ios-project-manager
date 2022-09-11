//
//  ProjectManager - ViewController.swift
//  Created by 수꿍, 휴 on 2022/09/07.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ProjectManagerViewController: UIViewController {
    private typealias DataSource = UITableViewDiffableDataSource<Schedule, ProjectUnit>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Schedule, ProjectUnit>
    
    private var toDoViewdataSource: ScheduleDataSource?
    private var toDoViewSnapshot: Snapshot?
    private var doingViewDataSource: ScheduleDataSource?
    private var doingViewSnapshot: Snapshot?
    private var doneViewDataSource: ScheduleDataSource?
    private var doneViewSnapshot: Snapshot?
    private let scheduleStackView = ScheduleStackView()
    
    override func loadView() {
        view = scheduleStackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        configureNavigationItems()
        
        configureToDoViewDataSource()
        configureToDoViewSnapshot()
        configureDoingViewDataSource()
        configureDoingViewSnapshot()
        configureDoneViewDataSource()
        configureDoneViewSnapshot()
    }
    
    private func configureNavigationItems() {
        self.title = "Project Manager"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(plusButtonTapped)
        )
    }
    
    @objc private func plusButtonTapped() {
        presentProjectAdditionViewController()
    }
    
    private func presentProjectAdditionViewController() {
        let addtionalProjectViewController = UINavigationController(rootViewController: ProjectAdditionViewController())
        addtionalProjectViewController.modalPresentationStyle = .formSheet
        
        present(addtionalProjectViewController, animated: true)
        
    }
    
    private func configureToDoViewDataSource() {
        let tableView = scheduleStackView.toDoView.tableView

        tableView.register(
            ScheduleListCell.self,
            forCellReuseIdentifier: ScheduleListCell.identifier
        )
        
        tableView.dataSource = toDoViewdataSource
        tableView.delegate = self
        
        toDoViewdataSource = ScheduleDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, _ in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ScheduleListCell.identifier,
                    for: indexPath
                ) as? ScheduleListCell else {
                    return nil
                }
                
                cell.separatorInset = .zero
                
                return cell
            }
        )
    }
    
    private func configureDoingViewDataSource() {
        let tableView = scheduleStackView.doingView.tableView

        tableView.register(
            ScheduleListCell.self,
            forCellReuseIdentifier: ScheduleListCell.identifier
        )
        
        tableView.dataSource = doingViewDataSource
        tableView.delegate = self
        
        doingViewDataSource = ScheduleDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, _ in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ScheduleListCell.identifier,
                    for: indexPath
                ) as? ScheduleListCell else {
                    return nil
                }
                
                cell.separatorInset = .zero
                
                return cell
            }
        )
    }
    
    private func configureDoneViewDataSource() {
        let tableView = scheduleStackView.doneView.tableView

        tableView.register(
            ScheduleListCell.self,
            forCellReuseIdentifier: ScheduleListCell.identifier
        )
        
        tableView.dataSource = doneViewDataSource
        tableView.delegate = self
        
        doneViewDataSource = ScheduleDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, _ in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ScheduleListCell.identifier,
                    for: indexPath
                ) as? ScheduleListCell else {
                    return nil
                }
                
                cell.separatorInset = .zero
                
                return cell
            }
        )
    }
 
    private func configureToDoViewSnapshot() {
        toDoViewSnapshot = Snapshot()

        let unit = ProjectUnit(id: UUID(), title: "쥬스 메이커", body: "쥬스 메이커 프로젝트입니다", section: "ToDo", deadLine: Date())
        let unit2 = ProjectUnit(id: UUID(), title: "은행 창구 매니저", body: "은행 창구 매니저 프로젝트입니다", section: "Doing", deadLine: Date())

        toDoViewSnapshot?.appendSections([.toDo])
        toDoViewSnapshot?.appendItems([unit, unit2])

        toDoViewdataSource?.apply(toDoViewSnapshot!)
    }
    
    private func configureDoingViewSnapshot() {
        doingViewSnapshot = Snapshot()

        let unit3 = ProjectUnit(id: UUID(), title: "숫자 야구", body: "숫자 야구 프로젝트입니다", section: "Done", deadLine: Date())
        
        doingViewSnapshot?.appendSections([.doing])
        doingViewSnapshot?.appendItems([unit3])

        doingViewDataSource?.apply(doingViewSnapshot!)
    }
    
    private func configureDoneViewSnapshot() {
        doneViewSnapshot = Snapshot()

        let unit33 = ProjectUnit(id: UUID(), title: "묵찌빠", body: "묵찌빠 프로젝트입니다", section: "Done", deadLine: Date())
        
        doneViewSnapshot?.appendSections([.done])
        doneViewSnapshot?.appendItems([unit33])

        doneViewDataSource?.apply(doneViewSnapshot!)
    }
}

enum Schedule: String {
    case toDo
    case doing
    case done
    
    var header: String {
        switch self {
        case .toDo:
            return "TODO"
        case .doing:
            return "DOING"
        case .done:
            return "DONE"
        }
    }
}

class ScheduleDataSource: UITableViewDiffableDataSource<Schedule, ProjectUnit> {
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let section = self.snapshot().sectionIdentifiers[section]
//
//        return section.header
        
//        let fullText = NSMutableAttributedString()
        
//        let imageAttachment = NSTextAttachment()
//        imageAttachment.image = UIImage(named: "\(number)_\(color == .yellow ? "yellow" : "gray")")
//        let imageString = NSAttributedString(attachment: imageAttachment)
//        let endString = NSAttributedString("nouveaux")
//
//        fullText.append(imageString)
//        fullText.append(endString)
//
//        mainLabel.attributedText = fullText
//    }
}

extension ProjectManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        
        switch tableView {
        case scheduleStackView.toDoView.tableView:
            label.text = Schedule.toDo.header
        case scheduleStackView.doingView.tableView:
            label.text = Schedule.doing.header
        case scheduleStackView.doneView.tableView:
            label.text = Schedule.done.header
        default:
            break
        }
        
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        
        let image = circleAroundDigit(3, circleColor: .black,
                                   digitColor: .white, diameter: 30, font: .preferredFont(forTextStyle: .body))
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
    
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
//        headerView.addSubview(label)
//        headerView.addSubview(imageView)
        headerView.addSubview(stackView)
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(imageView)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func circleAroundDigit(_ num: Int, circleColor: UIColor,
                           digitColor: UIColor, diameter: CGFloat,
                           font: UIFont) -> UIImage {
        precondition((0...9).contains(num), "digit is not a digit")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let customString = NSAttributedString(string: String(num), attributes:
            [.font: font, .foregroundColor: digitColor, .paragraphStyle: paragraphStyle])
        let imageRender = UIGraphicsImageRenderer(size: CGSize(width: diameter, height: diameter))
        return imageRender.image {con in
            circleColor.setFill()
            con.cgContext.fillEllipse(in:
                CGRect(x: 0, y: 0, width: diameter, height: diameter))
            customString.draw(in: CGRect(x: 0, y: diameter / 2 - font.lineHeight / 2,
                              width: diameter, height: diameter))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentProjectModificationViewController()
    }
    
    private func presentProjectModificationViewController() {
        let projectModificationViewController = UINavigationController(rootViewController: ProjectModificationViewController())
        projectModificationViewController.modalPresentationStyle = .formSheet
        
        present(projectModificationViewController, animated: true)
        
    }
}
