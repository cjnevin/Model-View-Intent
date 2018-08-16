import RxSwift
import RxCocoa

final class ElapsedComponent {
    private let disposeBag = DisposeBag()
    private let binder = Binder(ElapsedModel(), ElapsedView(), ElapsedIntent())
    let label = UILabel()
    let reset = UIButton()
    
    init() {
        label.textAlignment = .center
        
        reset.backgroundColor = .black
        reset.setTitleColor(.white, for: .normal)
        reset.setTitle("Reset Elapsed Time", for: .normal)
        
        disposeBag.insert(bindUI())
    }
    
    private func bindUI() -> Disposable {
        return CompositeDisposable(
            binder.bind(),
            reset.rx.tap.subscribe(binder.view.reset),
            binder.view.text.bind(to: label.rx.text))
    }
}

private struct ElapsedModel: Model {
    fileprivate let seconds = BehaviorSubject<Int>(value: 0)
    
    private func timer() -> Observable<Int> {
        return Observable<Int>.timer(0, period: 1, scheduler: MainScheduler.asyncInstance)
    }
    
    func observe(_ intent: ElapsedIntent) -> Disposable {
        return intent.reset
            .startWith(())
            .flatMapLatest { _ in self.timer() }
            .subscribe(seconds)
    }
}

private struct ElapsedView: View {
    fileprivate let text = BehaviorSubject<String>(value: "")
    fileprivate let reset = PublishSubject<Void>()
    
    private func elapsed(_ seconds: Int) -> String {
        return "Seconds elapsed: \(seconds)"
    }
    
    func observe(_ model: ElapsedModel) -> Disposable {
        return model.seconds.map(elapsed).subscribe(text)
    }
}

private struct ElapsedIntent: Intent {
    fileprivate let reset = PublishSubject<Void>()
    
    func observe(_ view: ElapsedView) -> Disposable {
        return view.reset.subscribe(reset)
    }
}
