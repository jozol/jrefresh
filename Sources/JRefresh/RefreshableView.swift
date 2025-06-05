import SwiftUI

extension JRefreshView {
    @available(iOS 18.0, *)
    @ViewBuilder
    func scrollView() -> some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: indicatorScrollHeight)
            ScrollView {
                content
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: IndicatorOffsetKey.self, value: proxy.frame(in: .jRefreshCoordinateSpace).minY)
                        }
                    )
            }
            .coordinateSpace(name: CoordinateSpace.nameSpace)
            .onScrollPhaseChange { oldPhase, newPhase in
                if newPhase == .decelerating, indicatorState == .primed {
                    refresh()
                }
            }
        }
    }
}
