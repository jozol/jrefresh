import SwiftUI

#Preview {
    struct RotatingIndicator: View {
        @State private var isRotating = false

        var body: some View {
            Image(systemName: "arrow.2.circlepath")
                .rotationEffect(.degrees(isRotating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 1).repeatForever(autoreverses: false),
                    value: isRotating
                )
                .onAppear { isRotating = true }
        }
    }

    struct PreviewWrapper: View {
        @State var refreshState: JRefreshState? = nil

        var body: some View {
            JRefreshView(
                refreshState: $refreshState,
                pullThreshold: 48,
                indicatorSpaceHeight: 32) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: onRefresh)
                } indicatorView: { offset, state in
                    switch state {
                    case .error:
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    case .success:
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    case .refreshing:
                        RotatingIndicator()
                    case .none:
                        Image(systemName: "arrow.2.circlepath")
                            .rotationEffect(.degrees(offset))
                    }
                } content: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 200, height: 200)
                        .overlay {
                            Text("Content")
                        }
                }

        }

        func onRefresh() {
            refreshState = Bool.random() ? .success : .error
        }
    }

    return PreviewWrapper()
}
