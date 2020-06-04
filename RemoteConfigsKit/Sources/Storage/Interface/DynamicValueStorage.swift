import Foundation
import RemoteConfigsKitInterface

protocol DynamicValueStorage {
    var identifier: String { get }

    func get<T: DynamicValue>(_: T.Type) -> T.Data?
    func get(dynamicValue: String) -> String?
    func override<T: DynamicValue>(_: T.Type, with value: T.Data) throws
    func set(dynamicVariable: String, with value: String)
    func clear(dynamicVariable: String)
    func reset()
}
