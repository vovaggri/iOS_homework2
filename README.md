# Questions
## What issues prevent us from using storyboards in real projects?
In storyboard can have merge conflicts if you work in a team, for example storyboards can be hard to manage in version control. Secondly, they can become slow to load and cumbersome to work with Xcode.

## What does the code on lines 25 and 29 do? 
25. We are turn off automatic constraints and other settings of title (UILabel)
26. title will be showed on the screen with a text «WishMaker»
27. title will has a system font with size of 32
29. Add to the view title

## What is a safe area layout guide?
With safe area layout guide we can avoid system overlaps (navigation bar, status bar, battery indicator and etc.), support different screen sizes and make dynamic inserts (for example, when user change screen orientation)

## What is [weak self] on line 23 and why it is important?
[weak self] is used in closures to prevent strong reference cycles (retain cycles) when the closure captures self.
With help [weak self] we can avoid retain cycles and memory leaks. self need to optional, because it is now a weak reference and can be deallocated while the closure is running

## What does clipsToBounds mean?
clipsToBound it is a property of UIView, which determines whether or not the contents of child views should be clipped to the bounds of the parent view. When clipsToBounds is set to true, any part of the subviews extending beyond the boundaries of the parent view will not be visible. If it’s set to false, these elements will be shown outside the parent view's edges.

## What is the valueChanged type? What is Void and what is Double?

Optional variable valueChange is anonymous function in CustomSlider. This function takes a variable of Double type but return nothing, because this function is void and function make just an action.
