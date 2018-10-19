library RGBAHexRegex {
    struct State {
        bool accepts;
        function (byte) pure internal returns (State memory) func;
    }
    //Only #RRGGBBAA
    string public constant regex = "#(([0-9a-fA-F]{2}){4})";

    function s0(byte c) pure internal returns (State memory) {
        c = c;
        return State(false, s0);
    }

    function s1(byte c) pure internal returns (State memory) {
        if (c == 35) {
            return State(false, s2);
        }

        return State(false, s0);
    }

    function s2(byte c) pure internal returns (State memory) {
        if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
            return State(false, s3);
        }

        return State(false, s0);
    }

    function s3(byte c) pure internal returns (State memory) {
        if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
            return State(false, s4);
        }

        return State(false, s0);
    }

    function s4(byte c) pure internal returns (State memory) {
        if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
            return State(false, s5);
        }

        return State(false, s0);
    }

    function s5(byte c) pure internal returns (State memory) {
        if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
            return State(false, s6);
        }

        return State(false, s0);
    }

    function s6(byte c) pure internal returns (State memory) {
        if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
            return State(false, s7);
        }

        return State(false, s0);
    }

    function s7(byte c) pure internal returns (State memory) {
        if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
            return State(false, s8);
        }

        return State(false, s0);
    }

    function s8(byte c) pure internal returns (State memory) {
        if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
            return State(false, s9);
        }

        return State(false, s0);
    }

    function s9(byte c) pure internal returns (State memory) {
        if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {
            return State(true, s10);
        }

        return State(false, s0);
    }

    function s10(byte c) pure internal returns (State memory) {
        // silence unused var warning
        c = c;

        return State(false, s0);
    }

    function matches(string input) public pure returns (bool) {
        State memory cur = State(false, s1);

        for (uint i = 0; i < bytes(input).length; i++) {
            byte c = bytes(input)[i];

            cur = cur.func(c);
        }

        return cur.accepts;
    }
}