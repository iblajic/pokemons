@testable import Pokemons
import XCTest

class StringTests: XCTestCase {
    func testCapitalizingFirstLetterEmpty() {
        XCTAssertEqual("".capitalizingFirstLetter(), "")
    }

    func testCapitalizingFirstLetterAllLowercased() {
        XCTAssertEqual("ditto".capitalizingFirstLetter(), "Ditto")
    }

    func testCapitalizingFirstLetterAllUppercased() {
        XCTAssertEqual("DITTO".capitalizingFirstLetter(), "DITTO")
    }

    func testCapitalizingFirstLetterMixedCaseFirstUppercased() {
        XCTAssertEqual("DiTTo".capitalizingFirstLetter(), "DiTTo")
    }

    func testCapitalizingFirstLetterMixedCaseFirstLowercased() {
        XCTAssertEqual("dITtO".capitalizingFirstLetter(), "DITtO")
    }
}
