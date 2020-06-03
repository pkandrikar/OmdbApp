
import Foundation
struct SearchResult_Base : Codable {
	let search : [SearchItem]?
	let totalResults : String?
	let response : String?

	enum CodingKeys: String, CodingKey {

		case search = "Search"
		case totalResults = "totalResults"
		case response = "Response"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		search = try values.decodeIfPresent([SearchItem].self, forKey: .search)
		totalResults = try values.decodeIfPresent(String.self, forKey: .totalResults)
		response = try values.decodeIfPresent(String.self, forKey: .response)
	}

}
