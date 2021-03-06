[![Gem Version](https://badge.fury.io/rb/hexp.png)][gem]
[![Build Status](https://secure.travis-ci.org/plexus/hexp.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/plexus/hexp.png)][gemnasium]
[![Code Climate](https://codeclimate.com/github/plexus/hexp.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/plexus/hexp/badge.png?branch=master)][coveralls]

[gem]: https://rubygems.org/gems/hexp
[travis]: https://travis-ci.org/plexus/hexp
[gemnasium]: https://gemnasium.com/plexus/hexp
[codeclimate]: https://codeclimate.com/github/plexus/hexp
[coveralls]: https://coveralls.io/r/plexus/hexp

# Hexp

**Hexp** (pronounced [ˈɦækspi:]) is a Ruby API for creating and manipulating HTML syntax trees. It enables a web application architecture where HTML is only ever represented as structured data, rather than as plain text.

Only when the data needs to be serialized and sent over the network is it converted to a string representation. This has a number of advantages.

* Single responsibility : HTML generation is not mixed with business logic
* Security : Protection from XSS (cross-site scripting)
* Productivity : components that create or alter fragments of a HTML become generic, reusable parts

For a more in-depth explanation please see the slides of talk [Web Linguistics, Towards Higher Fluency](http://arnebrasseur.net/talks/eurucamp2013/presentation.html) given at Eurucamp 2013. (the video is not available yet.)

**Creating Hexps**

Hexps are basically snippets of HTML written in nothing but Ruby, here's an example.

````ruby
@message = "Hexps are fun for the whole family, from 9 to 99 years old."
@hexp = H[:div, {class: 'hexp-intro'}, [
    [:p, @message]
  ]
]
````

For more info to get you up and running have a look at the API documentation for [Hexp::Node](http://plexus.github.io/hexp/Hexp/Node.html).

**Don't people use templates for this kind of thing?**

They do, this is an alternative approach. With templates you need to think about which parts need to be HTML-escaped, or you can make errors like forgetting a closing tag. With hexps you no longer need to think about escaping.

**Wait how is that?**

With traditional approaches you can insert plain text in your template, or snippets of HTML. The first must be escaped, the second should not. For your template they are all just strings, so you, the programmer, need to distinguish between the two in a way. For example by using `html_escape` on one (explicit escaping), or `html_safe` on the other (implicit escaping).

When using hexps you never deal with strings that actually contain HTML. Helper methods would return hexps instead, and you can combine those into bigger hexps. Strings inside a hexp are always just that, so they will always be escaped without you thinking about it.

**So that's it, easier escaping?**

Well that's not all, by having a simple lightweight representation of HTML that is _a real data structure_, you can really start programming your HTML. If you have an object that responds to `to_hexp`, you can use that object inside a hexp, so you can use Object Orientation for your user interface. Like so

````ruby
class ProfileLink < Struct.new(:user)
  def to_hexp
    H[:a, {class: "profile-link", href: "/user/#{user.id}"}, user.name]
  end
end

class Layout < Struct.new(:content)
  def to_hexp
    H[:html, [
      [:body, [content]]
    ]
  end
end

render inline: Layout.new(ProfileLink.new(@user)).to_html
````

**Does it get any better?**

It does! The really neat part is having filters that process this HTML tree before it gets serialized to text. This could be good for

- populating form fields
- adding extra admin buttons when logged in
- cleanly separate aspects of your app (e.g. discount codes) from 'core' implementation
- becoming filthy rich and/or ridiculously happy

**What's up with the funny name?**

Hexp stands for HTML expressions. It's a reference to s-expressions as they are known in LISP languages, a simple way to represent data as nested lists.

How to use it
-------------

Hexp objects come in two flavors : `Hexp::Node` and `Hexp::List`. A `Node` consists of three parts : its `tag`, `attributes` and `children`. A `List` is just that, a list (of nodes).

To construct a `Node` use `H[tag, attributes, children]`. Use a `Symbol` for the `tag`, a `Hash` for the `attributes`, and an `Array` for the `children`. Attributes or children can be omitted when they are empty.

The list of children will automatically be converted to `Hexp::List`, similarly for any nested nodes you can simply use `[tag, attributes, children]` without the `H`, all nodes in the tree will be converted to proper `Hexp::Node` objects.

The entire API is centered around these two classes, and one of them you can think of as essentially just an `Array`, in other words Hexp is super easy to learn. Try it out in `irb`, have a look at the examples, and *build cool stuff*!

A note on immutability
----------------------

All Hexp objects are frozen on creation, you can never alter them afterwards. Operations always return a new `Hexp::Node` rather than working in place.

This might seem stringent when you are not used to this style of coding, but it's a pattern that generally promotes good code.

Can I already use it
--------------------

Yes, but there are some things to keep in mind.

For the 0.x line of versions Hexp is not restricted to [semantic versioning](http://semver.org). We are still designing the API, and small backwards incompatible changes may occur. However given that the project's aim is to only provide the lowest level of DOM manipulation upon which others can built, it is already quite feature complete. It shouldn't be too long before we release a 1.0.0, after which we will commit to semantic versioning.

Another thing is that Hexp is young. It hasn't been battle tested yet, and the ecosystem which will make this approach truly attractive is yet to emerge. Therefore better try it out on smaller, non-critical projects first, and give us your feedback.

Is it any good?
---------------

Yes

How to install
--------------

At this point you're best off grabbing the Git repo, e.g. with bundler

````sh
# Gemfile

gem 'hexp', github: 'plexus/hexp'
````
