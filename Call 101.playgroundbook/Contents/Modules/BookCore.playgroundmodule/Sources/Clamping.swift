@propertyWrapper
public struct Clamping<V: Comparable> {
    public var value: V
    public let min: V
    public let max: V
    
    public init(wrappedValue: V, min: V, max: V) {
        value = wrappedValue
        self.min = min
        self.max = max
        assert(value >= min && value <= max)
    }
    
    public var wrappedValue: V {
        get { return value }
        set {
            if newValue < min {
                value = min
            } else if newValue > max {
                value = max
            } else {
                value = newValue
            }
        }
    }
}
