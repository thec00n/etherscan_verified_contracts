contract ChineseCookies {

        address[] bakers;
        mapping(address =&gt; string[]) cookies;
        mapping(string =&gt; string) wishes;

        function ChineseCookies() {
                bakeCookie(&quot;A friend asks only for your time not your money.&quot;);
                bakeCookie(&quot;If you refuse to accept anything but the best, you very often get it.&quot;);
                bakeCookie(&quot;A smile is your passport into the hearts of others.&quot;);
                bakeCookie(&quot;A good way to keep healthy is to eat more Chinese food.&quot;);
                bakeCookie(&quot;Your high-minded principles spell success.&quot;);
                bakeCookie(&quot;Hard work pays off in the future, laziness pays off now.&quot;);
                bakeCookie(&quot;Change can hurt, but it leads a path to something better.&quot;);
                bakeCookie(&quot;Enjoy the good luck a companion brings you.&quot;);
                bakeCookie(&quot;People are naturally attracted to you.&quot;);
                bakeCookie(&quot;A chance meeting opens new doors to success and friendship.&quot;);
                bakeCookie(&quot;You learn from your mistakes... You will learn a lot today.&quot;);
        }

        function bakeCookie(string wish) {
                var cookiesCount = cookies[msg.sender].push(wish);

                // if it&#39;s the first cookie then we add sender to bakers list
                if (cookiesCount == 1) {
                        bakers.push(msg.sender);
                }
        }

        function breakCookie(string name) {
                var bakerAddress = bakers[block.number % bakers.length];
                var bakerCookies = cookies[bakerAddress];

                wishes[name] = bakerCookies[block.number % bakerCookies.length];
        }
}