pragma solidity ^0.4.24;
// produced by the Solididy File Flattener (c) David Appleton 2018
// contact : <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="6b0f0a1d0e2b0a000406090a45080406">[email protected]</a>
// released under Apache 2.0 licence
library SafeMath {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b)
        internal
        pure
        returns (uint256 c)
    {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        require(c / a == b, "SafeMath mul failed");
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b)
        internal
        pure
        returns (uint256)
    {
        require(b <= a, "SafeMath sub failed");
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b)
        internal
        pure
        returns (uint256 c)
    {
        c = a + b;
        require(c >= a, "SafeMath add failed");
        return c;
    }

    /**
     * @dev gives square root of given x.
     */
    function sqrt(uint256 x)
        internal
        pure
        returns (uint256 y)
    {
        uint256 z = ((add(x,1)) / 2);
        y = x;
        while (z < y)
        {
            y = z;
            z = ((add((x / z),z)) / 2);
        }
    }

    /**
     * @dev gives square. multiplies x by x
     */
    function sq(uint256 x)
        internal
        pure
        returns (uint256)
    {
        return (mul(x,x));
    }

    /**
     * @dev x to the power of y
     */
    function pwr(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        if (x==0)
            return (0);
        else if (y==0)
            return (1);
        else
        {
            uint256 z = x;
            for (uint256 i=1; i < y; i++)
                z = mul(z,x);
            return (z);
        }
    }
}
library UintCompressor {
    using SafeMath for *;

    function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)
        internal
        pure
        returns(uint256)
    {
        // check conditions
        require(_end < 77 && _start < 77, "start/end must be less than 77");
        require(_end >= _start, "end must be >= start");

        // format our start/end points
        _end = exponent(_end).mul(10);
        _start = exponent(_start);

        // check that the include data fits into its segment
        require(_include < (_end / _start));

        // build middle
        if (_include > 0)
            _include = _include.mul(_start);

        return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));
    }

    function extract(uint256 _input, uint256 _start, uint256 _end)
            internal
            pure
            returns(uint256)
    {
        // check conditions
        require(_end < 77 && _start < 77, "start/end must be less than 77");
        require(_end >= _start, "end must be >= start");

        // format our start/end points
        _end = exponent(_end).mul(10);
        _start = exponent(_start);

        // return requested section
        return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);
    }

    function exponent(uint256 _position)
        private
        pure
        returns(uint256)
    {
        return((10).pwr(_position));
    }
}