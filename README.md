# Disney-Coding-Challenge

Using Swift, write an app that calls this endpoint: 
`https://pugme.herokuapp.com/bomb?count=50` and show the results in a grid.
Your end result should look something like this (please use this only as a guideline, your app doesn't need to look exactly like this): ![](http://i.imgur.com/ZbdSh73.jpg)

#### Requirements:

- When the user reaches the end of the grid, call the API again to load more items, and add the new items to the end of the grid (infinite scrolling).
- If the user taps and holds on a cell, copy the image to the user's clipboard
- When the user taps a cell, show a fullscreen version of the image.

#### Bonus

- When in fullscreen mode, allow user to swipe forward and backward to get to next image.

Use any libraries/tools you need as you see fit (you will not be penalized for including or failing to include a library, but be prepared to justify a library’s inclusion).

Please organize the project like you would a real app and use best practices for organization. Code structure/style counts, not just "does the end product work?"

Time limit is __2 hours__ (you may not finish). If you have any problems with dev environment/etc (API being down, wifi problems, etc), please tell me ASAP and we'll pause the clock until resolved.
If you finish early, you may want to take the remainder of the time to polish up your code. No bonus points for finishing early.

Please send us your response by zipping up your project and sending it back by email.

Good luck!

#### Note
Some of the image URLs returned from the API are broken, but will work by removing the numeric sub-domain from the beginning of the URL. For instance, `http://30.media.tumblr.com/tumblr_lqexmferHa1qg02ino1_500.jpg` needs to be changed to `http://media.tumblr.com/tumblr_lqexmferHa1qg02ino1_500.jpg`.
