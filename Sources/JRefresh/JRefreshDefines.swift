import SwiftUICore

enum IndicatorState: Equatable {
    case normal
    case primed
    case loading
    case finished(isSuccess: Bool)
}

struct IndicatorOffsetKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

extension CoordinateSpace {
    static let nameSpace = "JRefreshIndicatorOffsetKey"
    static var jRefreshCoordinateSpace: CoordinateSpace {
        .named("JRefreshIndicatorOffsetKey")
    }
}
