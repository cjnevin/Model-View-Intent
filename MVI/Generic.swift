import Foundation

protocol Model {
    associatedtype Intent
    func observe(_ intent: Intent)
}

protocol View {
    associatedtype Model
    func observe(_ model: Model)
}

protocol Intent {
    associatedtype View
    func observe(_ view: View)
}

struct Binder<M: Model, V: View, I: Intent> where M.Intent == I, V.Model == M, I.View == V {
    private let model: M
    let view: V
    private let intent: I
    
    init(_ model: M, _ view: V, _ intent: I) {
        self.model = model
        self.view = view
        self.intent = intent
        self.bind()
    }
    
    private func bind() {
        model.observe(intent)
        view.observe(model)
        intent.observe(view)
    }
}
