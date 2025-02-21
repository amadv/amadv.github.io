X-Date: 2025-02-25T02:30:00Z
Subject: Many of my projects are dirty hacks
X-Slug: many_of_my_projects_are_dirty_hacks

Over the last 20 years that I've been writing software, my ability to deliver projects has increased.
I especially notice this in context of pet projects, that I not only finish, but also continue using over time.

You may say that this is just the accumulated experience, and I'll grant you that. But I believe that mostly
the quality of code that I write didn't become significantly better, and neither did the speed with which
I produce code.

Alright, if not speed or quality - then what?

My best guess so far would be the understanding of time boundaries. If 10 years ago someone had shown me a big
problem - I'll just roll up the sleeves and start working on it from the level of modules, unit testing everything
and making sure my implementation is well-designed.

Now, I understand very clearly that by the time I'm done with writing out the system properly - not only my
energy will run out, but also all motivation will evaporate. So I make a deliberate decision to start with a
dirtiest and cheapest version of what I need. Oftentimes, it turns out that a prototype is just enough to
get by through a long stretch of time.

The second thing I would do is try to not aim at a moving target. The more stable and "fossilized" the technology -
the better. It is ideal if I can get back to the project after 5 years, and it just compiles and works.

Even though I allow myself to write crappy code, there is one rule: don't let the crap leak through layers.
If the crap stays put in its own layer - you can always reason about it, and change it when the time comes.
This often means that layers would only exchange "plain-old flat data structures" without any class hierarchies,
as if they were interacting through the network (just at the level of one process).

And the last thing -- I try to make it dead simple to pick up the work from where I left it, and continue.
If the cost of context recovery is low enough for me - it means that the project is more likely to gain
a fraction of my time.

If you're new in your career - don't take anything from this post as an advice. I don't believe it would
be helpful, and blindly following it would probably lead to a disaster. Except probably for one thing:
do prototypes.
