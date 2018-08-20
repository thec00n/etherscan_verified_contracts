/// @title Token Register Contract
/// @author Daniel Wang - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="82e6e3ecebe7eec2eeededf2f0ebece5acedf0e5">[email protected]</a>>.
library ErrorLib {

    event Error(string message);

    /// @dev Check if condition hold, if not, log an exception and revert.
    function orThrow(bool condition, string message) public constant {
        if (!condition) {
            error(message);
        }
    }

    function error(string message) public constant {
        Error(message);
        revert();
    }
}