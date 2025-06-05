import SwiftUI

extension JRefreshView {
    @ViewBuilder
    func scrollViewPanGesture() -> some View {
        UIPanGestureViewHosting {
            ZStack(alignment: .top) {
                ScrollView {
                    content
                        .onGeometryChange(for: CGFloat.self) { proxy in
                            proxy.frame(in: .jRefreshCoordinateSpace).minY
                        } action: {
                            onScroll($0)
                        }
                }
                .coordinateSpace(name: CoordinateSpace.nameSpace)
                .matchedGeometryEffect(id: "indicatorPlaceholder", in: animationNS, properties: .position)
            }
            .matchedGeometryEffect(id: "indicatorPlaceholder", in: animationNS, properties: .position)
            .offset(y: indicatorScrollHeight)
        } onPan: { gest in
            switch gest.state {
            case .ended, .cancelled:
                if indicatorState == .primed { refresh() }
            case .possible, .began, .changed, .failed: break
            @unknown default:
                break
            }
        }
    }
}
