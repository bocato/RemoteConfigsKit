import Foundation

// MARK: - Feature Flag Constraint

public protocol FeatureFlagType: DynamicValue where Data == Bool {}
public extension FeatureFlagType {
    static var defaultValue: Bool { false }
}
