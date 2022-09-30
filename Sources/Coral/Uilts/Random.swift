struct Random {
    static func urandom(length: Int) -> [UInt8] {
        var randomUInts = [UInt8]()
        for _ in 0..<length {
            randomUInts.append(UInt8.random(in: 0..<UInt8.max))
        }
        return randomUInts
    }
}
