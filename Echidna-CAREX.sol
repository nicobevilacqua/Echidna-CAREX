// SPDX-License-Identifier: BSD-4-Clause
pragma solidity ^0.8.1;

import "ABDKMath64x64.sol";

contract Test {
    int128 internal zero = ABDKMath64x64.fromInt(0);
    int128 internal one = ABDKMath64x64.fromInt(1);

    int128 private constant MIN_64x64 = -0x80000000000000000000000000000000;
    int128 private constant MAX_64x64 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    int128 private constant MAX_TRUNCATED = 1 << 64;

    event ValueInt64(string, int64);
    event ValueInt128(string, int128);
    event ValueInt256(string, int256);
    event ValueUInt256(string, uint256);

    function debugInt64(string memory message, int64 value) private {
        emit ValueInt64(message, value);
    }

    function debugInt128(string memory message, int128 value) private {
        emit ValueInt128(message, value);
    }

    function debugInt256(string memory message, int256 value) private {
        emit ValueInt256(message, value);
    }

    function debugUInt256(string memory message, uint256 value) private {
        emit ValueUInt256(message, value);
    }

    function add(int128 x, int128 y) private pure returns (int128) {
        return ABDKMath64x64.add(x, y);
    }

    function sub(int128 x, int128 y) private pure returns (int128) {
        return ABDKMath64x64.sub(x, y);
    }

    function mul(int128 x, int128 y) private pure returns (int128) {
        return ABDKMath64x64.mul(x, y);
    }

    function muli(int128 x, int256 y) private pure returns (int256) {
        return ABDKMath64x64.muli(x, y);
    }

    function mulu(int128 x, uint256 y) private pure returns (uint256) {
        return ABDKMath64x64.mulu(x, y);
    }

    function div(int128 x, int128 y) private pure returns (int128) {
        return ABDKMath64x64.div(x, y);
    }

    function divi(int256 x, int256 y) private pure returns (int128) {
        return ABDKMath64x64.divi(x, y);
    }

    function divu(uint256 x, uint256 y) private pure returns (int128) {
        return ABDKMath64x64.divu(x, y);
    }

    function neg(int128 x) private pure returns (int128) {
        return ABDKMath64x64.neg(x);
    }

    function abs(int128 x) private pure returns (int128) {
        return ABDKMath64x64.abs(x);
    }

    function inv(int128 x) private pure returns (int128) {
        return ABDKMath64x64.inv(x);
    }

    function avg(int128 x, int128 y) private pure returns (int128) {
        return ABDKMath64x64.avg(x, y);
    }

    function gavg(int128 x, int128 y) private pure returns (int128) {
        return ABDKMath64x64.gavg(x, y);
    }

    function pow(int128 x, uint256 y) private pure returns (int128) {
        return ABDKMath64x64.pow(x, y);
    }

    function sqrt(int128 x) private pure returns (int128) {
        return ABDKMath64x64.sqrt(x);
    }

    function log_2(int128 x) private pure returns (int128) {
        return ABDKMath64x64.log_2(x);
    }

    function ln(int128 x) private pure returns (int128) {
        return ABDKMath64x64.ln(x);
    }

    function exp_2(int128 x) private pure returns (int128) {
        return ABDKMath64x64.exp_2(x);
    }

    function exp(int128 x) private pure returns (int128) {
        return ABDKMath64x64.exp(x);
    }

    function fromInt(int256 x) private pure returns (int128) {
        return ABDKMath64x64.fromInt(x);
    }

    function toInt(int128 x) private pure returns (int128) {
        return ABDKMath64x64.toInt(x);
    }

    function fromUInt(uint256 x) private pure returns (int128) {
        return ABDKMath64x64.fromUInt(x);
    }

    function toUInt(int128 x) private pure returns (uint64) {
        return ABDKMath64x64.toUInt(x);
    }

    function from128x128(int256 x) private pure returns (int128) {
        return ABDKMath64x64.from128x128(x);
    }

    function to128x128(int128 x) private pure returns (int256) {
        return ABDKMath64x64.to128x128(x);
    }

    function testAdd(
        int128 x,
        int128 y,
        int128 z
    ) public pure {
        int128 r1 = add(x, y);
        int128 r2 = add(r1, z);
        assert(r1 == x + y);
        assert(r2 == x + y + z);
        assert(r2 - z == r1);

        assert(add(x, -x) == 0);
        assert(add(-x, x) == 0);
        assert(add(x, x) == x * 2);
    }

    function testSub(
        int128 x,
        int128 y,
        int128 z
    ) public {
        int128 r1 = sub(x, y);
        int128 r2 = sub(r1, z);
        assert(r1 == x - y);
        assert(r2 == r1 - z);

        debugInt128("r1", r1);
        debugInt128("r2", r2);

        assert(sub(x, x) == 0);
        assert(sub(-x, x) == -(x * 2));
    }

    function testMul(int128 x, int128 y) public {
        int128 response = mul(x, y);
        int256 expected = int256(x) * y;

        debugInt128("response", response);
        debugInt256("expected", expected);

        assert(int256(response) << 64 <= expected);
        assert(mul(x, 0) == 0);
        assert(mul(0, x) == 0);
        assert(mul(-x, -x) == mul(x, x));
    }

    function testMuli(int128 x, int256 y) public pure {
        if (x == 0 || y == 0) {
            assert(muli(x, y) == 0);
            return;
        }

        int256 result = muli(x, y);

        int128 expected = int128((result / y) << 64);

        int128 difference = abs(x) - abs(expected);

        assert(difference <= MAX_TRUNCATED);

        assert(muli(x, 0) == 0);
        assert(muli(0, y) == 0);
    }

    function testMulu(int128 x, uint256 y) public pure {
        if (x == 0 || y == 0) {
            assert(mulu(x, y) == 0);
            return;
        }

        uint256 result = mulu(x, y);
        uint256 expected = result / y;

        if (x > 0) {
            assert(int256(x >> 64) - int256(expected) <= MAX_TRUNCATED);
        } else {
            assert(-int256(x >> 64) - int256(expected) <= MAX_TRUNCATED);
        }

        assert(mulu(x, 0) == 0);
        assert(mulu(0, y) == 0);
    }

    function testDiv(int128 x, int128 y) public pure {
        int128 result = div(x, y);
        int128 expected = int128((int256(result) * y) >> 64);
        assert(abs(x) - abs(expected) <= MAX_TRUNCATED);
    }

    function testDivAndMul(int128 x, int128 y) public pure {
        int128 r = div(x, y);
        int128 x2 = mul(r, y);
        assert(abs(x) - abs(x2) <= MAX_TRUNCATED);
    }

    function testDivi(int256 x, int256 y) public {
        int128 result = divi(x, y);
        int128 expected = int128((x / y) << 64);

        assert(abs(expected) - abs(result) <= MAX_TRUNCATED);
    }

    function testDivu(uint256 x, uint256 y) public pure {
        int128 response = divu(x, y);

        if (x < y) {
            assert(response <= MAX_TRUNCATED);
        } else {
            uint256 t = uint256(int256(response)) * y;
            assert(int256(x - (t >> 64)) <= MAX_TRUNCATED);
        }
    }

    function testNeg(int128 x) public pure {
        int128 o = neg(x);
        assert(o + x == 0);
    }

    function testAbs(int128 x) public pure {
        int128 r = abs(x);
        if (x > 0) {
            assert(r == x);
        } else if (x < 0) {
            assert(r == -x);
        } else {
            assert(r == 0);
        }
    }

    function testInv(int128 x) public pure {
        int128 r = inv(x);
        assert(r * x == 1);
    }

    function testAvg(int128 x, int128 y) public pure {
        int128 result = avg(x, y);
        int256 expected = (int256(x) + int256(y)) / 2;
        if (result >= 0) {
            assert(expected - result <= MAX_TRUNCATED);
        } else {
            assert(-expected + result <= MAX_TRUNCATED);
        }
    }

    /*
    function testGavg(int128 x, int128 y) public pure {
        int128 result = gavg(x, y);
        assert((int256(x) * y) >= 0);
    }

    // pow function returns 0 everytime
    function testPow(int128 x, uint256 y) public pure {
        assert(true);
        require(x > 0);
        require(x != 1);
        int128 result = pow(x, y);
        assert(result > 0);
    }
    */

    function testSqrt(int128 x) public pure {
        int128 result = sqrt(x);
        assert(x - int256(result)**2 <= MAX_TRUNCATED);
    }

    function testLog2(int128 x) public pure {
        int128 result = log_2(x);
        int128 expected = int128(uint128(2)**uint128(result));
        assert(abs(x) - abs(expected) <= MAX_TRUNCATED);
    }

    function testLn(int128 x) public pure {
        int128 result = ln(x);
        assert(exp(result) - x <= MAX_TRUNCATED);
    }

    function testExp2(int128 x) public pure {
        int128 result = exp_2(x);
        int128 restored = log_2(result);
        assert(abs(result) - abs(restored) <= MAX_TRUNCATED);
    }

    function testExp(int128 x) public pure {
        int128 result = exp(x);
        assert(ln(result) - x <= MAX_TRUNCATED);
    }

    function testFromInt(int256 x) public pure {
        int128 result = fromInt(x);
        assert(int128(x) == result >> 64);
    }

    function testToInt(int128 x) public pure {
        int128 result = toInt(x);
        assert(x >> 64 == result);
    }

    function testFromUInt(uint256 x) public pure {
        int128 result = fromUInt(x);
        assert(int256(x) == int256(result >> 64));
    }

    function testToUInt(int128 x) public pure {
        uint64 result = toUInt(x);
        assert(uint128(x >> 64) == uint128(result));
    }

    function testFrom128x128(int256 x) public pure {
        int128 result = from128x128(x);
        int256 truncated = int256(result) << 64;
        if (x >= 0) {
            assert(x - truncated <= MAX_TRUNCATED);
        } else {
            assert(x + -truncated <= MAX_TRUNCATED);
        }
    }

    function testTo128x128(int128 x) public pure {
        int256 result = to128x128(x);
        int128 truncated = int128(result >> 64);
        assert(x == truncated);
    }
}
