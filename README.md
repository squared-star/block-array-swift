# 🏗️ BlockArray

`BlockArray` is a Swift library for resizable arrays optimized for both time and space. It leverages a multi-block data structure to provide efficient append and pop operations, while minimizing memory overhead.
An implementation of Resizable Arrays in Optimal Time and Space by Brodnik et al. to reduce copying overhead.

## Features

- **Dynamic Resizable Arrays**: `BlockArray` adapts to the number of elements by dynamically adjusting the size of internal data blocks.
- **Optimal Asymptotic Performance**: Implements efficient append and pop operations with a focus on minimizing space wastage and maintaining high performance.
- **Random Access**: Provides O(1) access to elements using subscripting.

## Acknowledgements

- Resizable Arrays in Optimal Time and Space by Brodnik et al.
- [u/WittyStick](https://www.reddit.com/user/WittyStick/)'s idea of applying a variation of
  RAOTS to persistent data structures
- [VList paper by Phil Bagwell](https://link.springer.com/chapter/10.1007/3-540-44854-3_3)

