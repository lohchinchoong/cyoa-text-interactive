// PRIMARY SCHOOL - exam week, a school-life adventure in 5 scenes.
// Each page has 3 choices worth 0, 10 or 20 points. The total (0-100)
// decides which of the 5 exam results you get.
// `# image: name` tags are hooks for future 2D artwork; the player ignores them for now.

VAR score = 0

PRIMARY SCHOOL
Exam week: a school-life adventure in five pages.
-> page1

=== page1 ===
[ MONDAY MORNING ] # image: bedroom
BRRRING! Your alarm screams at 6:30 AM.
Grey light leaks through the curtains and rain taps on the window. The big final exam is this Friday, only four days away, and right now your warm bed feels like the safest place in the world.
* [Hit snooze. Five more minutes... or fifty.]
    ~ score += 0
    You wake up in a panic at 8:10 and sprint to school with toast in your mouth.
    -> page2
* [Get up and flip through flashcards over breakfast.]
    ~ score += 20
    Rice, eggs and the formulas for area and volume. Not a bad start.
    -> page2
* [Get up, but scroll your phone until it's time to leave.]
    ~ score += 10
    You're on time, but you now know more about cat videos than about chemistry.
    -> page2

=== page2 ===
[ HOMEROOM ] # image: classroom
Homeroom is buzzing with nervous chatter about Friday's exam. Your best friend Kenji drops into the seat beside you and slides a thick, colour-coded notebook across the desk.
"I rewrote all of last term's notes," he says proudly. "Want them?"
* [Sit with Kenji and compare notes to fill in your gaps.]
    ~ score += 20
    You spot three topics you completely forgot about. Kenji is a hero.
    -> page3
* [Snap photos of every page to read "later".]
    ~ score += 10
    Forty-two photos land in your camera roll, right next to the cat videos.
    -> page3
* ["Notes? I'm going to wing it."]
    ~ score += 0
    Kenji gives you a look that is half pity, half disappointment.
    -> page3

=== page3 ===
[ LUNCH BREAK ] # image: canteen
The lunch bell rings and the corridor floods with students. You have forty minutes to spare. Posters for the games club tournament promise a shiny trophy, the study group is meeting in the science lab, and the quiet rooftop is calling your name.
* [Join the games club tournament. There's a trophy!]
    ~ score += 0
    You reach the semi-finals. The trophy is shiny. The exam is not impressed.
    -> page4
* [Join the study group in the science lab.]
    ~ score += 20
    Ms. Tan drops by and hints at what "might" be on the paper. You write it all down.
    -> page4
* [Take a power nap on the rooftop.]
    ~ score += 10
    You wake up refreshed, with only a small amount of drool on your sleeve.
    -> page4

=== page4 ===
[ FREE PERIOD ] # image: library
Your last lesson is cancelled, so you have a free period. In the corner of the classroom, your classmate Aiko is frowning at her algebra homework and chewing her pencil. Through the window you can see the library, and the computer lab door is wide open.
* [Help Aiko work through the algebra problems.]
    ~ score += 10
    Explaining it out loud helps you understand it better too.
    -> page5
* [Sneak into the computer lab for some gaming.]
    ~ score += 0
    You get a new high score. You do not get any smarter.
    -> page5
* [Head to the library and do a full practice paper.]
    ~ score += 20
    You finish with five minutes to spare, and you finally get the trick questions.
    -> page5

=== page5 ===
[ THE NIGHT BEFORE ] # image: night
It's Thursday night. The exam starts at 8:00 AM tomorrow, and your desk is buried under notes, highlighters and empty snack wrappers. Then your phone buzzes with a reminder: the new season of your favourite show has just been released.
* [Binge the new season of your favourite show.]
    ~ score += 0
    "Just one more episode" turns into nine.
    -> results
* [Cram until 3 AM with energy drinks.]
    ~ score += 10
    You learn a lot. You also forget how to blink.
    -> results
* [Do a light review, then go to bed early.]
    ~ score += 20
    You fall asleep calm, with the key points fresh in your mind.
    -> results

=== results ===
[ RESULTS DAY ] # image: results
Friday comes and goes in a blur of pencils and ticking clocks. A week later, the papers come back. The classroom falls silent as Ms. Tan walks between the desks, handing them out face down. You take a deep breath and slowly turn yours over...
{
    - score <= 10: -> fail_zero
    - score <= 40: -> fail_twenty
    - score <= 60: -> just_pass
    - score <= 90: -> good
    - else: -> excellent
}

=== fail_zero ===
SCORE: 0/100 - FAIL! # ending: 0
The page is blank except for your name, and you spelled that wrong.
Your teacher has written "See me." in very large red letters.
-> END

=== fail_twenty ===
SCORE: 20/100 - FAIL! # ending: 20
You got the multiple choice questions about half right, which is mostly luck.
Summer school is calling, and it won't stop calling.
-> END

=== just_pass ===
SCORE: 50/100 - JUST PASS # ending: 50
You scraped through by the skin of your teeth.
Your parents sigh with relief. So do you.
-> END

=== good ===
SCORE: 80/100 - GOOD! # ending: 80
Solid work! Kenji gives you a high five, and your mum makes your favourite dinner.
-> END

=== excellent ===
SCORE: 100/100 - EXCELLENT! # ending: 100
A perfect score! Ms. Tan pins your paper on the noticeboard.
Every good choice this week paid off.
-> END
