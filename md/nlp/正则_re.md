

[TOC]





#### 括号的基本用法

括号() ： 括号是多个匹配，它把括号内的当做一组来处理，限制一些多选的范围，比如上面的需求只能是com cn net结尾的用括号就是最好的选择。 
括号能提取字符串，如(com|cn|net)就可以限制，只能是com或cn或net。 
括号将括号里面的内容作为一组，这就是与[]不同的地方。

方括号[]： 方括号是单个匹配，如[abc]他限制的不是abc连续出现，而是只能是其中一个，这样写那么规则就是找到这个位置时只能是a或是b或是c； 
方括号是正则表达式中最常用的，常用的用法有：[a-zA-Z0-9]匹配所有英文字母和数字，\[^a-zA-Z0-9]匹配所有非英文字母和数字。

大括号{}： 大括号的用法很简单，就是匹配次数，它需要和其他有意义的正则表达式一起使用。 
比如[a-c]{2}意思就是匹配a-c之间的一个字母出现且只出现两次； 
比如(com){1}意思就是com必须出现一次 
比如\W{1,3}意思就是非字母数字最少出现一次最多出现3次。

[参考link](<https://my.oschina.net/newchaos/blog/1790499>)

