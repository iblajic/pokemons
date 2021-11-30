@testable import Pokemons
import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

class PokemonListViewModelTests: XCTestCase {
    var provider: PokemonProviderMock!
    var navigator: PokemonNavigatorMock!
    var viewModel: PokemonListViewModelType!
    var scheduler: TestScheduler!
    var bag: DisposeBag!

    override func setUpWithError() throws {
        provider = PokemonProviderMock()
        navigator = PokemonNavigatorMock()
        viewModel = PokemonListViewModel(provider: provider, navigator: navigator)
        scheduler = TestScheduler(initialClock: 0)
        bag = DisposeBag()
    }

    func testLoadingItems() throws {
        let listBottomReached = scheduler.createColdObservable([
            .next(1, ()),
            .next(2, ()),
            .next(3, ())
        ])
        .asDriver(onErrorJustReturn: ())

        let output = viewModel.transform(input: PokemonListViewModelInput(itemSelected: .never(),
                                                                          listBottomReached: listBottomReached))

        let pokemonList = scheduler.createObserver([PokemonListItem].self)

        output.pokemonList
            .drive(pokemonList)
            .disposed(by: bag)

        scheduler.start()

        XCTAssertEqual(pokemonList.events, [
            .next(0, PokemonListResponse.stub1PokemonListItems()),
            .next(1, PokemonListResponse.stub1PokemonListItems() + PokemonListResponse.stub2PokemonListItems()),
            .next(2, PokemonListResponse.stub1PokemonListItems() + PokemonListResponse.stub2PokemonListItems() + PokemonListResponse.stub3PokemonListItems()),
        ])
    }

    func testLoadingItemsFailure() throws {
        provider.getPokemonListFailure = true

        let output = viewModel.transform(input: PokemonListViewModelInput(itemSelected: .never(),
                                                                          listBottomReached: .never()))

        XCTAssertEqual(try output.pokemonList.toBlocking().first(), [])
    }

    func testSelectingItems() throws {
        let selectItem = scheduler.createHotObservable([
            .next(1, 2),
            .next(2, 0),
            .next(3, 7)
        ])
        .asDriver(onErrorJustReturn: 0)

        let output = viewModel.transform(input: PokemonListViewModelInput(itemSelected: selectItem,
                                                                          listBottomReached: .never()))

        let pokemonList = scheduler.createObserver([PokemonListItem].self)
        let itemSelected = scheduler.createObserver(Void.self)

        output.pokemonList
            .drive(pokemonList)
            .disposed(by: bag)

        output.itemSelected
            .drive(itemSelected)
            .disposed(by: bag)

        scheduler.start()

        XCTAssertEqual(navigator.toPokemonDetailsCallsCount, 2)
        XCTAssertEqual(navigator.toPokemonDetailsReceivedInvocations.first?.0, PokemonListResponse.stub1().results[2].name.capitalizingFirstLetter())
        XCTAssertEqual(navigator.toPokemonDetailsReceivedInvocations.first?.1, PokemonListResponse.stub1().results[2].url)
        XCTAssertEqual(navigator.toPokemonDetailsReceivedInvocations.last?.0, PokemonListResponse.stub1().results[0].name.capitalizingFirstLetter())
        XCTAssertEqual(navigator.toPokemonDetailsReceivedInvocations.last?.1, PokemonListResponse.stub1().results[0].url)
    }
}
