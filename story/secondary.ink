// SECONDARY SCHOOL - four years, forty pages, seven endings.
// Every page has 3 choices worth 0, 1 or 2 grade points (see `study`).
// The 0-point choice on some pages also feeds a hidden counter:
//   strikes  - 3 discipline strikes and you are expelled (checked straight away)
//   society  - 3 steps into the Order unlocks the oath on page 29
//   startup  - 4 nights of building the app unlocks dropping out on pages 26 and 34
// Each year ends with a report card: under 7 points that year and you repeat it.
// After page 40 the total grade (0-80) picks one of the three college endings,
// or repeating Sec 4.
// `# page: n` tags let the tests count pages; `# image: name` tags are artwork hooks.

VAR grades = 0
VAR year_grades = 0
VAR year = 1
VAR strikes = 0
VAR society = 0
VAR startup = 0

SECONDARY SCHOOL
Four years. Forty pages. Seven ways it could end.
-> p1

=== function study(points) ===
~ grades += points
~ year_grades += points

=== check_strikes(-> next) ===
{ strikes >= 3:
    -> expelled
}
-> next

=== year_end(-> next) ===
{ year_grades < 7:
    -> repeat_year
}
Your Sec {year} report card arrives in a brown envelope. At the bottom, Mr. Lim has written: "Promoted to Sec {year + 1}."
~ year += 1
~ year_grades = 0
-> next

// ---------------------------------------------------------------- SEC 1

=== p1 ===
[ SEC 1: THE FIRST DAY ] # image: gate # page: 1
The school gates are taller than you remember from the open house. Hundreds of students in crisp new uniforms stream past you, and nobody looks lost except you. Your timetable says 1E, Block C, Level 3. You have no idea where Block C is.
* [Find the classroom early and grab a seat near the front.]
    ~ study(2)
    You arrive first. Mr. Lim, your form teacher, nods at you approvingly.
    -> p2
* [Follow the crowd and take the last seat by the window.]
    ~ study(1)
    The view of the field is lovely. The whiteboard is very far away.
    -> p2
* [Wander off to explore the old wing instead.]
    ~ study(0)
    You find a dusty clock tower and miss the whole of homeroom.
    -> p2

=== p2 ===
[ SEC 1: THE CCA FAIR ] # image: hall # page: 2
The school hall is packed with booths for every co-curricular activity you can imagine. The debate society is shouting about logic, the football team is juggling a ball, and a lonely booth in the corner promises "no commitment whatsoever". You have to sign up for one before Friday.
* [Join the debate society.]
    ~ study(2)
    Arguing for a living turns out to sharpen your essays, too.
    -> p3
* [Join the football team.]
    ~ study(1)
    You make the team, plus a lot of friends with very muddy boots.
    -> p3
* [Sign up for nothing and go home early every day.]
    ~ study(0)
    Your afternoons are free. Your record is very, very empty.
    -> p3

=== p3 ===
[ SEC 1: THE GROUP PROJECT ] # image: classroom # page: 3
Mr. Lim splits the class into groups for a geography project on rivers. You end up with Priya, who already seems like your best friend, and Marcus, who seems determined to be your rival. The project is due in two weeks and counts towards your final grade.
* [Do your share, then help Priya polish the slides.]
    ~ study(2)
    Your group gets the top mark in the class. Marcus pretends not to care.
    -> p4
* [Split the work three ways and do exactly your third.]
    ~ study(1)
    It's fine. It's a perfectly fine project about a perfectly fine river.
    -> p4
* [Let Priya and Marcus carry the whole thing.]
    ~ study(0)
    Priya covers for you, but she gives you a long, quiet look.
    -> p4

=== p4 ===
[ SEC 1: THE CANTEEN QUEUE ] # image: canteen # page: 4
Recess lasts twenty minutes and the chicken rice queue is at least fifteen of them. A group of Sec 3 students has just cut in right in front of you, laughing. Priya is behind you with her history notes, and a prefect is watching from the drinks stall.
* [Cut back in front of them and argue with the prefect.]
    ~ study(0)
    ~ strikes += 1
    The prefect writes your name down in a small black book. That's one strike.
    -> check_strikes(-> p5)
* [Wait patiently and quiz Priya on her history notes.]
    ~ study(2)
    By the time you reach the counter, you both know the dates cold.
    -> p5
* [Give up on chicken rice and buy a sad bun.]
    ~ study(1)
    The bun is dry, but at least you have time to finish your homework.
    -> p5

=== p5 ===
[ SEC 1: THE FIRST MATHS TEST ] # image: desk # page: 5
Your first secondary school maths test is on Monday, and everyone says the teacher marks very harshly. The topic is algebra, which looked simple in class but now looks like a mess of letters pretending to be numbers. It's Saturday morning and the weekend stretches ahead.
* [Do two full practice papers and check every answer.]
    ~ study(2)
    By Sunday night, x and y have stopped scaring you.
    -> p6
* [Skim your notes once on Sunday evening.]
    ~ study(1)
    You remember most of it. Most is not quite all.
    -> p6
* [Spend the weekend doodling in the margins of your textbook.]
    ~ study(0)
    The doodles are excellent. Your algebra is not.
    -> p6

=== p6 ===
[ SEC 1: THE DARE ] # image: corridor # page: 6
Marcus leans over before morning assembly with a grin. "Bet you're too scared to skip assembly and hide in the toilets," he whispers. A few classmates turn to watch. Over the speakers, the principal is about to announce something about scholarships.
* [Take the dare and hide in the toilets.]
    ~ study(0)
    ~ strikes += 1
    The discipline master opens the door. That's another strike in the book.
    -> check_strikes(-> p7)
* [Ignore Marcus and doze through assembly.]
    ~ study(1)
    You wake up to applause and have no idea what for.
    -> p7
* [Stand at the front and listen to the announcement.]
    ~ study(2)
    There is a scholarship for top students. You write the details down.
    -> p7

=== p7 ===
[ SEC 1: THE BLACK ENVELOPE ] # image: locker # page: 7
When you open your locker after lunch, a black envelope slides out. Inside, a card printed in silver ink says: "The Order of the Clock Tower sees promise in you. Old music room, four o'clock. Tell no one." There is no name, only a small drawing of a clock.
* [Go to the old music room at four o'clock.]
    ~ study(0)
    ~ society += 1
    A senior in a grey blazer is waiting. "Good," she says. "You came." Then she is gone.
    -> p8
* [Show the card to Mr. Lim.]
    ~ study(1)
    Mr. Lim frowns at it for a long time, then tells you not to worry.
    -> p8
* [Throw it away and go to the library to study.]
    ~ study(2)
    Probably a prank. You finish your science worksheet instead.
    -> p8

=== p8 ===
[ SEC 1: SPORTS DAY ] # image: field # page: 8
The whole school is out on the field under a blazing sun. Your house is one point behind in the overall standings, and the four by one hundred metre relay is the last event of the day. Your house captain is looking around desperately for a fourth runner.
* [Volunteer to run the final leg.]
    ~ study(2)
    You don't win, but you overtake two runners and the whole house screams your name.
    -> p9
* [Cheer from the stands with Priya.]
    ~ study(1)
    You lose your voice, but you gain a sunburn and a lot of house spirit.
    -> p9
* [Fake a sore ankle and sit in the shade all day.]
    ~ study(0)
    Nobody believes the ankle. Everybody remembers it.
    -> p9

=== p9 ===
[ SEC 1: CODING CLUB DEMO DAY ] # image: lab # page: 9
A quiet boy called Jun is showing off a homework planner app he built himself on the computer lab projector. It's rough, but people are genuinely impressed. Afterwards, he catches you by the door. "I need someone who can design," he says. "Want to build it properly with me?"
* [Spend the whole weekend coding the app with Jun.]
    ~ study(0)
    ~ startup += 1
    You forget to sleep, but by Monday the app actually looks good.
    -> p10
* [Learn some coding with him, but keep your weekends for revision.]
    ~ study(2)
    You pick up a useful new skill without falling behind.
    -> p10
* [Clap politely and leave.]
    ~ study(1)
    Jun shrugs and goes back to his laptop.
    -> p10

=== p10 ===
[ SEC 1: FINAL EXAMS ] # image: exam_hall # page: 10
The Sec 1 final exams are next week. Every subject counts, and you have heard that students with poor results are made to repeat the year. Your desk at home is covered in a year of notes, some neat and some completely unreadable.
* [Make a revision timetable and stick to it every day.]
    ~ study(2)
    You walk into the exam hall calm and ready.
    -> year_end(-> p11)
* [Revise the subjects you like and hope for the best.]
    ~ study(1)
    History goes well. Maths goes less well.
    -> year_end(-> p11)
* [Tell yourself it's only Sec 1 and play games all week.]
    ~ study(0)
    It is only Sec 1. It is also your only Sec 1.
    -> year_end(-> p11)

// ---------------------------------------------------------------- SEC 2

=== p11 ===
[ SEC 2: NEW CLASS, NEW FACES ] # image: classroom # page: 11
Sec 2 means a reshuffled class, and you're relieved to find Priya on the list again. Mr. Lim is still your form teacher, and Marcus is unfortunately still Marcus. On the first morning you need to choose a seat for the whole year, and that choice matters more than it looks.
* [Sit next to the quiet top student in the front row.]
    ~ study(2)
    She lends you her highlighters and some of her good habits.
    -> p12
* [Sit with Priya in the middle.]
    ~ study(1)
    You pass notes. Some of them are even about the lesson.
    -> p12
* [Join the noisy crowd at the very back.]
    ~ study(0)
    The back row is fun. The back row is also where homework goes to die.
    -> p12

=== p12 ===
[ SEC 2: MARCUS'S CHALLENGE ] # image: corridor # page: 12
At the change of lessons, Marcus blocks your way in the corridor. "Race you to the science lab," he says. "Loser carries the winner's bag for a week." The corridor is crowded, and you can see the vice-principal walking towards the staircase at the far end.
* [Race him down the crowded corridor.]
    ~ study(0)
    ~ strikes += 1
    You win, right into the vice-principal. Strike.
    -> check_strikes(-> p13)
* [Challenge him to a quiz on today's lesson instead.]
    ~ study(2)
    You win easily. Marcus carries your bag, muttering the whole way.
    -> p13
* [Walk past him without a word.]
    ~ study(1)
    Marcus looks almost disappointed. You get to class on time.
    -> p13

=== p13 ===
[ SEC 2: THE SIDE HUSTLE ] # image: canteen # page: 13
Jun has a new plan. Students keep asking for his homework planner app, so he wants to charge a dollar a month and sell it at recess. "We could make real money," he says. At the same time, a Sec 1 parent is looking for a maths tutor for their child.
* [Sell subscriptions with Jun every recess and evening.]
    ~ study(0)
    ~ startup += 1
    Two hundred students sign up. Your homework does not get done.
    -> p14
* [Make funny stickers to sell at the craft fair.]
    ~ study(1)
    You make forty dollars and a lot of glitter mess.
    -> p14
* [Tutor the Sec 1 student in maths.]
    ~ study(2)
    Teaching algebra makes you understand it better than ever.
    -> p14

=== p14 ===
[ SEC 2: THE PHONE ] # image: classroom # page: 14
In the middle of Mr. Lim's history lesson, your phone buzzes loudly. Then it buzzes again, and then it starts to ring. The whole class turns around. Mr. Lim sighs, walks to your desk and holds out his hand without saying a word.
* [Refuse to hand it over and argue that it's yours.]
    ~ study(0)
    ~ strikes += 1
    Mr. Lim sends you straight to the discipline master. Strike.
    -> check_strikes(-> p15)
* [Hand it over and apologise.]
    ~ study(2)
    Mr. Lim gives it back after school, with a small nod of respect.
    -> p15
* [Mumble that it isn't yours and stare at the ceiling.]
    ~ study(1)
    Nobody believes you, but Mr. Lim lets it go this time.
    -> p15

=== p15 ===
[ SEC 2: THE SCIENCE FAIR ] # image: lab # page: 15
The annual science fair is in three weeks, and every Sec 2 student has to enter a project. Priya is testing which brand of paper towel absorbs the most water. You need an idea, and the judges are known to be very hard to impress with anything ordinary.
* [Design a careful experiment on how plants respond to music.]
    ~ study(2)
    The judges love it. Your basil plants seem to prefer jazz.
    -> p16
* [Build the classic baking soda volcano.]
    ~ study(1)
    It erupts nicely. The judges have seen it nine times today.
    -> p16
* [Buy a kit the night before and assemble it in the car.]
    ~ study(0)
    The instructions are in a language you can't read.
    -> p16

=== p16 ===
[ SEC 2: THE CANDLELIT LIBRARY ] # image: library # page: 16
A second black envelope appears in your bag. "Tonight, seven o'clock, the old library. The Order is gathering." When you pass the old library after school, you can see candlelight flickering behind the dusty windows. The senior in the grey blazer is standing at the door.
* [Go in and sign your name in the Order's leather ledger.]
    ~ study(0)
    ~ society += 1
    Twelve hooded figures say your name together. It is extremely creepy and strangely exciting.
    -> p17
* [Peek through the window, then hurry home.]
    ~ study(1)
    You think you see Mr. Lim's old school photo on their wall.
    -> p17
* [Ignore it and finish your English essay.]
    ~ study(2)
    The essay gets an A. The candles burn without you.
    -> p17

=== p17 ===
[ SEC 2: SCHOOL CAMP ] # image: forest # page: 17
Three days in the jungle with your whole level, with tents, mosquitoes and an orienteering race through the hills. Your group has a map, a compass and a lot of opinions. Marcus is in your group, and he is already holding the map upside down.
* [Take the compass and lead the team.]
    ~ study(2)
    Your team finishes first, and Mr. Lim writes "natural leader" on your report.
    -> p18
* [Follow along and carry the snacks.]
    ~ study(1)
    The snacks are a hit. You get lost twice, but happily.
    -> p18
* [Sneak back to the tent to sleep.]
    ~ study(0)
    You miss the race, and the teachers notice your empty spot.
    -> p18

=== p18 ===
[ SEC 2: THE HACKATHON ] # image: lab # page: 18
A tech company is running a weekend hackathon for students, with a cash prize and free pizza. Jun wants to enter your app. The problem is that you also have three pieces of homework and a geography test on Monday morning.
* [Spend the whole weekend at the hackathon with Jun.]
    ~ study(0)
    ~ startup += 1
    You win second place and a business card from a mentor. The geography test is a blur.
    -> p19
* [Stay home and finish your homework.]
    ~ study(2)
    Jun sends you photos of the pizza. Your test goes well.
    -> p19
* [Drop by for one afternoon and then go home.]
    ~ study(1)
    You help a little and study a little.
    -> p19

=== p19 ===
[ SEC 2: THE BLAME GAME ] # image: corridor # page: 19
Someone has drawn a rude cartoon of the principal on the toilet wall. By lunchtime, Marcus is telling everyone it was you. You know it wasn't, and you are fairly sure you saw Marcus with a marker earlier. Students are whispering as you walk past.
* [Get revenge by drawing on Marcus's locker.]
    ~ study(0)
    ~ strikes += 1
    You get caught halfway through drawing his nose. Strike.
    -> check_strikes(-> p20)
* [Calmly tell Mr. Lim what you saw.]
    ~ study(2)
    Mr. Lim investigates quietly, and Marcus spends a week cleaning walls.
    -> p20
* [Say nothing and wait for it to blow over.]
    ~ study(1)
    It mostly blows over. Mostly.
    -> p20

=== p20 ===
[ SEC 2: FINAL EXAMS ] # image: exam_hall # page: 20
The Sec 2 finals decide which subjects you will be allowed to take next year. Priya has started a study group in the library every afternoon. Your bed, your games console and your phone are all making very persuasive arguments of their own.
* [Join Priya's study group every afternoon.]
    ~ study(2)
    Teaching each other turns out to be the best revision there is.
    -> year_end(-> p21)
* [Study alone at home, with plenty of breaks.]
    ~ study(1)
    Some of the breaks are longer than the studying.
    -> year_end(-> p21)
* [Wing it. You did fine last year, didn't you?]
    ~ study(0)
    You walk into the hall and recognise almost nothing.
    -> year_end(-> p21)

// ---------------------------------------------------------------- SEC 3

=== p21 ===
[ SEC 3: CHOOSING SUBJECTS ] # image: classroom # page: 21
It's time to choose your subject combination for the last two years. Triple science is tough but opens the most doors. Humanities with art is a good fit for your creative side. And a few students are simply picking whichever combination has the least homework.
* [Take triple science.]
    ~ study(2)
    It's hard work, but the top colleges will notice.
    -> p22
* [Take humanities with art.]
    ~ study(1)
    You enjoy every lesson, even the essays.
    -> p22
* [Pick whatever has the least homework.]
    ~ study(0)
    The homework is light. So is the interest.
    -> p22

=== p22 ===
[ SEC 3: FIRST PAYING USERS ] # image: bedroom # page: 22
The app has spread to other schools. Overnight, a thousand students have signed up, and your inbox is full of feature requests and complaints. Jun is texting you in capital letters. You have a chemistry test on Thursday, and you haven't opened the textbook yet.
* [Answer every email until two in the morning, every night.]
    ~ study(0)
    ~ startup += 1
    The users love you. Your chemistry teacher does not.
    -> p23
* [Spend an hour a night on the app, then study.]
    ~ study(1)
    You're tired, but both things are just about working.
    -> p23
* [Tell Jun he's on his own this week.]
    ~ study(2)
    You ace the chemistry test. Jun sulks for a day.
    -> p23

=== p23 ===
[ SEC 3: PREFECT ELECTIONS ] # image: hall # page: 23
Nominations for the prefectorial board are open. Being a prefect looks great on a college application, but it means early mornings and a lot of responsibility. Priya thinks you should run. Marcus has already put up posters with his own face on them.
* [Run for prefect and give a serious speech.]
    ~ study(2)
    You win, and Marcus's posters slowly come down.
    -> p24
* [Help Priya run instead.]
    ~ study(1)
    She wins, and she thanks you in her speech.
    -> p24
* [Write a joke speech about free bubble tea for all.]
    ~ study(0)
    The students love it. The teachers definitely do not.
    -> p24

=== p24 ===
[ SEC 3: THE CIPHER ] # image: noticeboard # page: 24
A strange grid of letters has been pinned to the school noticeboard. Most students walk past it, but you recognise the little clock drawn in the corner. It looks like a cipher, and it would probably take a whole evening to crack.
* [Crack the cipher and follow it to the clock tower basement.]
    ~ study(0)
    ~ society += 1
    Behind a locked door, the Order welcomes you as one of their own. You get a grey blazer.
    -> p25
* [Solve it for fun, but stay away from the basement.]
    ~ study(1)
    It says "THE HOUR IS NEAR". You decide not to think about that.
    -> p25
* [Ignore it and finish your physics homework.]
    ~ study(2)
    Newton's laws are mysterious enough for one evening.
    -> p25

=== p25 ===
[ SEC 3: THE OVERSEAS TRIP ] # image: temple # page: 25
Your level goes on a week-long trip to Kyoto, full of temples, trains and very good food. The trip counts towards a humanities project, and every student has to write a report about it when you get back. Priya wants to see everything.
* [Keep a detailed journal and interview the local guides.]
    ~ study(2)
    Your report is so good it ends up in the school magazine.
    -> p26
* [Take photos and enjoy the food.]
    ~ study(1)
    The report is short, but the photos are excellent.
    -> p26
* [Wander away from the group to go shopping.]
    ~ study(0)
    The teachers spend an hour looking for you. Your report is half a page long.
    -> p26

=== p26 ===
[ SEC 3: THE INVESTOR EMAIL ] # image: bedroom # page: 26
An email arrives from an investor with a famous name. "Your app has a hundred thousand users," it says. "I'd like to put serious money into it. Can you meet on Saturday?" Jun is already planning what to wear. You have a geography assignment due on Monday.
* [Forward the email to Jun and finish your assignment.]
    ~ study(2)
    Jun handles the meeting. Your assignment gets an A.
    -> p27
* [Take the meeting, then catch up on homework on Sunday.]
    ~ study(1)
    The investor is interested. You only half finish the assignment.
    -> p27
* {startup >= 4} [Drop out of school and go all-in on the startup.]
    You hand Mr. Lim a letter on Monday morning. He reads it twice, then shakes your hand.
    -> billionaire
* {startup < 4} [Spend the weekend daydreaming about being rich.]
    ~ study(0)
    The investor never writes back. The assignment is late.
    -> p27

=== p27 ===
[ SEC 3: THE MIDNIGHT CRASH ] # image: bedroom # page: 27
It's midnight on the eve of a big maths test, and your phone won't stop buzzing. The app has crashed, and fifty thousand angry users are posting about it. Jun is asleep and not answering. Your maths notes are sitting untouched beside your laptop.
* [Stay up all night fixing the code.]
    ~ study(0)
    ~ startup += 1
    By sunrise, the app is back and faster than ever. You sleep through half the test.
    -> p28
* [Post a quick apology, then go to bed.]
    ~ study(1)
    You sleep, but badly. The test goes about average.
    -> p28
* [Turn off your phone and revise for the test.]
    ~ study(2)
    You get the highest mark in the class. The app can wait.
    -> p28

=== p28 ===
[ SEC 3: COPIED HOMEWORK ] # image: classroom # page: 28
It's five minutes before chemistry, and you haven't done the homework. Marcus waves his finished worksheet at you with a smirk. "Copy it," he says. "Everyone does." The chemistry teacher has caught three copiers this term already.
* [Copy Marcus's worksheet word for word.]
    ~ study(0)
    ~ strikes += 1
    You even copy his name. Strike.
    -> check_strikes(-> p29)
* [Do as much as you can yourself in five minutes.]
    ~ study(1)
    Half done, but every answer is your own.
    -> p29
* [Own up to the teacher and ask for an extension.]
    ~ study(2)
    She's surprised, gives you one day, and you hand in your best work yet.
    -> p29

=== p29 ===
[ SEC 3: THE CLOCK TOWER AT MIDNIGHT ] # image: clocktower # page: 29
You can't sleep. From your window you can see the old clock tower at school, and just before midnight a light comes on at the very top. Your phone lights up with a message from an unknown number: "Tonight is the night. The hour has come."
* [Block the number and go back to sleep.]
    ~ study(2)
    You wake up rested, and the light in the tower is gone.
    -> p30
* [Text Priya about the strange light.]
    ~ study(1)
    You both stay up far too late making theories.
    -> p30
* {society >= 3} [Take the oath beneath the old clock tower.]
    You slip out of the house in your grey blazer. The clock strikes thirteen.
    -> vanished
* {society < 3} [Climb the clock tower stairs out of curiosity.]
    ~ study(0)
    At the top there are only pigeons, a broken lamp and a very angry caretaker.
    -> p30

=== p30 ===
[ SEC 3: FINAL EXAMS ] # image: exam_hall # page: 30
The Sec 3 finals are the last hurdle before your final year. Mr. Lim reminds the class that colleges look closely at these results. The week before the exams, the weather is perfect, the new games are out, and every one of your friends seems to be busy.
* [Revise every day with past papers.]
    ~ study(2)
    The papers feel familiar, almost friendly.
    -> year_end(-> p31)
* [Revise most days.]
    ~ study(1)
    You do fine, with a few nasty surprises.
    -> year_end(-> p31)
* [Spend the week at the beach.]
    ~ study(0)
    Your tan is excellent. Your results are not.
    -> year_end(-> p31)

// ---------------------------------------------------------------- SEC 4

=== p31 ===
[ SEC 4: THE FINAL YEAR ] # image: classroom # page: 31
This is it, your final year of secondary school. The big national exams are in ten months, and Mr. Lim has written the countdown on the whiteboard. Priya has already colour-coded her entire year. Marcus claims he hasn't started, which nobody believes.
* [Make a detailed study timetable for the whole year.]
    ~ study(2)
    It's taped above your desk. You actually follow it.
    -> p32
* [Make a rough plan and see how it goes.]
    ~ study(1)
    It goes roughly as planned.
    -> p32
* [Ten months is ages away. Relax.]
    ~ study(0)
    The countdown on the whiteboard says otherwise.
    -> p32

=== p32 ===
[ SEC 4: MOCK EXAM PANIC ] # image: staffroom # page: 32
The mock exams are next week and you feel completely unprepared. Walking past the staff room at lunch, you notice that the door is open, nobody is inside, and a stack of exam papers is sitting on Mr. Lim's desk.
* [Slip inside and take a quick look at the papers.]
    ~ study(0)
    ~ strikes += 1
    The door clicks shut behind you, and the principal is sitting in the corner. Strike.
    -> check_strikes(-> p33)
* [Walk away and ask Mr. Lim for help later.]
    ~ study(2)
    He spends an hour going through your weak topics with you.
    -> p33
* [Go home and eat a whole tub of ice cream.]
    ~ study(1)
    You feel better. You do not feel more prepared.
    -> p33

=== p33 ===
[ SEC 4: A FRIEND IN TROUBLE ] # image: park # page: 33
Priya hasn't been herself lately. She finally tells you that her parents are going through a hard time and she can't focus on anything. Her grades are slipping, and she's worried she won't make it to college. She looks at you, not sure what to say next.
* [Offer to study with her every evening.]
    ~ study(2)
    You both improve, and she smiles properly for the first time in weeks.
    -> p34
* [Send her encouraging messages every day.]
    ~ study(1)
    She says the messages help a little.
    -> p34
* [Say you're sorry, then go back to your games.]
    ~ study(0)
    You lose the next round, and you feel bad about the rest of the evening.
    -> p34

=== p34 ===
[ SEC 4: THE ACQUISITION OFFER ] # image: office # page: 34
A big tech company wants to buy your app, or hire you and Jun to run it full time. The offer arrives the same week as your chemistry practical. Jun is jumping up and down. Your parents are not, and your chemistry teacher definitely is not.
* [Let Jun negotiate while you focus on school.]
    ~ study(2)
    Jun sends you updates. You ace the practical.
    -> p35
* [Negotiate on weekends only.]
    ~ study(1)
    Busy weekends, but you keep your grades afloat.
    -> p35
* {startup >= 4} [Drop out of school and go all-in on the startup.]
    You turn down the offer, because you believe the app can be worth far more.
    -> billionaire
* {startup < 4} [Spend the evening imagining your future yacht.]
    ~ study(0)
    The yacht is lovely. The practical is a disaster.
    -> p35

=== p35 ===
[ SEC 4: THE LEAKED PAPER ] # image: corridor # page: 35
A rumour races around the school that someone has the real English paper and is selling copies for fifty dollars. Students are whispering in the toilets and passing notes. Marcus says he knows exactly who has it, and he can get you a copy by tonight.
* [Pay fifty dollars for a copy.]
    ~ study(0)
    ~ strikes += 1
    It's fake, and the school finds out exactly who bought one. Strike.
    -> check_strikes(-> p36)
* [Ignore the rumour and keep studying.]
    ~ study(1)
    It turns out to be fake anyway.
    -> p36
* [Report it to Mr. Lim.]
    ~ study(2)
    The scam is shut down, and the teachers thank you quietly.
    -> p36

=== p36 ===
[ SEC 4: THE STUDY MARATHON ] # image: library # page: 36
Priya has organised a study marathon in the library, from eight in the morning to eight at night, for the whole weekend. There will be snacks, past papers and the smartest students in your level. It's also the weekend of your cousin's birthday party.
* [Stay focused for the whole marathon.]
    ~ study(2)
    You finish six past papers. Your brain hurts in a good way.
    -> p37
* [Go, but spend half the time chatting.]
    ~ study(1)
    You learn a lot of gossip and a little chemistry.
    -> p37
* [Skip it and go to the party.]
    ~ study(0)
    The cake is great. Monday's quiz is not.
    -> p37

=== p37 ===
[ SEC 4: THE LAST CCA EVENT ] # image: hall # page: 37
It's your last ever event for your CCA, and the whole team is counting on you. Afterwards, everyone is heading out to celebrate the end of an era. There are only six weeks left until the national exams begin.
* [Give it your all, then go home early to revise.]
    ~ study(2)
    You win, and you still get your revision done.
    -> p38
* [Celebrate with the team until late.]
    ~ study(1)
    It's a night you'll remember. The next morning is a bit of a blur.
    -> p38
* [Party all weekend long.]
    ~ study(0)
    You lose two whole days of revision.
    -> p38

=== p38 ===
[ SEC 4: PARENTS' EXPECTATIONS ] # image: dining_room # page: 38
At dinner, your parents put down their chopsticks. "We need to talk about your future," your father says. Your mother has printed out a list of colleges, with the most famous one circled three times in red ink.
* [Have an honest talk and make a plan together.]
    ~ study(2)
    They are proud of you, and the plan makes you feel calmer.
    -> p39
* [Nod along and say "okay" a lot.]
    ~ study(1)
    The conversation ends. The pressure doesn't.
    -> p39
* [Argue, then storm off to your room.]
    ~ study(0)
    You slam the door and spend the night angry instead of studying.
    -> p39

=== p39 ===
[ SEC 4: THE NIGHT BEFORE ] # image: night # page: 39
It's the night before your first national exam paper. Four years of secondary school come down to the next few weeks. Your desk is covered in notes, and your phone is buzzing with nervous messages from the class group chat.
* [Do a light review, then go to bed early.]
    ~ study(2)
    You sleep well, and the key points are fresh in your mind.
    -> p40
* [Cram until three in the morning.]
    ~ study(1)
    You learn a lot. You also forget how to blink.
    -> p40
* [Play games to take your mind off it.]
    ~ study(0)
    "One more game" becomes twelve.
    -> p40

=== p40 ===
[ SEC 4: THE LAST EXAM ] # image: exam_hall # page: 40
The exam hall is silent except for the ticking clock. Priya gives you a thumbs up from two rows away. Even Marcus looks nervous. The invigilator says, "You may begin," and you turn over the first page of the very last paper of secondary school.
* [Read every question carefully and plan your answers.]
    ~ study(2)
    You finish with ten minutes to spare and check every answer.
    -> results
* [Rush through and hope for the best.]
    ~ study(1)
    You finish first, which is not always a good sign.
    -> results
* [Panic and doodle in the margin.]
    ~ study(0)
    The doodle is your finest work yet.
    -> results

=== results ===
[ RESULTS DAY ] # image: results
Months later, the whole level gathers in the hall to collect their results. Mr. Lim calls out names one by one. When he reaches yours, he hands you a white envelope. You open it slowly...
{
    - grades >= 66: -> prestigious
    - grades >= 48: -> good_college
    - grades >= 34: -> barely
    - else: -> repeat_year
}

// ---------------------------------------------------------------- ENDINGS

=== prestigious ===
SECONDARY SCHOOL COMPLETE: THE MOST PRESTIGIOUS COLLEGE! # ending: prestigious
Straight As across the board. A week later, the most prestigious college in the country offers you a place, and a scholarship as well.
Mr. Lim shakes your hand. "I knew it from the first day," he says.
-> END

=== good_college ===
SECONDARY SCHOOL COMPLETE: A GOOD COLLEGE! # ending: good
Solid results. You get into a good college with a great reputation, and Priya is going there too.
Your parents take everyone out for dinner.
-> END

=== barely ===
SECONDARY SCHOOL COMPLETE: YOU BARELY MADE IT TO COLLEGE! # ending: barely
Your results squeak past the cut-off by a single point. A college accepts you from its waiting list, two days before term starts.
Close enough. You made it.
-> END

=== repeat_year ===
REPEAT A YEAR IN SECONDARY SCHOOL! # ending: repeat
Your results are too low to move on. Next year you'll be doing Sec {year} all over again, with a new class of younger students who keep asking you for directions.
Mr. Lim says everyone deserves a second chance. You plan to use yours.
-> END

=== expelled ===
EXPELLED FROM SECONDARY SCHOOL! # ending: expelled
Three strikes. The discipline master closes his little black book, and the principal calls your parents in for a very short meeting.
You clear out your locker while the whole corridor watches.
-> END

=== vanished ===
THE ORDER OF THE CLOCK TOWER # ending: vanished
You joined the secret society, and after a while, no one really knew what happened to you.
Some say you still walk the corridors at midnight in a grey blazer. On quiet nights, the old clock tower strikes thirteen.
-> END

=== billionaire ===
DROPPED OUT AND BECAME A BILLIONAIRE! # ending: billionaire
You and Jun work out of a tiny rented office for two years. Then the app goes global.
At thirty, you're a billionaire. You donate a new library to your old school, and Mr. Lim cuts the ribbon.
-> END
