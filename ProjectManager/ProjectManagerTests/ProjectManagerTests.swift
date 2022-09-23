//
//  ProjectManagerTests.swift
//  ProjectManagerTests
//
//  Created by 수꿍, 휴 on 2022/09/18.
//

@testable import ProjectManager
import XCTest

final class ProjectManagerTests: XCTestCase {
    var sut: ToDoViewModelSpy!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = ToDoViewModelSpy()
        sut.callCountOfData = 0
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func test_바인딩하는_클로저가_정상적으로_호출되는지_테스트() {
        // given
        let projectUnit = ProjectUnit(
            id: UUID(),
            title: "타이틀",
            body: "바디",
            section: "TODO",
            deadLine: Date()
        )
        let expectation = 1

        // when
        sut.data.value.append(projectUnit)

        // then
        XCTAssertEqual(expectation, sut.callCountOfData)
    }

    func test_viewModel이_projectUnit을_정상적으로_코어데이터에_저장하는지_테스트() {
        // given
        let expectationCalledCount = 1
        let expectationTitle = "테스트"
        let expectationBody = "테스트를 진행합니다"
        let expectationDate = Date()

        // when
        sut.addContent(title: expectationTitle, body: expectationBody, date: expectationDate)

        // then
        XCTAssertEqual(expectationCalledCount, sut.addContentMethodCalled)
        XCTAssertEqual(expectationTitle, sut.addContentMethodTitleParam)
        XCTAssertEqual(expectationBody, sut.addContentMethodBodyParam)
        XCTAssertEqual(expectationDate, sut.addContentMethodDateParam)
    }

    func test_viewModel이_코어데이터에_저장된_projectUnit을_정상적으로_삭제하는지_테스트() {
        // given
        let expectation = 1
        let expectationCalledCount = 1
        let expectationIndex = 0

        let firstProjectUnit = ProjectUnit(
            id: UUID(),
            title: "타이틀1",
            body: "바디1",
            section: sut.identifier,
            deadLine: Date()
        )
        let secondProjectUnit = ProjectUnit(
            id: UUID(),
            title: "타이틀2",
            body: "바디2",
            section: sut.identifier,
            deadLine: Date()
        )
        sut.data.value = [firstProjectUnit, secondProjectUnit]

        // when
        sut.delete(expectationIndex)

        // then
        XCTAssertEqual(expectation, sut.numberOfData)
        XCTAssertEqual(expectationCalledCount, sut.deleteMethodCalled)
        XCTAssertEqual(expectationIndex, sut.deleteMethodIndexParam)
    }

    func test_viewModel이_코어데이터에_저장된_projectUnit을_정상적으로_업데이트하는지_테스트() {
        // given
        let expectationCallCount = 1
        let expectationIndex = 0
        let expectationTitle = "새로운 타이틀"
        let expectationBody = "새로운 바디"
        let expectationDate = Date()

        let projectUnit = ProjectUnit(
            id: UUID(),
            title: "타이틀1",
            body: "바디1",
            section: sut.identifier,
            deadLine: Date()
        )
        sut.data.value = [projectUnit]

        // when
        sut.edit(
            indexPath: expectationIndex,
            title: expectationTitle,
            body: expectationBody,
            date: expectationDate
        )

        // then
        XCTAssertEqual(expectationCallCount, sut.editMethodCalled)
        XCTAssertEqual(expectationIndex, sut.editMethodIndexParam)
        XCTAssertEqual(expectationTitle, sut.editMethodTitleParam)
        XCTAssertEqual(expectationBody, sut.editMethodBodyParam)
        XCTAssertEqual(expectationDate, sut.editMethodDateParam)
    }

//    func test_toDoViewModel의_데이터가_doingViewModel로_정상적으로_이동하는지_테스트() {
//        // given
//        countOfDoing = 0
//        let _ = sut.addContent(title: "타이틀", body: "바디", date: Date())
//        let expectation = 1
//
//        // when
//        sut.change(index: 0, status: "DOING")
//
//        // then
//        XCTAssertEqual(expectation, countOfDoing)
//    }
}
