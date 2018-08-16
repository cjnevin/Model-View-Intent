import RxSwift
import RxCocoa

final class CounterComponent {
    private let disposeBag = DisposeBag()
    private let binder = Binder(CounterModel(), CounterView(), CounterIntent())
    let label = UILabel()
    let increment = UIButton()
    let decrement = UIButton()
    
    init() {
        label.textAlignment = .center
        
        increment.backgroundColor = .black
        increment.setTitleColor(.white, for: .normal)
        increment.setTitle("Increment Count", for: .normal)
        
        decrement.backgroundColor = .black
        decrement.setTitleColor(.white, for: .normal)
        decrement.setTitle("Decrement Count", for: .normal)
        
        disposeBag.insert(bindUI())
    }
    
    private func bindUI() -> Disposable {
        return CompositeDisposable(
            binder.bind(),
            increment.rx.tap.subscribe(binder.view.increment),
            decrement.rx.tap.subscribe(binder.view.decrement),
            binder.view.text.bind(to: label.rx.text))
    }
}

private struct CounterModel: Model {
    fileprivate let count = BehaviorSubject<Int>(value: 0)
    
    func observe(_ intent: CounterIntent) -> Disposable {
        let increment = intent.increment.map { _ in 1 }
        let decrement = intent.decrement.map { _ in -1 }
        return Observable
            .merge(increment, decrement)
            .startWith(0)
            .withLatestFrom(count) { $0 + $1 }
            .subscribe(count)
    }
}

private struct CounterView: View {
    fileprivate let text = BehaviorSubject<String>(value: "")
    fileprivate let increment = PublishSubject<Void>()
    fileprivate let decrement = PublishSubject<Void>()
    
    func observe(_ model: CounterModel) -> Disposable {
        return model.count.map({ "Count is now: \($0)" }).subscribe(text)
    }
}

private struct CounterIntent: Intent {
    fileprivate let increment = PublishSubject<Void>()
    fileprivate let decrement = PublishSubject<Void>()
    
    func observe(_ view: CounterView) -> Disposable {
        return CompositeDisposable(
            view.increment.subscribe(increment),
            view.decrement.subscribe(decrement))
    }
}
