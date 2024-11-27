# Crumble King
A simple arcade game written in the Odin language. Utilizes an imperative code style with minimal abstractions.

> [![YouTube](http://i.ytimg.com/vi/_o3g5q6HveA/hqdefault.jpg)](https://www.youtube.com/watch?v=_o3g5q6HveA)
>
> Gameplay demo on YouTube. All but the first level have been omitted for brevity.

## Features
- Simple arcade platformer gameplay featuring 6 levels.
- Dedicated level editor within the same codebase.
- Dynamically changing tile based level with enemy patrol patterns responding to changes.
- Live square wave synthesis with a simple engine for sfx/music.
- Locally saved leaderboard scores.
## Project goals
I went into this project with three goals in mind (ordered by importance):
1. To make a fun arcade game.
2. To evaluate the results of programming in a staunchly imperative style with minimal abstractions, with the caveat that this is a very small project and the resulting insights might be of limited use.
3. To learn the Odin language and compare it to my workflow with C/C++.

### What went right?
I wanted to architect the code in a way that respected the small scope of the project, and for these purposes I think the straightforward, imperative style was a relative success.

It was my goal to **continually refactor the code as needed, identifying necessary abstractions as I added features, never trying to be too clever or think too far ahead.** All of the best parts of this code come from the times that I put in the necessary work to live up to this plan.

**Being as direct as possible about the way different game elements related to each other led to a much higher level of expressiveness when writing algorithms.** It also put me much more directly in touch with the essential complexity of the game design. My intuition is that tightly coupling the game elements in the ways I did led to much cleaner code overall, at the cost of needing more aggressive and constant refactoring.

A tentative takeaway from all this is that **decisions related to code coupling are largely about a balance between an ease of code changes (via decoupling strategies) and avoidance of accidental complexity (via avoidance of decoupling strategies).**

Programming in Odin was also a joy, and I would very much consider using it again as the ecosystem matures.

### What went wrong?
As this project was largely an experiment in code style, I changed my mind a number of times on some key philosophical points, and **I should have have laid out some ground rules before I started** which I was not allowed to break for the duration of the project.

I think the most visible consequence of this is my inconsistency regarding when code should be split out into functions for the purposes of organization. Midway through the project, I thought it might be worthwhile to see just how messy things get if all non-redundant functionality is simply inlined at the shallowest level of the call graph. My thinking was that **these kinds of decisions about function organization basically come down to a balance between minimizing local complexity and minimizing code fragmentation.** The problem was that I didn't do a thorough enough job of cleaning up the inevitable mess that came from this decision.

Another very straightforward failing of mine on this project was my tendency to take shortcuts near the end of the project when I knew the scope was set in stone. **I introduced magic numbers throughout the code and generally speaking, hardcoded a lot of information that should have been stored in a data format.**
#
