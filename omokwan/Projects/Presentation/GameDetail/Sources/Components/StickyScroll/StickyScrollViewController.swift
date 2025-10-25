//
//  StickyScrollViewController.swift
//  GameDetail
//
//  Created by 김동준 on 10/5/25
//

import UIKit
import Domain
import DesignSystem
import Util
import SwiftUI
import ComposableArchitecture

class StickyScrollViewController: UIViewController {
    private let store: StoreOf<StickyCalendarFeature>
    private let hPadding: CGFloat
    private let availableWidth: CGFloat
    private let textWidth: CGFloat
    private let stoneRowWidth: CGFloat
    private let itemSize: CGFloat
    
    private var cachedDateInfosCount = 0
    private var cachedNeedPreviousPaging = false
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<String, GameDetailDate> = {
        createDataSource()
    }()
    
    init(
        store: StoreOf<StickyCalendarFeature>,
        availableWidth: CGFloat,
        hPadding: CGFloat
    ) {
        self.store = store
        self.availableWidth = availableWidth
        self.hPadding = hPadding
        
        self.textWidth = GameDetailConstants.calendarDayTextWidthRatio * availableWidth
        self.stoneRowWidth = GameDetailConstants.stoneRowWidthRatio * availableWidth
        self.itemSize = stoneRowWidth / 5
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("StickyScrollViewController init error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        cachedDateInfosCount = store.dateUserStatusInfos.values.flatMap { $0 }.count
        cachedNeedPreviousPaging = store.needPreviousDatePaging
        
        observe { [weak self] in
            guard let self else { return }
            
            if store.shouldReloadToday {
                if !store.comboUpdatedDates.isEmpty {
                    reloadComboItems()
                } else {
                    reloadTodayItem()
                }
                return
            }
            
            let needPrevious = self.store.needPreviousDatePaging
            let dateInfos = self.store.dateUserStatusInfos
            let cursor = self.store.pagingCursor

            let newCount = dateInfos.values.flatMap { $0 }.count
            let isCountChanged = self.cachedDateInfosCount != newCount
            
            if isCountChanged && newCount > 0 {
                self.handleDataChange(
                    cursor: cursor
                )
                self.cachedDateInfosCount = newCount
                
                let isInitinalDataFetched = store.isInitialLoad && !store.dateUserStatusInfos.isEmpty
                
                if isInitinalDataFetched {
                    scrollToSelectedDate()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                        self?.store.send(.setIsInitialLoad(false))
                    }
                }
            }
            
            if self.cachedNeedPreviousPaging != needPrevious {
                self.cachedNeedPreviousPaging = needPrevious
                DispatchQueue.main.async {
                    self.collectionView.setCollectionViewLayout(self.createLayout(), animated: false)
                }
            }
        }
    }
    
    func handleDataChange(cursor: PagingCursor) {
        guard !store.isUpdatingSnapshot else { return }
        
        switch cursor {
        case .today:
            todayUpdateData()
        case .previous:
            previousUpdateData()
        case .next:
            nextUpdateData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

private extension StickyScrollViewController {
    func createLayout() -> UICollectionViewLayout {
        let needPreviousDatePaging = store.needPreviousDatePaging
        
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }
            
            let snapshot = self.dataSource.snapshot()
            let isLastSection = sectionIndex == snapshot.sectionIdentifiers.count - 1

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(self.itemSize)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(self.itemSize)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 0
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: hPadding,
                bottom: 0,
                trailing: hPadding
            )
            
            if !isLastSection {
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 0, leading: 0, bottom: 20, trailing: 0
                )
            }
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .absolute(UIScreen.main.bounds.width),
                heightDimension: .estimated(50)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            header.pinToVisibleBounds = true
            
            var supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = [header]
            
            let isPreviousProgressVisible = isLastSection && needPreviousDatePaging
            if isPreviousProgressVisible {
                let footerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(64)
                )
                let footer = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerSize,
                    elementKind: UICollectionView.elementKindSectionFooter,
                    alignment: .bottom
                )
                supplementaryItems.append(footer)
            }
            
            section.boundarySupplementaryItems = supplementaryItems
            
            return section
        }
    }
}

private extension StickyScrollViewController {
    func createDataSource() -> UICollectionViewDiffableDataSource<String, GameDetailDate> {
        let cellRegistration = registerRowView()
        let headerRegistration = registerHeaderView()
        let footerProgressRegistration = registerFooterProgressView()
        
        let dataSource = UICollectionViewDiffableDataSource<String, GameDetailDate>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerRegistration,
                    for: indexPath
                )
            case UICollectionView.elementKindSectionFooter:
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: footerProgressRegistration,
                    for: indexPath
                )
            default:
                return nil
            }
        }
        
        return dataSource
    }
    
    func registerRowView() -> UICollectionView.CellRegistration<UICollectionViewCell, GameDetailDate> {
        UICollectionView.CellRegistration<UICollectionViewCell, GameDetailDate> { [weak self] cell, indexPath, item in
            guard let self = self else { return }
            
            cell.backgroundView = nil
            cell.selectedBackgroundView = nil
            
            let snapshot = self.dataSource.snapshot()
            let section = snapshot.sectionIdentifiers[indexPath.section]
            let itemsInSection = snapshot.itemIdentifiers(inSection: section)
            let isLastItem = indexPath.item == itemsInSection.count - 1
            
            let isTodayYearMonth = section == store.todayYearMonth
            let isToday = item.date == store.todayOnlyDay && isTodayYearMonth

            let latestItem = store.dateUserStatusInfos[section]?.first(where: { $0.originalDate == item.originalDate }) ?? item

            let rowView = CalendarRowSectionView(
                gameDetailDate: latestItem,
                isToday: isToday,
                todayString: store.todayString,
                availableWidth: availableWidth,
                headerString: section,
                isLastItem: isLastItem
            )
            
            cell.contentConfiguration = UIHostingConfiguration {
                rowView
            }
            .margins(.all, 0)
            .background(.clear)
        }
    }
    
    func registerHeaderView() -> UICollectionView.SupplementaryRegistration<UICollectionViewCell> {
        UICollectionView.SupplementaryRegistration<UICollectionViewCell>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] headerView, elementKind, indexPath in
            guard let self = self else { return }
            
            let snapshot = self.dataSource.snapshot()
            let section = snapshot.sectionIdentifiers[indexPath.section]
            
            let headerSwiftUIView = CalendarHeaderView(headerString: section)
            
            headerView.contentConfiguration = UIHostingConfiguration {
                headerSwiftUIView
            }
            .margins(.all, 0)
            .background(.clear)
        }
    }
    
    func registerFooterProgressView() -> UICollectionView.SupplementaryRegistration<UICollectionViewCell> {
        UICollectionView.SupplementaryRegistration<UICollectionViewCell>(
            elementKind: UICollectionView.elementKindSectionFooter
        ) { [weak self] footerView, elementKind, indexPath in
            guard let self = self else { return }
            
            let snapshot = self.dataSource.snapshot()
            let isLastSection = indexPath.section == snapshot.sectionIdentifiers.count - 1
            
            let isPreviousProgressVisible = isLastSection && store.needPreviousDatePaging
            if isPreviousProgressVisible {
                footerView.contentConfiguration = UIHostingConfiguration {
                    ProgressView()
                        .frame(height: 64)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

extension StickyScrollViewController {
    private enum InsertPosition {
        case top
        case bottom
    }
    
    private func todayUpdateData() {
        store.send(.setIsUpdatingSnapshot(true))
        applyInitialSnapshot()
        store.send(.setIsUpdatingSnapshot(false))
    }
    
    private func previousUpdateData() {
        store.send(.setIsUpdatingSnapshot(true))
        
        var snapshot = dataSource.snapshot()
        
        let oldSections = Set(snapshot.sectionIdentifiers)
        let newSections = Set(store.dateUserStatusInfos.keys)
        let differenceSections = newSections.subtracting(oldSections)
        let intersectionSections = oldSections.intersection(newSections)

        for section in intersectionSections {
            addNewDatesToSection(
                section,
                updatedData: store.dateUserStatusInfos,
                snapshot: &snapshot,
                position: .bottom
            )
        }
        
        insertNewSections(
            differenceSections,
            updatedData: store.dateUserStatusInfos,
            snapshot: &snapshot,
            position: .bottom
        )

        dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
            self?.store.send(.previousPagingDataUpdated)
        }
    }
    
    private func nextUpdateData() {
        store.send(.setIsUpdatingSnapshot(true))
        
        var snapshot = dataSource.snapshot()
        
        let oldSections = Set(snapshot.sectionIdentifiers)
        let newSections = Set(store.dateUserStatusInfos.keys)
        let differenceSections = newSections.subtracting(oldSections)
        let intersectionSections = oldSections.intersection(newSections)

        
        
        insertNewSections(
            differenceSections,
            updatedData: store.dateUserStatusInfos,
            snapshot: &snapshot,
            position: .top
        )
        
        for section in intersectionSections {
            addNewDatesToSection(
                section,
                updatedData: store.dateUserStatusInfos,
                snapshot: &snapshot,
                position: .top
            )
        }
        
        dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
            guard let self = self else { return }
            
            self.collectionView.performBatchUpdates(nil) { _ in
                let newContentHeight = self.collectionView.contentSize.height
                let addedHeight = newContentHeight - self.store.savedContentHeight
                
                if addedHeight > 0 {
                    let newOffset = self.store.savedContentOffset + addedHeight
                    self.collectionView.setContentOffset(CGPoint(x: 0, y: newOffset), animated: false)
                }
                
                self.store.send(.nextPagingDataUpdated)
            }
        }
    }
    
    private func addNewDatesToSection(
        _ section: String,
        updatedData: [String: [GameDetailDate]],
        snapshot: inout NSDiffableDataSourceSnapshot<String, GameDetailDate>,
        position: InsertPosition
    ) {
        guard let newDates = updatedData[section] else { return }
        
        let currentItems = snapshot.itemIdentifiers(inSection: section)
        let currentOriginalDates = Set(currentItems.map { $0.originalDate })
        let itemsToAdd = newDates.filter { !currentOriginalDates.contains($0.originalDate) }
        
        guard !itemsToAdd.isEmpty else { return }
        
        let sortedItems = itemsToAdd.sorted { $0.date > $1.date }
        
        switch position {
        case .top:
            if let firstItem = currentItems.first {
                snapshot.insertItems(sortedItems, beforeItem: firstItem)
            }
        case .bottom:
            snapshot.appendItems(sortedItems, toSection: section)
        }
    }
    
    private func insertNewSections(
        _ sections: Set<String>,
        updatedData: [String: [GameDetailDate]],
        snapshot: inout NSDiffableDataSourceSnapshot<String, GameDetailDate>,
        position: InsertPosition
    ) {
        guard !sections.isEmpty else { return }
        
        let sortedSections = sections.sorted(by: >)
        
        switch position {
        case .top:
            for section in sortedSections.reversed() {
                if let firstSection = snapshot.sectionIdentifiers.first {
                    snapshot.insertSections([section], beforeSection: firstSection)
                } else {
                    snapshot.appendSections([section])
                }
                appendDatesToSection(section, updatedData: updatedData, snapshot: &snapshot)
            }
        case .bottom:
            for section in sortedSections {
                snapshot.appendSections([section])
                appendDatesToSection(section, updatedData: updatedData, snapshot: &snapshot)
            }
        }
    }

    private func appendDatesToSection(
        _ section: String,
        updatedData: [String: [GameDetailDate]],
        snapshot: inout NSDiffableDataSourceSnapshot<String, GameDetailDate>
    ) {
        guard let dates = updatedData[section] else { return }
        let sortedDates = dates.sorted { $0.date > $1.date }
        snapshot.appendItems(sortedDates, toSection: section)
    }
    
    private func reloadTodayItem() {
        let yearMonth = store.todayYearMonth
        let day = store.todayOnlyDay
        
        guard let todayDates = store.dateUserStatusInfos[yearMonth],
              let updatedItem = todayDates.first(where: { $0.date == day }) else {
            store.send(.resetReloadFlag)
            return
        }

        var snapshot = dataSource.snapshot()

        guard let oldItem = snapshot.itemIdentifiers.first(where: {
            $0.originalDate == updatedItem.originalDate
        }) else {
            store.send(.resetReloadFlag)
            return
        }

        snapshot.reconfigureItems([oldItem])

        dataSource.apply(snapshot, animatingDifferences: false)

        store.send(.resetReloadFlag)
    }
    
    private func reloadComboItems() {
        let datesToReload = store.comboUpdatedDates
        guard !datesToReload.isEmpty else {
            store.send(.resetReloadFlag)
            return
        }
        
        var snapshot = dataSource.snapshot()
        
        for dateString in datesToReload {
            if let oldItem = snapshot.itemIdentifiers.first(where: { $0.originalDate == dateString }) {
                snapshot.reconfigureItems([oldItem])
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
        
        store.send(.resetReloadFlag)
        store.send(.clearComboUpdatedDates)
    }
}

private extension StickyScrollViewController {
    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, GameDetailDate>()

        for key in store.sortedKeys {
            guard let dates = store.dateUserStatusInfos[key] else { continue }
            
            snapshot.appendSections([key])
            snapshot.appendItems(dates, toSection: key)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func scrollToSelectedDate() {
        let sectionId = String(store.selectedDateString.prefix(7))
        let dayId = String(store.selectedDateString.suffix(2))
        
        guard let sectionIndex = dataSource.snapshot().sectionIdentifiers.firstIndex(of: sectionId),
              let dates = store.dateUserStatusInfos[sectionId],
              let dateIndex = dates.firstIndex(where: { $0.date == dayId }) else {
            return
        }
        
        let indexPath = IndexPath(item: dateIndex, section: sectionIndex)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }
    }
}

extension StickyScrollViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !store.isInitialLoad && !store.isUpdatingSnapshot else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.bounds.height
        let adjustedOffset = offsetY + scrollView.adjustedContentInset.top
        let bottomOffset = offsetY + scrollViewHeight
        let distanceFromBottom = contentHeight - bottomOffset
        
        let isReachedTop = adjustedOffset <= 10
            && !store.isLoadingTop
            && store.needNextDatePaging
            && !store.isInitialLoad
        
        let isReachedBottom = distanceFromBottom <= 10
            && !store.isLoadingBottom
            && store.needPreviousDatePaging

        guard contentHeight > 0 else { return }
        
        if isReachedTop {
            store.send(
                .scrollTopReached(
                    scrollView.contentOffset.y,
                    scrollView.contentSize.height
                )
            )
            return
        }
        
        if isReachedBottom {
            store.send(.scrollBottomReached)
            return
        }
    }
}
