I want to build a site for writting markdown.
I have to write a lot of markdown texts today because I am currently writting prompts.

So I want to create a site that will help me to write those markdowns.
The overall goal is to make typing more easy.

It will have specific things that will help me a lot by the way.
So, when the user opens the site we will see in the top a appbar (slow contrast with the bottom) with the logo and other things...

Bellow will be 3 sections – 2 of them allways visible and the other being accessible via a label in the right of the screen.
Let's 
In the right, having around 30% of the screen, will be the "navigation panel".
And in the rest, the left side, will be the place where the user will be the place where the user will effectively write the markdown.
In the TOTAL left, completely glued to the right side of the screen, will be a tinny card wrote "See preview" in vertical and with a arrow pointing to the right. 
When the user hovers the mouse above it (no need to click) the label card will expand (on top of everything, nothing will change bellow) and show the preview of how the readme looks like with a world class readme processor.

Now let's talk better about each section:

# Appbar
The appbar will have in the total left of it the logo. In the end of the appbar row, at the total right, a button to download the readme as a file and a button to copy it (icon buttons).
In the middle of the appbar, between the logo and icons, will be the tabs that represent the current readme the user is currently focused in. And in the end of the listage, a "add" button so the user can click to add a new tab.
Also, when the user hovers the mouse above a tab there should be a animation where the right part of the card that represents the tab expands (the tab card stays bigger horizontally) and apears a icon to delete and a icon to rename (that when clicked will focus the text cursor on the name of the tab so the user can re-name it).
By the way, if the number of tabs is big it should have a horizontal scroll so the user can scroll to the right/left to see tabs, but do not show scrollbars since they are not elegant at all. And when the area of the tabs is near to a edge it should fade out in a gradient fading effect so there is no brutal cut that indicates where the area of the horizontal scroll ends – the smooth fade out gradient in the right/left borders is better...

# The Navigation panel (left side, around 30% of the space available)
Should basically show the headlines of the current typed markdown in a structured way.
It should follow the hierarchy of headlines in readme. That is; a "#" means the highest hierarchy, the "##" is the second highest hierarchy and so on.
They should apear in a expandable way. And in the top that should be a icon to colapse all.
So the user will see the title and a button to expand/colapse that tab. Build a nice looking ui for this hierarchy view.
Also, when the user clicks in it it should go directly to the part on the text of that header – so the ui should indicate that section is clicable by putting a hover animation when I put the mouse on top of it and then a small "shink" effect when clicked where it shrink it's size and then go back, giving the effect of a button clicked.

# The Readme Textbox section
This is the main part where the user will be: typing in this textbox – so this could be a outstanding perfomance and UX.
So it is basically a text box.
But in the RIGHT of the textbox I want there to be a nubmer that represents the number of the line. Like vscode has.
In the right of each line could 
I want you to make all the headline lines should be 

# The readme visualizer

Intensidade, Volume and Explosion