import Foundation
import RxSwift

protocol Model {
    associatedtype Intent
    func observe(_ intent: Intent) -> Disposable
}

protocol View {
    associatedtype Model
    func observe(_ model: Model) -> Disposable
}

protocol Intent {
    associatedtype View
    func observe(_ view: View) -> Disposable
}

struct Binder<M: Model, V: View, I: Intent> where M.Intent == I, V.Model == M, I.View == V {
    private let model: M
    let view: V
    private let intent: I
    
    init(_ model: M, _ view: V, _ intent: I) {
        self.model = model
        self.view = view
        self.intent = intent
    }
    
    func bind() -> Disposable {
        return CompositeDisposable(
            model.observe(intent),
            view.observe(model),
            intent.observe(view))
    }
}
