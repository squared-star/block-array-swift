import Foundation
import Numerics

/// Calculates the integer base-2 logarithm of a given positive integer.
///
/// The function computes the position of the highest set bit in the integer's binary representation,
/// which corresponds to the integer base-2 logarithm.
///
/// - Parameter n: A positive integer whose base-2 logarithm is to be calculated.
/// - Returns: The integer base-2 logarithm of the given positive integer.
/// - Precondition: The input must be a positive integer. If the input is zero or negative, the function will trigger a runtime error.
///
/// Example usage:
/// ```swift
/// let number = 16
/// let result = ilog2(number)
/// print("ilog2(\(number)) = \(result)") // Output: ilog2(16) = 4
/// ```
func ilog2(_ n: Int) -> Int {
    precondition(n > 0, "Input must be a positive integer")
    return Int.bitWidth - n.leadingZeroBitCount - 1
}

/// Calculates the ceiling of the division of two integers.
///
/// This function computes the integer division of `x` by `y` and rounds up to the nearest integer if there is any remainder.
/// It ensures that the result is the smallest integer greater than or equal to the exact division result.
///
/// - Parameters:
///   - x: The dividend, an integer to be divided.
///   - y: The divisor, an integer by which to divide the dividend.
/// - Returns: The ceiling of the division of `x` by `y`.
/// - Precondition: The divisor `y` must not be zero, as division by zero is undefined and will cause a runtime error.
///
/// Example usage:
/// ```swift
/// let result = dividedCeil(10, by: 3)
/// print("dividedCeil(10, by: 3) = \(result)") // Output: dividedCeil(10, by: 3) = 4
/// ```
func dividedCeil(_ x: Int, by y: Int) -> Int {
    let q = x / y
    let r = x - q*y
    if r == 0 { return q }
    if y.signum() == r.signum() { return q+1 }
    return q
}

/// A dynamic array that uses multiple data blocks to store elements efficiently.
///
/// The `BlockArray` struct provides efficient append and pop operations by organizing elements into multiple data blocks.
/// Each data block's size is dynamically determined based on the number of existing blocks to optimize storage.
///
/// - Parameter Element: The type of elements stored in the array.
public struct BlockArray<Element> {
    var dataBlocks: ContiguousArray<ContiguousArray<Element>> = []
    
    var superBlockCount : Int8 = 0
    var elementCountForCurrentSuperBlock : Int = 0
    
    var currentSuperBlockIndex : Int8 {
        if superBlockCount == 0 {
            return 0
        }
        return superBlockCount - 1
    }
    
    var spareDataBlock: ContiguousArray<Element>? = nil
    
    var elementsPerDataBlockInCurrentSuperBlock : Int {
        1 << dividedCeil(Int(currentSuperBlockIndex), by: 2)
    }
    
    
    var fullDataBlocksInCurrentSuperBlock : Int {
        elementCountForCurrentSuperBlock / elementsPerDataBlockInCurrentSuperBlock
    }
    
    var dataBlockCountOfCurrentSuperBlock : Int {
        dividedCeil(elementCountForCurrentSuperBlock, by: elementsPerDataBlockInCurrentSuperBlock)
    }
    
    var lastDataBlockCount : Int {
        elementCountForCurrentSuperBlock % elementsPerDataBlockInCurrentSuperBlock
    }
    
    var dataBlockCapacityOfCurrentSuperBlock : Int {
        1 << (Int(currentSuperBlockIndex) / 2)
    }
    
    var currentSuperBlockCapacity : Int {
        if dataBlocks.isEmpty {
            return 0
        }
        return 1 << currentSuperBlockIndex
    }
    
    public var count : Int {
        if dataBlocks.isEmpty {
            return 0
        } else {
            let totalElementsInSuperBlocksPiorToCurrent = currentSuperBlockIndex != 0 ?  (1 << currentSuperBlockIndex) - 1 : 0
            return totalElementsInSuperBlocksPiorToCurrent + elementCountForCurrentSuperBlock
        }
    }
    
    public var isEmpty: Bool {
        dataBlocks.isEmpty || dataBlocks.first!.isEmpty
    }
    public init() {
        
    }
    
    /// Appends an item to the list array.
    ///
    /// This method adds an item to the last data block if there is capacity. If the last data block is full,
    /// it creates a new data block with a dynamically determined size and appends the item to it.
    ///
    /// - Parameter item: The item to append to the list array.
    public mutating func append(_ item: Element) {
        if dataBlocks.isEmpty {
            elementCountForCurrentSuperBlock = 1
            superBlockCount = 1
            dataBlocks.append([item])
        } else if dataBlocks.last!.count < dataBlocks.last!.capacity {
            elementCountForCurrentSuperBlock += 1
            dataBlocks[dataBlocks.count - 1].append(item)
        } else {
            if currentSuperBlockCapacity <= elementCountForCurrentSuperBlock {
                superBlockCount += 1
                elementCountForCurrentSuperBlock = 0
                
            }
            
            
            let dataBlockSize = elementsPerDataBlockInCurrentSuperBlock
            var newDataBlock: ContiguousArray<Element>
            if let spare = spareDataBlock {
                spareDataBlock = nil
                newDataBlock = consume spare
                newDataBlock.append(item)
            } else {
                newDataBlock = [item]
            }
            newDataBlock.reserveCapacity(dataBlockSize)
            assert(newDataBlock.capacity == dataBlockSize)
            dataBlocks.append(newDataBlock)
            elementCountForCurrentSuperBlock += 1
            return
        }
    }

    /// Removes and returns the last item from the list array.
    ///
    /// This method removes and returns the last item from the last data block. If the last data block becomes empty after the removal,
    /// it is removed from the list array. If the list array is empty, it returns `nil`.
    ///
    /// - Returns: The last item from the list array, or `nil` if the list array is empty.
    public mutating func popLast() -> Element? {
        if dataBlocks.isEmpty {
            return nil
        } else {
            let last = dataBlocks[dataBlocks.count - 1].popLast()
            if dataBlocks[dataBlocks.count - 1].isEmpty {
                spareDataBlock = dataBlocks.popLast()
                if elementCountForCurrentSuperBlock <= 1 {
                    superBlockCount -= 1
                    elementCountForCurrentSuperBlock = currentSuperBlockCapacity
                    if let last = last {
                        return last
                    }
                } else if let last = last {
                    elementCountForCurrentSuperBlock -= 1
                    return last
                }
                
            } else if let last = last {
                elementCountForCurrentSuperBlock -= 1
                return last
            }
            return popLast()
        }
    }

    func locate(at index: Int) -> (dataBlockIndex: Int, offset: Int) {
        precondition(index >= 0, "Index must be non-negative")
        let index = index + 1
        let superBlockIndex = ilog2(index)
        let l = dividedCeil(superBlockIndex, by: 2)
        let offsetInSuperBlock = (index & ~(1 << superBlockIndex)) >> l
        assert(offsetInSuperBlock >= 0)
        let offsetInDataBlock = index & ((1 << l) - 1)
        assert(offsetInDataBlock >= 0)
        let firstDataBlockInSuperBlock = 2 * ((1 << l) - 1) - (superBlockIndex % 2) * ((1 << l) / 2)
        assert(firstDataBlockInSuperBlock >= 0)
        return (dataBlockIndex: firstDataBlockInSuperBlock + offsetInSuperBlock, offset: offsetInDataBlock)
    }


    public borrowing func debug() {
        print(dataBlocks)
    }
    
    /// Accesses the element at the specified index.
    ///
    /// This subscript provides random access to elements in the list array. It calculates the appropriate data block and index
    /// within that block to retrieve the element.
    ///
    /// - Parameter index: The index of the element to access.
    /// - Returns: The element at the specified index.
    public subscript(_ index: Int) -> Element {
        get {
            let (dataBlockIndex, offset) = locate(at: index)
            return dataBlocks[dataBlockIndex][offset]
        }
        set {
            let (dataBlockIndex, offset) = locate(at: index)
            dataBlocks[dataBlockIndex][offset] = newValue
        }
    }
}





