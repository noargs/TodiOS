import Foundation

// used to be 'class Item: Encodable, Decodable' untill swift 4
class Item: Codable {
    var title : String = ""
    var done : Bool = false
}
