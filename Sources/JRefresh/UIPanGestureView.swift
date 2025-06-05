import SwiftUI

struct UIPanGestureViewHosting<Content: View>: UIViewRepresentable {
    let content: Content
    let onPan: (UIPanGestureRecognizer) -> Void

    init(@ViewBuilder content: () -> Content, onPan: @escaping (UIPanGestureRecognizer) -> Void) {
        self.content = content()
        self.onPan = onPan
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onPan: onPan)
    }

    func makeUIView(context: Context) -> UIView {
        let hosting = UIHostingController(rootView: content)
        hosting.sizingOptions = .intrinsicContentSize
        context.coordinator.hosting = hosting
        let view = UIView()
        view.backgroundColor = .clear
        let panGR = UIPanGestureRecognizer(target: context.coordinator,
                                           action: #selector(Coordinator.handlePan(_:)))
        panGR.delegate = context.coordinator
        view.addGestureRecognizer(panGR)
        if let contentView = hosting.view {
            contentView.backgroundColor = .clear
            contentView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(contentView)
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: view.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }
        view.layoutIfNeeded()
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.hosting?.rootView = content
        if let hostView = context.coordinator.hosting?.view {
            hostView.backgroundColor = .clear
            hostView.setNeedsLayout()
            hostView.layoutIfNeeded()
        }
    }

    // MARK: - Coordinator
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var hosting: UIHostingController<Content>?
        let onPan: (UIPanGestureRecognizer) -> Void

        init(onPan: @escaping (UIPanGestureRecognizer) -> Void) {
            self.onPan = onPan
        }

        @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
            onPan(recognizer)
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                               shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}
