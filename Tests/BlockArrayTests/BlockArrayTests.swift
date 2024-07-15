import XCTest
@testable import BlockArray

final class BlockArrayTests: XCTestCase {
    func testAppendAndSubscript() {
        var listArray = BlockArray<Int>()
        listArray.append(1)
        listArray.append(2)
        listArray.append(3)

        XCTAssertEqual(listArray[0], 1)
        XCTAssertEqual(listArray[1], 2)
        XCTAssertEqual(listArray[2], 3)
    }

    func testPopLast() {
        var listArray = BlockArray<Int>()
        listArray.append(1)
        listArray.append(2)
        listArray.append(3)

        XCTAssertEqual(listArray.popLast(), 3)
        XCTAssertEqual(listArray.popLast(), 2)
        XCTAssertEqual(listArray.popLast(), 1)
        XCTAssertNil(listArray.popLast())
    }



    func testSubscriptSet() {
        var listArray = BlockArray<Int>()
        listArray.append(1)
        listArray.append(2)
        listArray.append(3)

        listArray[1] = 5
        XCTAssertEqual(listArray[1], 5)
    }

    func testIlog2() {
        XCTAssertEqual(ilog2(1), 0)
        XCTAssertEqual(ilog2(2), 1)
        XCTAssertEqual(ilog2(4), 2)
        XCTAssertEqual(ilog2(8), 3)
        XCTAssertEqual(ilog2(16), 4)
    }

    func testDividedCeil() {
        XCTAssertEqual(dividedCeil(10, by: 3), 4)
        XCTAssertEqual(dividedCeil(9, by: 3), 3)
        XCTAssertEqual(dividedCeil(0, by: 1), 0)
        XCTAssertEqual(dividedCeil(1, by: 1), 1)
    }

    func testAppendPopLast() {
        print("Test started")
        var listArray = BlockArray<Int>()
        print("Test")
        for i in 0..<500 {
            listArray.append(i)
        }

        for i in 0..<500{
            XCTAssertEqual(i, listArray[i])
        }

        for i in stride(from: 499, through: 0, by: -1) {
            XCTAssertEqual(i, listArray.popLast())
        }
    }

    // New interleaved push and pop tests
    func testInterleavedPushPop1() {
        var listArray = BlockArray<Int>()
        listArray.append(1)
        listArray.append(2)
        listArray.append(3)

        XCTAssertEqual(listArray.popLast(), 3)
        listArray.append(4)

        XCTAssertEqual(listArray[0], 1)
        XCTAssertEqual(listArray[1], 2)
        XCTAssertEqual(listArray[2], 4)
    }

    func testInterleavedPushPop2() {
        var listArray = BlockArray<Int>()
        listArray.append(1)
        XCTAssertEqual(listArray.popLast(), 1)
        listArray.append(2)
        listArray.append(3)

        XCTAssertEqual(listArray[0], 2)
        XCTAssertEqual(listArray[1], 3)

        XCTAssertEqual(listArray.popLast(), 3)
        XCTAssertEqual(listArray.popLast(), 2)
        XCTAssertNil(listArray.popLast())
    }

    func testInterleavedPushPop3() {
        var listArray = BlockArray<Int>()
        for i in 1...10 {
            listArray.append(i)
        }

        XCTAssertEqual(listArray.popLast(), 10)
        XCTAssertEqual(listArray.popLast(), 9)

        listArray.append(11)
        listArray.append(12)

        XCTAssertEqual(listArray[7], 8)
        XCTAssertEqual(listArray[8], 11)
        XCTAssertEqual(listArray[9], 12)
    }

    func testInterleavedPushPop4() {
        var listArray = BlockArray<Int>()
        for i in 1...5 {
            listArray.append(i)
        }

        XCTAssertEqual(listArray.popLast(), 5)
        listArray.append(6)
        XCTAssertEqual(listArray.popLast(), 6)
        XCTAssertEqual(listArray.popLast(), 4)

        listArray.append(7)
        XCTAssertEqual(listArray[2], 3)
        XCTAssertEqual(listArray[3], 7)
    }

    func testInterleavedPushPop5() {
        var listArray = BlockArray<Int>()
        for i in 1...20 {
            listArray.append(i)
        }

        for _ in 1...10 {
            XCTAssertNotNil(listArray.popLast())
        }

        XCTAssertEqual(listArray[0], 1)
        XCTAssertEqual(listArray[9], 10)

        for i in 21...30 {
            listArray.append(i)
        }

        XCTAssertEqual(listArray[10], 21)
        XCTAssertEqual(listArray[19], 30)
    }

    func testRandomizedPushPop() {
        var listArray = BlockArray<Int>()
        var referenceArray = [Int]()
        let seed = UInt64.random(in: 0...UInt64.max)
        var rng = SystemRandomNumberGenerator()
        print("Randomization seed: \(seed)")

        let numberOfOperations = 1000000
        for _ in 0..<numberOfOperations {
            if Bool.random(using: &rng) {
                // Perform push
                let value = Int.random(in: 0...1000, using: &rng)
                listArray.append(value)
                referenceArray.append(value)
            } else {
                // Perform pop
                let expected = referenceArray.popLast()
                let result = listArray.popLast()
                XCTAssertEqual(result, expected)
            }
        }
    }

    // New interleaved push and pop tests with strings
    func testInterleavedPushPopStrings1() {
        var listArray = BlockArray<String>()
        listArray.append("one")
        listArray.append("two")
        listArray.append("three")

        XCTAssertEqual(listArray.popLast(), "three")
        listArray.append("four")

        XCTAssertEqual(listArray[0], "one")
        XCTAssertEqual(listArray[1], "two")
        XCTAssertEqual(listArray[2], "four")
    }

    func testInterleavedPushPopStrings2() {
        var listArray = BlockArray<String>()
        listArray.append("one")
        XCTAssertEqual(listArray.popLast(), "one")
        listArray.append("two")
        listArray.append("three")

        XCTAssertEqual(listArray[0], "two")
        XCTAssertEqual(listArray[1], "three")

        XCTAssertEqual(listArray.popLast(), "three")
        XCTAssertEqual(listArray.popLast(), "two")
        XCTAssertNil(listArray.popLast())
    }

    func testInterleavedPushPopStrings3() {
        var listArray = BlockArray<String>()
        let words = ["apple", "banana", "cherry", "date", "elderberry", "fig", "grape", "honeydew", "kiwi", "lemon"]
        for word in words {
            listArray.append(word)
        }

        XCTAssertEqual(listArray.popLast(), "lemon")
        XCTAssertEqual(listArray.popLast(), "kiwi")

        listArray.append("mango")
        listArray.append("nectarine")

        XCTAssertEqual(listArray[7], "honeydew")
        XCTAssertEqual(listArray[8], "mango")
        XCTAssertEqual(listArray[9], "nectarine")
    }

    func testInterleavedPushPopStrings4() {
        var listArray = BlockArray<String>()
        let words = ["apple", "banana", "cherry", "date", "elderberry"]
        for word in words {
            listArray.append(word)
        }

        XCTAssertEqual(listArray.popLast(), "elderberry")
        listArray.append("fig")
        XCTAssertEqual(listArray.popLast(), "fig")
        XCTAssertEqual(listArray.popLast(), "date")

        listArray.append("grape")
        XCTAssertEqual(listArray[2], "cherry")
        XCTAssertEqual(listArray[3], "grape")
    }

    func testInterleavedPushPopStrings5() {
        var listArray = BlockArray<String>()
        let words = (1...20).map { "word\($0)" }
        for word in words {
            listArray.append(word)
        }

        for _ in 1...10 {
            XCTAssertNotNil(listArray.popLast())
        }

        XCTAssertEqual(listArray[0], "word1")
        XCTAssertEqual(listArray[9], "word10")

        let newWords = (21...30).map { "word\($0)" }
        for word in newWords {
            listArray.append(word)
        }

        XCTAssertEqual(listArray[10], "word21")
        XCTAssertEqual(listArray[19], "word30")
    }

    // New randomized push and pop test with strings
    func testRandomizedPushPopStrings() {
        var listArray = BlockArray<String>()
        var referenceArray = [String]()
        let seed = UInt64.random(in: 0...UInt64.max)
        var rng = SystemRandomNumberGenerator()
        print("Randomization seed: \(seed)")

        let numberOfOperations = 100000
        for _ in 0..<numberOfOperations {
            if Bool.random(using: &rng) {
                // Perform push
                let value = String(Int.random(in: 0...1000, using: &rng))
                listArray.append(value)
                referenceArray.append(value)
            } else {
                // Perform pop
                let expected = referenceArray.popLast()
                let result = listArray.popLast()
                XCTAssertEqual(result, expected)
            }
        }
    }

    // Test count after multiple appends
    func testCountAfterAppends() {
        var listArray = BlockArray<Int>()
        XCTAssertEqual(listArray.count, 0)

        listArray.append(1)
        XCTAssertEqual(listArray.count, 1)

        listArray.append(2)
        XCTAssertEqual(listArray.count, 2)

        listArray.append(3)
        XCTAssertEqual(listArray.count, 3)
    }

    // Test count after appends and pops
    func testCountAfterAppendsAndPops() {
        var listArray = BlockArray<Int>()
        listArray.append(1)
        listArray.append(2)
        listArray.append(3)
        XCTAssertEqual(listArray.count, 3)

        _ = listArray.popLast()
        XCTAssertEqual(listArray.count, 2)

        _ = listArray.popLast()
        XCTAssertEqual(listArray.count, 1)

        _ = listArray.popLast()
        XCTAssertEqual(listArray.count, 0)

        _ = listArray.popLast()
        XCTAssertEqual(listArray.count, 0)
    }

    // Test count with interleaved push and pop operations
    func testCountWithInterleavedPushPop() {
        var listArray = BlockArray<Int>()
        listArray.append(1)
        XCTAssertEqual(listArray.count, 1)

        listArray.append(2)
        XCTAssertEqual(listArray.count, 2)

        _ = listArray.popLast()
        XCTAssertEqual(listArray.count, 1)

        listArray.append(3)
        XCTAssertEqual(listArray.count, 2)

        _ = listArray.popLast()
        XCTAssertEqual(listArray.count, 1)

        listArray.append(4)
        XCTAssertEqual(listArray.count, 2)

        listArray.append(5)
        XCTAssertEqual(listArray.count, 3)

        _ = listArray.popLast()
        XCTAssertEqual(listArray.count, 2)
    }

    // New randomized push and pop test with count verification
    func testRandomizedPushPopWithCount() {
        var listArray = BlockArray<Int>()
        var referenceArray = [Int]()
        let seed = UInt64.random(in: 0...UInt64.max)
        var rng = SystemRandomNumberGenerator()
        print("Randomization seed: \(seed)")

        let numberOfOperations = 100000
        for _ in 0..<numberOfOperations {
            if Bool.random(using: &rng) {
                // Perform push
                let value = Int.random(in: 0...1000, using: &rng)
                listArray.append(value)
                referenceArray.append(value)
            } else {
                // Perform pop
                _ = referenceArray.popLast()
                _ = listArray.popLast()
            }
            XCTAssertEqual(listArray.count, referenceArray.count)
        }
    }

    // New randomized push and pop test with count verification for strings
    func testRandomizedPushPopStringsWithCount() {
        var listArray = BlockArray<String>()
        var referenceArray = [String]()
        let seed = UInt64.random(in: 0...UInt64.max)
        var rng = SystemRandomNumberGenerator()
        print("Randomization seed: \(seed)")

        let numberOfOperations = 100000
        for _ in 0..<numberOfOperations {
            if Bool.random(using: &rng) {
                // Perform push
                let value = String(Int.random(in: 0...1000, using: &rng))
                listArray.append(value)
                referenceArray.append(value)
            } else {
                // Perform pop
                _ = referenceArray.popLast()
                _ = listArray.popLast()
            }
            XCTAssertEqual(listArray.count, referenceArray.count)
        }
    }

}
