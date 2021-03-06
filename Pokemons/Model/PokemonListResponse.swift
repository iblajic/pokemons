struct PokemonListResponseItem: Decodable {
    let name: String
    let url: String
}

struct PokemonListResponse: Decodable {
    let next: String?
    let results: [PokemonListResponseItem]
}

extension PokemonListResponseItem {
    func toPokemonListItem() -> PokemonListItem {
        return PokemonListItem(name: name.capitalizingFirstLetter(),
                               detailsUrl: url)
    }
}
