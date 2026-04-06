//
//  DynamicWidthChipsGridView.swift
//  DesignSystem
//
//  Created by 김동준 on 1/30/25
//

import SwiftUI
import Foundation

public struct DynamicWidthChipsGridView: View {
    let categories: [ChipsGridModel]
    let selectedTitle: [String]?
    let tapAction: (String) -> Void
    @State private var chipWidths: [String: CGFloat] = [:]
    private let spacingOfEachItems: CGFloat = 10
    @State private var isChipWidthsUpdate: Bool = false
    
    public init(
        categories: [ChipsGridModel],
        selectedTitle: [String]?,
        tapAction: @escaping (String) -> Void
    ) {
        self.categories = categories
        self.selectedTitle = selectedTitle
        self.tapAction = tapAction
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let containerWidth = floor(geometry.size.width)
            let twoDimensionsRow = arrangeChips(categories, containerWidth, spacingOfEachItems)
            
            VStack(alignment: .leading, spacing: 12) {
                if isChipWidthsUpdate {
                    ForEach(twoDimensionsRow, id: \.self) { row in
                        HStack(spacing: spacingOfEachItems) {
                            ForEach(row, id: \.self) { category in
                                OEmojiChips(
                                    emoji: category.emoji,
                                    title: category.title,
                                    isSelected: Binding(
                                        get: {
                                            selectedTitle?.contains(category.title) ?? false
                                        },
                                        set: { _ in
                                            tapAction(category.title)
                                        }
                                    )
                                )
                                .modifier(
                                    DynamicWidthChipsModifier(chipWidths: $chipWidths, title: category.title)
                                )
                            }
                        }
                        .greedyWidth(.leading)
                    }
                }
            }
            .onAppear {
                chipWidths = [:]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isChipWidthsUpdate = true
                }
            }
        }
    }
}

private extension DynamicWidthChipsGridView {
    func arrangeChips(_ categories: [ChipsGridModel], _ maxWidth: CGFloat, _ spacing: CGFloat) -> [[ChipsGridModel]] {
        var rows: [[ChipsGridModel]] = []
        var oneDimensionsRow: [ChipsGridModel] = []
        var totalSumOfOneDimensionRowWidth: CGFloat = 0
        
        for category in categories {
            let chipWidth: CGFloat = round(chipWidths[category.title] ?? 100)
            let sumOfRow: CGFloat = round(totalSumOfOneDimensionRowWidth + chipWidth)
            
            if sumOfRow > maxWidth {
                rows.append(oneDimensionsRow)
                oneDimensionsRow = []
                totalSumOfOneDimensionRowWidth = 0
            }
            
            oneDimensionsRow.append(category)
            totalSumOfOneDimensionRowWidth += chipWidth
            
            if !(sumOfRow + spacing > maxWidth) {
                totalSumOfOneDimensionRowWidth += spacing
            }
        }
        
        if !oneDimensionsRow.isEmpty {
            rows.append(oneDimensionsRow)
        }
        
        return rows
    }
}

public struct ChipsGridModel: Hashable {
    let title: String
    let emoji: String
    
    public init(title: String, emoji: String) {
        self.title = title
        self.emoji = emoji
    }
}
