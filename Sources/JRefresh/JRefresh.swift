// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public enum JRefreshState {
    case refreshing
    case success
    case error
}

public struct JRefreshView<Content: View, IndicatorView: View>: View {
    public typealias JRefreshAction = () -> Void
    public typealias JRefreshIndicator = (CGFloat, JRefreshState?) -> IndicatorView

    @Namespace var animationNS
    @Binding public var refreshState: JRefreshState?

    let content: Content
    let indicatorView: JRefreshIndicator
    let refreshAction: JRefreshAction
    let dismissDelay: TimeInterval
    let pullThreshold: CGFloat
    let indicatorSpaceHeight: CGFloat
    @State var indicatorState: IndicatorState = .normal
    @State var offset: CGFloat = 0
    @State var indicatorScrollHeight: CGFloat = 0

    public var body: some View {
        Group {
            if #available(iOS 18.0, *) {
                scrollView()
            } else {
                scrollViewPanGesture()
            }
        }
        .overlay(alignment: .top) {
            ZStack(alignment: .top) {
                VStack {
                    indicatorView(offset, refreshState)
                        .transition(.opacity)
                }
                .frame(maxHeight: indicatorSpaceHeight)
                .opacity(offset > 10 ? 1 : ((offset < 0 ? 0 : offset) / 10.0))
            }
        }
        .onPreferenceChange(IndicatorOffsetKey.self, perform: onScroll)
        .onChange(of: refreshState, perform: onRefreshChange)
    }

    public init(
        refreshState: Binding<JRefreshState?>,
        pullThreshold: CGFloat,
        indicatorSpaceHeight: CGFloat,
        dismissDelay: TimeInterval = 2,
        refreshAction: @escaping JRefreshAction,
        @ViewBuilder indicatorView: @escaping JRefreshIndicator,
        @ViewBuilder content: () -> Content
    ) {
        self._refreshState = refreshState
        self.pullThreshold = pullThreshold
        self.indicatorSpaceHeight = indicatorSpaceHeight
        self.dismissDelay = dismissDelay
        self.refreshAction = refreshAction
        self.content = content()
        self.indicatorView = indicatorView
    }

    func refresh() {
        guard indicatorState != .loading else { return }
        indicatorState = .loading
        if #available (iOS 18.0, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation(.smooth) {
                    indicatorScrollHeight = indicatorSpaceHeight
                }
            }
        } else {
            DispatchQueue.main.async {
                indicatorScrollHeight = indicatorSpaceHeight
            }
        }
        refreshState = .refreshing
        refreshAction()
    }

    func reset() {
        indicatorState = .normal
        offset = 0
        refreshState = nil
        indicatorScrollHeight = 0
    }
}

extension JRefreshView {
    func onScroll(_ offsetY: CGFloat) {
        print(offsetY)
        switch indicatorState {
        case .loading, .finished:
            break
        default:
            self.offset = offsetY
            indicatorState = offsetY > indicatorSpaceHeight ? .primed : .normal
        }
    }

    func onRefreshChange(_ result: JRefreshState?) {
        guard indicatorState == .loading,
              let result = result,
              result != .refreshing else { return }
        indicatorState = .finished(isSuccess: result == .success)
        DispatchQueue.main.asyncAfter(deadline: .now() + dismissDelay) {
            withAnimation { reset() }
        }
    }

}
